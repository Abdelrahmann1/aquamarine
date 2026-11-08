#!/usr/bin/perl
# ============================================================
#  AQUA MARINE WATER SYSTEMS — deploy the built site to the host
#
#      perl deploy.pl              build, then upload what changed
#      perl deploy.pl --dry-run    list what would go up, send nothing
#      perl deploy.pl --all        ignore the manifest, send everything
#      perl deploy.pl --no-build   send the files as they stand
#      perl deploy.pl --check      test the connection and stop
#
#  Only the generated site travels: the .html pages, ar/ and assets/.
#  build.pl, content.pl, serve.pl and this file stay on the machine.
#
#  Settings live in deploy.conf, which git never sees. Copy
#  deploy.conf.example to deploy.conf and fill it in.
#
#  Two transports, one behaviour:
#    ssh   — a tar stream over SSH, key only, no password anywhere
#    ftps  — Pure-FTPd with AUTH TLS, the password read from deploy.conf
#
#  A manifest of SHA-1 sums is kept on the server, so a deploy carries
#  only the files whose contents actually changed. The two 23 MB profile
#  PDFs go up once, not on every run.
# ============================================================
use strict;
use warnings;
use Digest::SHA qw(sha1_hex);
use File::Find;
use File::Temp qw(tempfile);

my %opt;
for my $a (@ARGV) {
  if    ($a =~ /^--([^=]+)=(.*)$/) { $opt{$1} = $2 }
  elsif ($a =~ /^--(.+)$/)         { $opt{$1} = 1  }
}
$| = 1;

# ------------------------------------------------------------
#  Settings
# ------------------------------------------------------------
my %cfg = (
  transport => 'ftps',
  host      => '',
  user      => '',
  pass      => '',
  port      => '',
  root      => 'public_html',      # relative to the login directory
  manifest  => '.deploy-manifest', # kept out of public_html
  key       => '',
  site      => '',                 # the public address, for the closing line
);

