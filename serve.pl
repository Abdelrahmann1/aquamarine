#!/usr/bin/perl
# Tiny static file server for local preview:  perl serve.pl [port]
use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Status;

# A browser that drops a connection mid-response (an aborted image or video
# fetch) would otherwise kill this process with SIGPIPE.
$SIG{PIPE} = q{IGNORE};

my $port = $ARGV[0] || 8099;
my $d = HTTP::Daemon->new(LocalAddr => '127.0.0.1', LocalPort => $port, ReuseAddr => 1, Listen => 128)
  or die "Cannot bind port $port: $!";
print "Serving " . `pwd` . "at " . $d->url . "\n";
$| = 1;

my %MIME = (
  html=>'text/html; charset=utf-8', css=>'text/css; charset=utf-8',
  js=>'application/javascript; charset=utf-8', json=>'application/json',
  png=>'image/png', jpg=>'image/jpeg', jpeg=>'image/jpeg', gif=>'image/gif',
  svg=>'image/svg+xml', webp=>'image/webp', ico=>'image/x-icon',
  woff2=>'font/woff2', woff=>'font/woff', ttf=>'font/ttf', pdf=>'application/pdf',
);

while (my $c = $d->accept) {
  # One request per connection, then close. This server is single-threaded,
  # so honouring keep-alive would block every other parallel asset request.
  if (my $r = $c->get_request) {
    my $p = $r->uri->path;
    $p =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/ge;
    $p = '/index.html' if $p eq '/';
    $p =~ s{^/}{};
    $p =~ s{\.\.}{}g;
    if (-f $p) {
      my ($ext) = $p =~ /\.([A-Za-z0-9]+)$/;
      my $type = $MIME{lc($ext || '')} || 'application/octet-stream';
      open(my $fh, '<:raw', $p) or do { $c->send_error(RC_INTERNAL_SERVER_ERROR); next; };
      local $/; my $body = <$fh>; close $fh;
      my $res = HTTP::Response->new(200);
      $res->header('Content-Type' => $type);
      $res->header('Cache-Control' => 'no-cache');
      $res->header('Connection' => 'close');
      $res->content($body);
      $c->send_response($res);
    } else {
      $c->send_error(RC_NOT_FOUND);
    }
  }
  $c->close;
  undef $c;
}
