#!/usr/bin/perl
# ============================================================
#  Turn the six projects in content.pl into the JSON the
#  dashboard seeds itself from on its first migration.
#
#      perl seed-projects.pl
#
#  Writes admin/seed-projects.json. Run it again only if the
#  starting set in content.pl changes; once the projects are in
#  the database the dashboard is the source of truth.
# ============================================================
use strict;
use warnings;
use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

our (%C, @SERVICES, @PROJECTS, @WORKS, @GALLERY, @FULLSERVICES,
     %T, %CATNAME, @NAV, @PROCESS, @LOCATIONS,
     %SVC_FEATURES, %PROJ_FACTS, %PROJ_WORKS, @GENERIC_SCOPE,
     @SECTORS, %SECTOR, %POOL_PRICES, @POOL_SPEC);

do './content.pl' or die "content.pl: " . ($@ || $!);

# A small JSON writer: the data is ours and shallow, so this stays
# shorter than pulling in a module that may not be installed.
sub esc {
  my $s = shift;
  return 'null' unless defined $s;
  $s =~ s/\\/\\\\/g;
  $s =~ s/"/\\"/g;
  $s =~ s/\n/\\n/g;
  $s =~ s/\r//g;
  $s =~ s/\t/\\t/g;
  return '"' . $s . '"';
}

# The long text of a project page is the scope lines the ledger holds for
# it, one per line; where the ledger says nothing, the generic scope.
sub body_for {
  my ($slug, $i) = @_;
  my @pairs;
  if (my $refs = $PROJ_WORKS{$slug}) {
    push @pairs, @{ $WORKS[$_]{d} } for @$refs;
  }
  @pairs = @GENERIC_SCOPE unless @pairs;
  return join "\n", map { $_->[$i] } @pairs;
}

my @out;
for my $p (@PROJECTS) {
  my $f = $PROJ_FACTS{ $p->{slug} } || {};
  push @out, join ",\n", map { '    ' . $_ } (
    '"slug": '      . esc($p->{slug}),
    '"sec": '       . esc($p->{sec}),
    '"tag": '       . esc($p->{tag}),
    '"title_ar": '  . esc($p->{t}[0]),
    '"title_en": '  . esc($p->{t}[1]),
    '"lead_ar": '   . esc($p->{d}[0]),
    '"lead_en": '   . esc($p->{d}[1]),
    '"place_ar": '  . esc($f->{loc} ? $f->{loc}[0] : undef),
    '"place_en": '  . esc($f->{loc} ? $f->{loc}[1] : undef),
    '"client_ar": ' . esc($f->{client} ? $f->{client}[0] : undef),
    '"client_en": ' . esc($f->{client} ? $f->{client}[1] : undef),
    '"scope_ar": '  . esc($f->{scope} ? $f->{scope}[0] : undef),
    '"scope_en": '  . esc($f->{scope} ? $f->{scope}[1] : undef),
    '"body_ar": '   . esc(body_for($p->{slug}, 0)),
    '"body_en": '   . esc(body_for($p->{slug}, 1)),
    '"cover": '     . esc($p->{img}),
  );
}

my $json = "[\n  {\n" . join("\n  },\n  {\n", @out) . "\n  }\n]\n";

open my $fh, '>:encoding(UTF-8)', 'admin/seed-projects.json' or die "write: $!";
print {$fh} $json;
close $fh;

print "admin/seed-projects.json — ", scalar @PROJECTS, " projects\n";