if (!-f 'deploy.conf') {
  die "deploy.conf is missing.\n"
    . "Copy deploy.conf.example to deploy.conf and fill in the account details.\n";
}
open my $cf, '<', 'deploy.conf' or die "deploy.conf: $!";
while (my $line = <$cf>) {
  $line =~ s/\r?\n\z//;
  next if $line =~ /^\s*(?:#|$)/;
  next unless my ($k, $v) = $line =~ /^\s*(\w+)\s*=\s*(.*?)\s*$/;
  $v =~ s/^(["'])(.*)\1$/$2/;
  $cfg{lc $k} = $v;
}
close $cf;

if ($cfg{key}) { my $h = $ENV{HOME} || ''; $cfg{key} =~ s{^~}{$h} }
$cfg{site} ||= $cfg{host};
my $ftp = lc($cfg{transport}) eq 'ssh' ? 0 : 1;
$cfg{port} ||= $ftp ? 21 : 22;
$cfg{root} =~ s{^/+}{};
$cfg{root} =~ s{/+$}{};
die "deploy.conf: host and user are required.\n" unless $cfg{host} && $cfg{user};
die "deploy.conf: an FTPS deploy needs pass.\n" if $ftp && !$cfg{pass};
die "deploy.conf: an SSH deploy needs key.\n"   if !$ftp && !$cfg{key};
die "The SSH key is not at $cfg{key}\n"         if !$ftp && !-f $cfg{key};

# ------------------------------------------------------------
#  Transport
# ------------------------------------------------------------
my @SSH = ('ssh', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=accept-new',
           '-o', 'ConnectTimeout=20', '-i', $cfg{key}, '-p', $cfg{port},
           $cfg{user} . '@' . $cfg{host});

sub shq {
  my $s = shift;
  $s =~ s/'/'\\''/g;
  return "'" . $s . "'";
}
sub ssh_cmd { return join ' ', map { shq($_) } @SSH }

# curl keeps the password in a 0600 config file, never on the command line
# where any other process on the machine could read it.
my $authfile;
sub auth_file {
  return $authfile if $authfile;
  my $fh;
  ($fh, $authfile) = tempfile('aqua-auth-XXXXXX', TMPDIR => 1, UNLINK => 1);
  chmod 0600, $authfile;
  print {$fh} 'user = "' . $cfg{user} . ':' . $cfg{pass} . '"' . "\n";
  print {$fh} "--ssl-reqd\n--ftp-skip-pasv-ip\n--connect-timeout 30\n";
  close $fh;
  return $authfile;
}

sub url_of {
  my $path = shift;
  $path =~ s{([^A-Za-z0-9._~\-/])}{sprintf '%%%02X', ord $1}ge;
  return 'ftp://' . $cfg{host} . ':' . $cfg{port} . '/' . $path;
}

# Every remote path is relative to the login directory. An FTP account
# locked to public_html logs straight into the site, so root is empty
# there; the main account logs into /home and root is 'public_html'.
sub rpath {
  my $p = shift;
  return $cfg{root} ? $cfg{root} . '/' . $p : $p;
}

# ------------------------------------------------------------
#  Which files make up the site
# ------------------------------------------------------------
sub site_files {
  my @f = glob('*.html *.php *.xml *.txt *.ico *.webmanifest');
  push @f, '.htaccess' if -f '.htaccess';
  for my $dir (qw(ar assets admin inc)) {
    next unless -d $dir;
    find({ no_chdir => 1, wanted => sub {
      my $p = $File::Find::name;
      return unless -f $p;
      $p =~ s{^\./}{};
      # Dotfiles stay here, and so does anything under .git — but the
      # server needs .htaccess, so that one travels.
      return if $p =~ m{(?:^|/)\.} && $p !~ m{(?:^|/)\.htaccess$};
      push @f, $p;
    }}, $dir);
  }
  return sort @f;
}

# ------------------------------------------------------------
#  Build, unless told not to
# ------------------------------------------------------------
unless ($opt{'no-build'} || $opt{check} || $opt{ls} || $opt{get}) {
  system($^X, 'build.pl') == 0 or die "build.pl failed — nothing was sent.\n";
  print "\n";
}

# ------------------------------------------------------------
#  Connection check
# ------------------------------------------------------------
print 'Host      ' . $cfg{user} . '@' . $cfg{host} . ':' . $cfg{port}
    . '  (' . ($ftp ? 'FTPS' : 'SSH') . ")\n";
print 'Site      ' . ($cfg{root} ? '/' . $cfg{root} : 'the login directory') . "\n";

my $probe = $ftp
  ? 'curl -sS -K ' . shq(auth_file()) . ' ' . shq(url_of(rpath(''))) . ' >/dev/null'
  : ssh_cmd() . ' ' . shq('test -d ' . shq($cfg{root} || '.')) . ' >/dev/null 2>&1';
if (system($probe) != 0) {
  die "\nCould not reach the site directory. Check deploy.conf, and that the account is open.\n";
}
print "Connected.\n\n";
exit 0 if $opt{check};

# --get=path prints one file off the server, for reading before replacing it.
if ($opt{get} && $opt{get} ne '1') {
  my $cmd = $ftp
    ? 'curl -sS -K ' . shq(auth_file()) . ' ' . shq(url_of(rpath($opt{get})))
    : ssh_cmd() . ' ' . shq('cat ' . shq(rpath($opt{get})));
  system($cmd);
  exit 0;
}

# --ls shows what the server is holding right now, and changes nothing.
if ($opt{ls}) {
  my $cmd = $ftp
    ? 'curl -sS -K ' . shq(auth_file()) . ' --request ' . shq('LIST -R') . ' '
      . shq(url_of(rpath('')))
    : ssh_cmd() . ' ' . shq('ls -lR ' . shq($cfg{root} || '.'));
  system($cmd);
  exit 0;
}

# ------------------------------------------------------------
#  What changed since the last deploy
# ------------------------------------------------------------
my @files = site_files();
die "No built files found — run perl build.pl first.\n" unless @files;

my %now;
for my $f (@files) {
  open my $fh, '<:raw', $f or die "$f: $!";
  local $/;
  my $data = <$fh>;
  close $fh;
  $now{$f} = sha1_hex(defined $data ? $data : '');
}

my %was;
unless ($opt{all}) {
  my $cmd = $ftp
    ? 'curl -s -K ' . shq(auth_file()) . ' ' . shq(url_of($cfg{manifest})) . ' 2>/dev/null'
    : ssh_cmd() . ' ' . shq('cat ' . shq($cfg{manifest})) . ' 2>/dev/null';
  my $txt = `$cmd`;
  for my $line (split /\n/, (defined $txt ? $txt : '')) {
    $was{$2} = $1 if $line =~ /^([0-9a-f]{40})\t(.+)$/;
  }
}

my @up   = grep { !defined $was{$_} || $was{$_} ne $now{$_} } @files;
my @gone = grep { !exists $now{$_} } sort keys %was;

my $bytes = 0;
$bytes += -s $_ for @up;
my $mb = sprintf '%.1f', $bytes / 1048576;

if (!@up && !@gone) {
  print "Everything on the server is already up to date.\n";
  exit 0;
}

printf "%d file%s to upload (%s MB)%s\n", scalar @up, (@up == 1 ? '' : 's'), $mb,
  (@gone ? sprintf(', %d to delete', scalar @gone) : '');
print '   + ' . $_ . "\n" for @up;
print '   - ' . $_ . "\n" for @gone;

if ($opt{'dry-run'}) { print "\nDry run — nothing was sent.\n"; exit 0 }
print "\n";

# ------------------------------------------------------------
#  Send
# ------------------------------------------------------------
sub chunks {
  my ($n, @l) = @_;
  my @c;
  push @c, [splice @l, 0, $n] while @l;
  return @c;
}

if (@up) {
  if ($ftp) {
    # One curl run per batch: the control connection is opened once and
    # every file in the batch rides it.
    my $done = 0;
    for my $batch (chunks(40, @up)) {
      my ($fh, $list) = tempfile('aqua-put-XXXXXX', TMPDIR => 1, UNLINK => 1);
      for my $f (@$batch) {
        print {$fh} 'upload-file = "' . $f . '"' . "\n";
        print {$fh} 'url = "' . url_of(rpath($f)) . '"' . "\n";
      }
      close $fh;
      my $cmd = 'curl -sS -K ' . shq(auth_file()) . ' --ftp-create-dirs -K ' . shq($list);
      system($cmd) == 0 or die "\nUpload failed. The server may be part-updated.\n";
      $done += scalar @$batch;
      print '   ' . $done . ' / ' . scalar(@up) . "\n";
    }
  }
  else {
    my ($fh, $list) = tempfile('aqua-put-XXXXXX', TMPDIR => 1, UNLINK => 1);
    print {$fh} $_ . "\n" for @up;
    close $fh;
    my $sroot = $cfg{root} || '.';
    my $cmd = 'tar -czf - -T ' . shq($list) . ' | ' . ssh_cmd() . ' '
            . shq('mkdir -p ' . shq($sroot) . ' && tar -xzf - -C ' . shq($sroot));
    system($cmd) == 0 or die "\nUpload failed. The server may be part-updated.\n";
  }
  print 'Uploaded ' . scalar(@up) . " files.\n";
}

# A file dropped from the site is dropped from the server too, so an old
# page cannot sit there answering a URL the new build no longer has.
if (@gone) {
  for my $batch (chunks(30, @gone)) {
    my $cmd;
    if ($ftp) {
      my ($fh, $q) = tempfile('aqua-del-XXXXXX', TMPDIR => 1, UNLINK => 1);
      print {$fh} 'quote = "*DELE ' . rpath($_) . '"' . "\n" for @$batch;
      print {$fh} 'url = "' . url_of(rpath('')) . '"' . "\n";
      close $fh;
      $cmd = 'curl -sS -K ' . shq(auth_file()) . ' -K ' . shq($q) . ' -o /dev/null';
    }
    else {
      $cmd = ssh_cmd() . ' ' . shq('cd ' . shq($cfg{root} || '.') . ' && rm -f '
           . join ' ', map { shq(shq($_)) } @$batch);
    }
    system($cmd) == 0 or warn "   could not delete some files\n";
  }
  print 'Deleted ' . scalar(@gone) . " files.\n";
}

# ------------------------------------------------------------
#  Record what the server now holds
# ------------------------------------------------------------
my ($mfh, $mfile) = tempfile('aqua-man-XXXXXX', TMPDIR => 1, UNLINK => 1);
print {$mfh} $now{$_} . "\t" . $_ . "\n" for @files;
close $mfh;

my $save = $ftp
  ? 'curl -sS -K ' . shq(auth_file()) . ' -T ' . shq($mfile) . ' ' . shq(url_of($cfg{manifest}))
  : 'cat ' . shq($mfile) . ' | ' . ssh_cmd() . ' ' . shq('cat > ' . shq($cfg{manifest}));
system($save) == 0 or warn "Could not save the manifest — the next deploy will send everything.\n";

print "\nDone. https://" . $cfg{site} . "/\n";
