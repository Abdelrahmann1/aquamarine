#!/usr/bin/perl
# ============================================================
#  AQUA MARINE WATER SYSTEMS — bilingual static site generator
#
#      perl build.pl
#
#  Content lives in content.pl. This file is markup only.
#  English (LTR) is written to  ./          Arabic (RTL) to  ./ar/
# ============================================================
use strict;
use warnings;
use utf8;
binmode(STDOUT, ':encoding(UTF-8)');

our (%C, @SERVICES, @PROJECTS, @WORKS, @GALLERY, @FULLSERVICES,
     %T, %CATNAME, @NAV, @PROCESS, @LOCATIONS,
     %SVC_FEATURES, %PROJ_FACTS, %PROJ_WORKS, @GENERIC_SCOPE);

do './content.pl' or die "content.pl: " . ($@ || $!);

# ------------------------------------------------------------
#  Language state
# ------------------------------------------------------------
our $L   = 0;    # 0 = Arabic, 1 = English
our $A   = '';   # asset path prefix ('' or '../')
our $OUT = '.';
our $DIR = 'rtl';
our $LANG= 'ar';

sub t { my $p = shift; return (ref($p) eq 'ARRAY') ? $p->[$L] : (defined $p ? $p : ''); }
sub ar { return $L == 0; }
sub fwd { return ar() ? 'arrowl' : 'arrowr'; }
sub back { return ar() ? 'arrowr' : 'arrowl'; }

my @AI = ('٠١','٠٢','٠٣','٠٤','٠٥','٠٦','٠٧','٠٨','٠٩');
my @LN = ('01','02','03','04','05','06','07','08','09');
sub numeral { my $i = shift; return ar() ? $AI[$i] : $LN[$i]; }

# ============================================================
#  ICONS
# ============================================================
my %I = (
  phone   => '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.9.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92z"/>',
  mail    => '<path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/>',
  pin     => '<path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>',
  clock   => '<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>',
  check   => '<polyline points="20 6 9 17 4 12"/>',
  arrowl  => '<line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>',
  arrowr  => '<line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>',
  arrowu  => '<line x1="12" y1="19" x2="12" y2="5"/><polyline points="5 12 12 5 19 12"/>',
  chevd   => '<polyline points="6 9 12 15 18 9"/>',
  chevl   => '<polyline points="15 18 9 12 15 6"/>',
  chevr   => '<polyline points="9 18 15 12 9 6"/>',
  close   => '<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>',
  play    => '<polygon points="6 3 20 12 6 21 6 3" fill="currentColor" stroke="none"/>',
  zoom    => '<circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/><line x1="11" y1="8" x2="11" y2="14"/><line x1="8" y1="11" x2="14" y2="11"/>',
  dl      => '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>',
  file    => '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>',
  refresh => '<polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>',
  info    => '<circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>',
  send    => '<line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/>',
  wa      => '<path d="M17.5 14.4c-.3-.2-1.7-.9-2-1s-.5-.2-.7.1-.8 1-.9 1.2-.3.2-.6.1a8 8 0 0 1-2.4-1.5 9 9 0 0 1-1.6-2c-.2-.3 0-.5.1-.6l.5-.6a2 2 0 0 0 .3-.5.6.6 0 0 0 0-.5c0-.2-.7-1.6-.9-2.2s-.5-.5-.7-.5h-.6a1.1 1.1 0 0 0-.8.4A3.4 3.4 0 0 0 6 9.3a5.9 5.9 0 0 0 1.2 3.1 13.4 13.4 0 0 0 5.2 4.6c.7.3 1.3.5 1.7.6a4.1 4.1 0 0 0 1.9.1 3.1 3.1 0 0 0 2-1.4 2.5 2.5 0 0 0 .2-1.4c-.1-.2-.3-.3-.6-.4z" fill="currentColor" stroke="none"/><path d="M12 2a10 10 0 0 0-8.6 15L2 22l5.2-1.4A10 10 0 1 0 12 2zm0 18.2a8.2 8.2 0 0 1-4.2-1.1l-.3-.2-3.1.8.8-3-.2-.3A8.2 8.2 0 1 1 12 20.2z"/>',
  fb      => '<path d="M15.5 8.5h-2v-1c0-.6.4-.7.6-.7h1.3V4.6h-1.9c-2.1 0-2.6 1.6-2.6 2.6v1.3H9.6v2.3h1.3V19h2.6v-8.2h1.8z" fill="currentColor" stroke="none"/>',
  ig      => '<rect x="3" y="3" width="18" height="18" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1.1" fill="currentColor" stroke="none"/>',
  tw      => '<path d="M4 4l7 8.5L4.3 20H6l5.8-6.4L16.5 20H20l-7.3-8.9L19.5 4H18l-5.4 6L8.2 4z" fill="currentColor" stroke="none"/>',
  yt      => '<path d="M22 12s0-3-.4-4.4a2.6 2.6 0 0 0-1.8-1.8C18.4 5.4 12 5.4 12 5.4s-6.4 0-7.8.4a2.6 2.6 0 0 0-1.8 1.8C2 9 2 12 2 12s0 3 .4 4.4a2.6 2.6 0 0 0 1.8 1.8c1.4.4 7.8.4 7.8.4s6.4 0 7.8-.4a2.6 2.6 0 0 0 1.8-1.8C22 15 22 12 22 12z"/><polygon points="10.2 15 15 12 10.2 9" fill="currentColor" stroke="none"/>',
  li      => '<rect x="3" y="3" width="18" height="18" rx="3"/><line x1="8" y1="11" x2="8" y2="16"/><circle cx="8" cy="7.8" r="1" fill="currentColor" stroke="none"/><path d="M12 16v-3a2 2 0 0 1 4 0v3"/><line x1="12" y1="11" x2="12" y2="16"/>',
);
sub ic { my ($k,$cls) = @_; $cls = $cls ? "i $cls" : 'i';
  return qq{<svg class="$cls" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">$I{$k}</svg>}; }

# ============================================================
#  SHARED CHUNKS
# ============================================================
sub nav_html {
  my ($active) = @_;
  # the first <li> is the white "ink" that JS slides under the hovered link
  my $o = '<ul class="nav"><li class="ink" aria-hidden="true"></li>';
  for my $n (@NAV) {
    my ($href,$label,$sub) = @$n;
    my $on = ($href eq $active) ? ' active' : '';
    if ($sub) {
      $o .= qq{<li class="has-mega$on"><a href="$href" aria-haspopup="true" aria-expanded="false" aria-controls="mega">@{[t($label)]}} . ic('chevd','car') . q{</a></li>};
    } else {
      $o .= qq{<li class="$on"><a href="$href">@{[t($label)]}</a></li>};
    }
  }
  return $o . '</ul>';
}

# the logo's wave bands, laid along the foot of the navy brand cards
sub card_waves {
  return q{<svg class="waves" viewBox="0 0 280 120" preserveAspectRatio="none" aria-hidden="true">}
       . q{<path d="M0 34C60 14 120 54 180 34S258 14 280 26V120H0Z" fill="#1d5fae" opacity=".5"/>}
       . q{<path d="M0 60C60 40 120 80 180 60S258 40 280 52V120H0Z" fill="#2589cd" opacity=".6"/>}
       . q{<path d="M0 86C60 66 120 106 180 86S258 66 280 78V120H0Z" fill="#6aaade" opacity=".75"/></svg>};
}

# services mega panel: nine numbered links plus a brand card
sub mega_html {
  my $o = q{<div class="mega" id="mega"><div class="mega-grid">};
  my $n = 0;
  for my $s (@SERVICES) {
    $o .= qq{<a href="service-$s->{slug}.html"><span class="mn">@{[numeral($n)]}</span>}
        . qq{<span><span class="mt">@{[t($s->{t})]}</span><span class="md">@{[t($s->{d})]}</span></span></a>};
    $n++;
  }
  my ($h, $p) = ar()
    ? ('حلول مياه متكاملة منذ 2004', 'من التصميم والحسابات حتى التنفيذ والصيانة الدورية — بفريق واحد.')
    : ('Complete water systems since 2004', 'From design and engineering to installation and scheduled maintenance — one team.');
  $o .= q{</div><div class="mega-card">} . card_waves()
      . qq{<span class="since">EST. 2004</span><h4>$h</h4><p>$p</p>}
      . qq{<a class="cta-pill" href="order.html">@{[t($T{order_now})]}} . ic(fwd(),'ic') . q{</a></div></div>};
  return $o;
}

sub lang_html {
  my ($file) = @_;
  my $other = ar() ? "../$file" : "ar/$file";
  my ($cur,$alt,$altlang) = ar() ? ('AR','EN','en') : ('EN','AR','ar');
  return qq{<div class="lang"><span class="on">$cur</span>}
       . qq{<a href="$other" hreflang="$altlang" lang="$altlang">$alt</a></div>};
}

sub social_html {
  return qq{<div class="soc">}
    . qq{<a href="$C{fb}" target="_blank" rel="noopener" aria-label="Facebook">} . ic('fb') . q{</a>}
    . qq{<a href="$C{ig}" target="_blank" rel="noopener" aria-label="Instagram">} . ic('ig') . q{</a>}
    . qq{<a href="$C{tw}" target="_blank" rel="noopener" aria-label="Twitter">} . ic('tw') . q{</a>}
    . qq{<a href="$C{yt}" target="_blank" rel="noopener" aria-label="YouTube">} . ic('yt') . q{</a>}
    . qq{<a href="$C{li}" target="_blank" rel="noopener" aria-label="LinkedIn">} . ic('li') . q{</a>}
    . q{</div>};
}

# mobile menu: a panel that drops out of the capsule under the burger — the
# numbered pages, the services folding open in place, and a brand card with
# the quote, WhatsApp and call actions. It stays `hidden` (display:none) until
# the burger opens it, so nothing inside costs anything on page load.
sub mmenu_html {
  my ($active,$file) = @_;
  my $o = qq{<div class="mm" id="mmenu" hidden><nav class="mm-nav" aria-label="@{[t($T{menu})]}"><ul>};
  my $i = 0;
  for my $n (@NAV) {
    my ($href,$label,$sub) = @$n;
    my $on  = $href eq $active;
    my @cls = (($sub ? 'has-sub' : ()), ($on ? 'on' : ()));
    my $li  = @cls ? qq{<li class="@cls">} : '<li>';
    my $a   = qq{<a href="$href"} . ($on ? ' aria-current="page"' : '') . '>'
            . sprintf('<span class="n">%02d</span>', ++$i) . qq{<span class="t">@{[t($label)]}</span>};
    if ($sub) {
      $o .= qq{$li<div class="mm-row">$a</a>}
          . qq{<button class="mm-tg" type="button" aria-expanded="false" aria-controls="mm-sub" aria-label="@{[t($T{our_services})]}">} . ic('chevd') . q{</button></div>}
          . q{<div class="mm-sub" id="mm-sub"><div class="mm-sub-in"><div class="mm-grid">};
      my $k = 0;
      for my $s (@SERVICES) {
        my $cur = $file eq "service-$s->{slug}.html" ? ' class="on" aria-current="page"' : '';
        $o .= qq{<a href="service-$s->{slug}.html"$cur><span class="mn">@{[numeral($k++)]}</span><span class="st">@{[t($s->{t})]}</span></a>};
      }
      $o .= qq{<a class="all" href="services.html"><span class="st">@{[t($T{all_services})]}</span>} . ic(fwd(),'ic') . q{</a>}
          . q{</div></div></div></li>};
    } else {
      $o .= "$li$a" . ic(fwd(),'go') . q{</a></li>};
    }
  }
  $o .= q{</ul></nav>}
      . q{<div class="mega-card mm-card">} . card_waves()
      . qq{<span class="since">EST. 2004</span><h4>@{[t($T{mm_h})]}</h4><p>@{[t($T{contact_lead})]}</p>}
      . q{<div class="mm-acts">}
      . qq{<a class="cta-pill" href="order.html">@{[t($T{order_now})]}} . ic(fwd(),'ic') . q{</a>}
      . qq{<a class="mm-ic" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener" aria-label="@{[t($T{whatsapp})]}">} . ic('wa') . q{</a>}
      . qq{<a class="mm-ic" href="tel:$C{mobile}" aria-label="@{[t($T{call_us})]}">} . ic('phone') . q{</a>}
      . q{</div></div>}
      . qq{<div class="mm-foot"><span>@{[t($T{follow})]}</span>} . social_html() . q{</div>}
      . q{</div>};
  return $o;
}

# Microsoft Clarity (heatmaps and session recordings). Written only when
# content.pl holds a project ID; each session is tagged with its language.
sub clarity_html {
  (my $id = $C{clarity} // '') =~ s/[^A-Za-z0-9]//g;
  return '' unless length $id;
  return qq{<script>(function(c,l,a,r,i,t,y){c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i;y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y)})(window,document,"clarity","script","$id");clarity("set","lang","$LANG");</script>};
}

sub head_html {
  my ($title,$desc,$file) = @_;
  my $ar_href = ar() ? $file : "ar/$file";
  my $en_href = ar() ? "../$file" : $file;
  return <<"HTML";
<!DOCTYPE html>
<html lang="$LANG" dir="$DIR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$title</title>
<meta name="description" content="$desc">
<meta name="theme-color" content="#25306b">
<meta property="og:type" content="website">
<meta property="og:title" content="$title">
<meta property="og:description" content="$desc">
<meta property="og:image" content="${A}assets/img/a-1.jpg">
<meta property="og:locale" content="@{[ ar() ? 'ar_EG' : 'en_US' ]}">
<link rel="alternate" hreflang="ar" href="$ar_href">
<link rel="alternate" hreflang="en" href="$en_href">
<link rel="alternate" hreflang="x-default" href="$en_href">
<link rel="icon" href="${A}assets/img/favicon.png" type="image/png">
<link rel="stylesheet" href="${A}assets/css/main.css">
<link rel="stylesheet" href="${A}assets/css/sections.css">
@{[ $file eq 'index.html' ? qq{<link rel="stylesheet" href="${A}assets/css/home.css">} : '' ]}
<script>document.documentElement.classList.add('rv');setTimeout(function(){if(!window.rvReady)document.documentElement.classList.remove('rv')},3000)</script>@{[ clarity_html() ]}
</head>
<body>
<div class="progress"><i></i></div>
HTML
}

# the floating capsule: logo · nav (with sliding ink + mega panel) · actions;
# below 1180px the burger drops the mobile menu out of the same capsule
sub header_html {
  my ($active,$file) = @_;
  return qq{<header class="hdr"><div class="wrap"><div class="cap">}
    . qq{<a class="brand" href="index.html"><img src="${A}assets/img/logo-aquamarine.png" alt="@{[t($C{full})]}" width="1002" height="227"></a>}
    . nav_html($active)
    . q{<div class="acts">} . lang_html($file)
    . qq{<a class="icon-btn" href="tel:$C{mobile}" aria-label="@{[t($T{call_us})]}">} . ic('phone') . q{</a>}
    . qq{<a class="cta-pill" href="order.html">@{[t($T{order_now})]}} . ic(fwd(),'ic') . q{</a>}
    . qq{<button class="burger" type="button" aria-label="@{[t($T{menu})]}" aria-expanded="false" aria-controls="mmenu"><span></span><span></span><span></span></button>}
    . q{</div>} . mega_html() . mmenu_html($active,$file)
    . q{</div></div></header>}
    . q{<div class="mm-scrim" aria-hidden="true"></div>};
}

sub footer_html {
  my $links = '';
  $links .= qq{<li><a href="$_->[0]">@{[t($_->[1])]}</a></li>} for @NAV[1..$#NAV];
  $links .= qq{<li><a href="order.html">@{[t($T{order_now})]}</a></li>};
  my $svc = '';
  $svc .= qq{<li><a href="service-$_->{slug}.html">@{[t($_->{t})]}</a></li>} for @SERVICES[0..5];
  # the developer's name closes the page, as a link once content.pl gives it a URL
  my $dev = $C{dev_url}
    ? qq{<a class="f-dev" href="$C{dev_url}" target="_blank" rel="noopener">$C{dev}</a>}
    : qq{<b class="f-dev">$C{dev}</b>};

  return <<"HTML" . fabs_html() . qq{<script src="${A}assets/js/main.js"></script>\n</body>\n</html>\n};
<footer class="footer">
  <div class="wrap">
    <div class="f-grid">
      <div>
        <img class="flogo" src="${A}assets/img/logo-aquamarine-plate.jpg" alt="@{[t($C{full})]}" width="1002" height="227">
        <p style="font-size:.94rem;line-height:1.9;max-width:44ch">@{[t($T{footer_blurb})]}</p>
        <div class="f-contact" style="margin-top:1.5em">
          <div>@{[ic('pin')]}<span>@{[t($C{addr})]}</span></div>
          <div>@{[ic('phone')]}<span><a class="tnum" href="tel:$C{mobile}">$C{mobile}</a> · <a class="tnum" href="tel:$C{land}">$C{land}</a></span></div>
          <div>@{[ic('mail')]}<a href="mailto:$C{email}">$C{email}</a></div>
        </div>
      </div>
      <div>
        <h4>@{[t($T{site_links})]}</h4>
        <ul>$links</ul>
      </div>
      <div>
        <h4>@{[t($T{our_services})]}</h4>
        <ul>$svc<li><a href="services.html">@{[t($T{all_services})]}</a></li></ul>
      </div>
    </div>
  </div>
  <div class="f-bottom"><div class="wrap">
    <span>© <span class="yr">2025</span> @{[t($T{all_rights})]} — @{[t($C{full})]}</span>@{[social_html()]}
    <a href="${A}assets/doc/AQUAMARINE_CV.pdf" target="_blank" rel="noopener" style="display:inline-flex;gap:.5em;align-items:center">@{[ic('file')]} @{[t($T{profile})]}</a>
  </div></div>
  <div class="f-credit"><div class="wrap"><span>@{[t($T{dev_by})]}</span>$dev</div></div>
</footer>
HTML
}

sub fabs_html {
  return qq{<div class="fabs">}
    . qq{<a class="fab fab-wa" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener" aria-label="WhatsApp">} . ic('wa') . q{</a>}
    . qq{<a class="fab fab-tel" href="tel:$C{mobile}" aria-label="@{[t($T{call_us})]}">} . ic('phone') . q{</a>}
    . qq{<button class="fab fab-top" aria-label="@{[t($T{to_top})]}">} . ic('arrowu') . q{</button>}
    . q{</div>};
}

# ============================================================
#  BUILDING BLOCKS
# ============================================================
sub phero {
  my ($title,$lead,$img,$crumbs,$tags) = @_;
  my $c = qq{<nav class="crumb"><a href="index.html">@{[t($T{home})]}</a>};
  for my $b (@$crumbs) {
    $c .= q{<i>/</i>};
    $c .= $b->[1] ? qq{<a href="$b->[1]">$b->[0]</a>} : qq{<span class="cur">$b->[0]</span>};
  }
  $c .= '</nav>';
  my $l = $lead ? qq{<p class="lead">$lead</p>} : '';
  my $tg = '';
  if ($tags && @$tags) {
    $tg = '<div class="phero-tags">' . join('', map { "<span>$_</span>" } @$tags) . '</div>';
  }
  return qq{<section class="phero grain"><div class="bgi" style="background-image:url('${A}assets/img/$img')"></div>}
       . qq{<div class="wrap">$c<h1 class="h1">$title</h1>$l$tg</div></section>};
}

sub subnav {
  my ($items) = @_;
  my $o = '<nav class="subnav"><div class="wrap"><ul>';
  $o .= qq{<li><a href="#$_->[0]">$_->[1]</a></li>} for @$items;
  return $o . '</ul></div></nav>';
}

# numbered feature cards — the replacement for flat bullet lists
sub feats {
  my ($items,$start) = @_;
  $start = $start || 0;
  my $o = '<div class="feats">';
  my $n = $start;
  for my $it (@$items) {
    my $d = sprintf('%.2f', (($n - $start) % 3) * 0.08);
    my $num = sprintf('%02d', $n + 1);
    $o .= qq{<div class="feat" data-rv data-delay="$d"><span class="feat-n">$num</span><p>@{[t($it)]}</p></div>};
    $n++;
  }
  return $o . '</div>';
}

sub facts_panel {
  my ($rows) = @_;
  my $o = '<dl class="facts" data-rv>';
  for my $r (@$rows) {
    $o .= qq{<div class="fact"><dt>@{[t($r->[0])]}</dt><dd>@{[t($r->[1])]}</dd></div>};
  }
  return $o . '</dl>';
}

# a row of clickable photos (feeds the same lightbox as the gallery)
sub strip {
  my ($offset,$count) = @_;
  $count ||= 4;
  my $cap = t($C{name});
  my $o = '<div class="strip">';
  for my $i (0..$count-1) {
    my $g = $GALLERY[ ($offset + $i * 3) % scalar(@GALLERY) ];
    my $d = sprintf('%.2f', $i * 0.07);
    $o .= qq{<figure data-full="${A}assets/img/$g" data-cap="$cap" data-rv data-delay="$d" aria-label="@{[t($T{zoom})]}">}
       . qq{<img src="${A}assets/img/$g" alt="$cap" loading="lazy">}
       . qq{<figcaption>} . ic('zoom') . q{</figcaption></figure>};
  }
  return $o . '</div>' . lb_html();
}

sub imgband {
  my ($img,$h,$lead,$href,$label) = @_;
  my $btn = $href ? qq{<a class="btn btn-accent" href="$href" style="margin-top:1.6rem">$label @{[ic(fwd(),'ic')]}</a>} : '';
  return qq{<section class="imgband grain"><div class="bgi" style="background-image:url('${A}assets/img/$img')"></div>}
       . qq{<div class="wrap"><h2 class="h2" data-rv>$h</h2><p class="lead" style="margin-top:.8rem" data-rv>$lead</p>$btn</div></section>};
}

sub scope_list {
  my ($lines) = @_;
  my $o = '<ol class="scope" data-rv>';
  $o .= '<li>' . t($_) . '</li>' for @$lines;
  return $o . '</ol>';
}

sub pager {
  my ($prev,$next) = @_;   # each: [href, title] or undef
  my $o = '<nav class="pager">';
  $o .= $prev
    ? qq{<a class="prev" href="$prev->[0]">@{[ic(back())]}<span><span class="lbl">@{[t($T{prev_item})]}</span><span class="ttl">$prev->[1]</span></span></a>}
    : q{<a class="prev empty" href="#"><span></span></a>};
  $o .= $next
    ? qq{<a class="next" href="$next->[0]"><span><span class="lbl">@{[t($T{next_item})]}</span><span class="ttl">$next->[1]</span></span>@{[ic(fwd())]}</a>}
    : q{<a class="next empty" href="#"><span></span></a>};
  return $o . '</nav>';
}

sub cta_band {
  return <<"HTML";
<section class="cta grain" id="contact">
  <div class="bgi" style="background-image:url('${A}assets/img/a-4.jpg')"></div>
  <div class="wrap">
    <div class="cta-in">
      <div class="t">
        <span class="eyebrow">/ GET IN TOUCH</span>
        <h2 class="h2" style="margin-top:1rem">@{[t($T{cta_h})]}</h2>
        <p class="lead">@{[t($T{cta_lead})]}</p>
      </div>
      <div style="display:grid;gap:16px;justify-items:start">
        <a class="cta-tel tnum" href="tel:$C{mobile}">@{[ic('phone')]} $C{mobile}</a>
        <div style="display:flex;gap:12px;flex-wrap:wrap">
          <a class="btn btn-accent" href="order.html">@{[t($T{order_now})]} @{[ic(fwd(),'ic')]}</a>
          <a class="btn btn-ghost" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener">@{[ic('wa','ic')]} @{[t($T{whatsapp})]}</a>
        </div>
      </div>
    </div>
  </div>
</section>
HTML
}

sub marquee {
  my @items = map { t($_->{t}) } @SERVICES;
  my $run = join '', map { qq{<span>$_</span><i>◆</i>} } (@items, @items);
  return qq{<div class="marq" aria-hidden="true"><div class="marq-in">$run</div></div>};
}

sub fullservices_ul {
  my ($cls) = @_;
  my $li = join '', map { '<li>' . t($_) . '</li>' } @FULLSERVICES;
  $cls = $cls ? qq{ class="$cls"} : '';
  return qq{<ul$cls>$li</ul>};
}

sub svclist_all {
  my ($current) = @_;
  my $o = '<ul class="svc-list">';
  for my $s (@SERVICES) {
    my $on = ($current && $s->{slug} eq $current) ? ' class="on"' : '';
    $o .= qq{<li$on><a href="service-$s->{slug}.html">@{[t($s->{t})]}} . ic(fwd(),'ic') . '</a></li>';
  }
  return $o . '</ul>';
}

sub svc_cards {
  my ($limit) = @_;
  my $o = '<div class="svc-grid">';
  my $n = 0;
  for my $s (@SERVICES) {
    last if $limit && $n >= $limit;
    my $d = sprintf('%.2f', ($n % 3) * 0.09);
    $o .= qq{<article class="svc" data-rv data-delay="$d">}
       . qq{<div class="svc-img"><img src="${A}assets/img/$s->{img}" alt="@{[t($s->{t})]}" loading="lazy"><span class="numeral">@{[numeral($n)]}</span></div>}
       . qq{<div class="svc-body"><h3>@{[t($s->{t})]}</h3><p>@{[t($s->{d})]}</p>}
       . qq{<a class="tlink" href="service-$s->{slug}.html">@{[t($T{service_details})]}} . ic(fwd(),'ic') . q{</a></div></article>};
    $n++;
  }
  return $o . '</div>';
}

sub proj_cards {
  my ($skip,$feature) = @_;
  my $cls = $feature ? 'proj-grid feature' : 'proj-grid';
  my $o = qq{<div class="$cls">};
  my $n = 0;
  for my $p (@PROJECTS) {
    next if $skip && $p->{slug} eq $skip;
    my $d = sprintf('%.2f', ($n % 3) * 0.09);
    $o .= qq{<a class="proj" href="project-$p->{slug}.html" data-rv data-delay="$d">}
       . qq{<img src="${A}assets/img/$p->{img}" alt="@{[t($p->{t})]}" loading="lazy">}
       . qq{<div class="proj-in"><span class="tag">$p->{tag}</span><h3>@{[t($p->{t})]}</h3><p>@{[t($p->{d})]}</p>}
       . qq{<span class="go">@{[t($T{view_project})]} } . ic(fwd(),'ic') . q{</span></div></a>};
    $n++;
  }
  return $o . '</div>';
}

sub process_block {
  my $o = '<div class="proc">';
  my $n = 0;
  for my $p (@PROCESS) {
    my $d = sprintf('%.2f', $n * 0.1);
    $o .= qq{<div class="proc-step" data-rv data-delay="$d"><span class="proc-n">$p->{n}</span>}
       . qq{<h3>@{[t($p->{t})]}</h3><p>@{[t($p->{d})]}</p></div>};
    $n++;
  }
  return $o . '</div>';
}

sub locations_block {
  my $o = '<ul class="locs">';
  my $n = 0;
  for my $l (@LOCATIONS) {
    my $d = sprintf('%.2f', ($n % 7) * 0.05);
    $o .= qq{<li data-rv data-delay="$d">@{[t($l)]}</li>};
    $n++;
  }
  return $o . '</ul>';
}

# ------------------------------------------------------------
#  Gallery albums + media helpers
# ------------------------------------------------------------
our (@ALBUMS, @VIDEOS);

# Pixel size of a JPEG, read from its SOF marker, so gallery images can
# carry width/height and the masonry doesn't jump while photos load.
my %DIMS;
sub jpeg_dims {
  my ($path) = @_;
  return @{ $DIMS{$path} } if $DIMS{$path};
  open(my $fh, '<:raw', $path) or return;
  my $buf;
  read($fh, $buf, 2);
  return unless $buf eq "\xFF\xD8";
  while (read($fh, $buf, 4) == 4) {
    my ($ff, $mk, $len) = unpack('CCn', $buf);
    return unless $ff == 0xFF;
    if ($mk >= 0xC0 && $mk <= 0xCF && $mk != 0xC4 && $mk != 0xC8 && $mk != 0xCC) {
      read($fh, $buf, 5);
      my (undef, $h, $w) = unpack('Cnn', $buf);
      $DIMS{$path} = [$w, $h];
      return ($w, $h);
    }
    seek($fh, $len - 2, 1);
  }
  return;
}

# Display size of the first video track in an MP4 (its tkhd box),
# honouring a 90/270-degree rotation matrix the way browsers do.
sub mp4_dims {
  my ($path) = @_;
  open(my $fh, '<:raw', $path) or return;
  local $/;
  my $d = <$fh>;
  close $fh;
  while ($d =~ /tkhd/g) {
    my $p   = pos $d;
    my $off = ord(substr($d, $p, 1)) == 1 ? 88 : 76;   # v1 boxes carry 64-bit times
    my ($w, $h) = map { $_ >> 16 } unpack('NN', substr($d, $p + $off, 8));
    next unless $w && $h;                              # audio tracks are 0x0
    my ($ma, $mb) = unpack('NN', substr($d, $p + $off - 36, 8));
    ($w, $h) = ($h, $w) if $ma == 0 && $mb != 0;
    return ($w, $h);
  }
  return;
}

# every gallery photo in album order: { file, cat, cap }
sub album_items {
  my @out;
  for my $al (@ALBUMS) {
    my @files = $al->{files}
      ? @{ $al->{files} }
      : map { s{^assets/img/}{}r } sort { $a cmp $b } glob("assets/img/$al->{glob}");
    push @out, { file => $_, cat => $al->{slug}, cap => t($al->{t}) } for @files;
  }
  return @out;
}

# a varied preview: photos taken round-robin across the albums
sub preview_items {
  my ($want) = @_;
  my @all = album_items();
  my @q = map { my $s = $_->{slug}; [ grep { $_->{cat} eq $s } @all ] } @ALBUMS;
  my @out;
  while (@out < $want && grep { @$_ } @q) {
    for my $list (@q) { push @out, shift @$list if @$list && @out < $want; }
  }
  return @out;
}

# The masonry gallery. Takes a list of items, a number (a mixed preview
# of that many photos), or nothing (every photo in every album).
sub gal_html {
  my @items = !@_                   ? album_items()
            : ref($_[0]) eq 'HASH'  ? @_
            :                         preview_items($_[0]);
  my $o = '<div class="gal">';
  my $n = 0;
  for my $it (@items) {
    my $src = "assets/img/$it->{file}";
    my ($w, $h) = jpeg_dims($src);
    my $wh = $w ? qq{ width="$w" height="$h"} : '';
    my $d = sprintf('%.2f', ($n % 4) * 0.07);
    $o .= qq{<figure data-cat="$it->{cat}" data-full="${A}$src" data-cap="$it->{cap}" data-rv data-delay="$d" aria-label="@{[t($T{zoom})]}">}
       . qq{<img src="${A}$src" alt="$it->{cap}"$wh loading="lazy" decoding="async">}
       . qq{<figcaption>} . ic('zoom') . qq{ $it->{cap}</figcaption></figure>};
    $n++;
  }
  return $o . '</div>' . lb_html();
}

# "N things" with Arabic number agreement: 1, 2, 3-10 (plural), 11+ (singular)
sub count_n {
  my ($n, $ar, $en) = @_;   # $ar = [one, two, few, many], $en = [one, many]
  return $n == 1 ? "1 $en->[0]" : "$n $en->[1]" unless ar();
  my $m = $n % 100;
  return $n == 1               ? $ar->[0]
       : $n == 2               ? $ar->[1]
       : ($m >= 3 && $m <= 10) ? "$n $ar->[2]"
       :                         "$n $ar->[3]";
}
sub photos_n { return count_n($_[0], ['صورة واحدة','صورتان','صور','صورة'], ['photo','photos']); }
sub albums_n { return count_n($_[0], ['ألبوم واحد','ألبومان','ألبومات','ألبوماً'], ['album','albums']); }

# album shelf — cover cards that double as the gallery filter
sub album_shelf {
  my @all = album_items();
  my $total = scalar @all;
  my $o = qq{<div class="albums" role="group" aria-label="@{[t($T{albums_h})]}">}
        . qq{<button type="button" class="album album-all on" data-filter="all" aria-pressed="true">}
        . qq{<span class="cv"><b class="tnum">$total</b></span>}
        . qq{<span class="nm">@{[t($T{all_photos})]}</span><span class="ct">@{[photos_n($total)]}</span></button>};
  for my $al (@ALBUMS) {
    my @mine = grep { $_->{cat} eq $al->{slug} } @all;
    next unless @mine;
    my $cover = $al->{cover} || $mine[0]{file};
    my $cnt = scalar @mine;
    $o .= qq{<button type="button" class="album" data-filter="$al->{slug}" aria-pressed="false">}
        . qq{<span class="cv"><img src="${A}assets/img/$cover" alt="" loading="lazy" decoding="async"></span>}
        . qq{<span class="nm">@{[t($al->{t})]}</span><span class="ct">@{[photos_n($cnt)]}</span></button>};
  }
  return $o . '</div>';
}

sub lb_html {
  my ($p,$n) = ar() ? ('chevr','chevl') : ('chevl','chevr');
  return qq{<div class="lb" aria-hidden="true" role="dialog" aria-label="@{[t($T{gallery_h})]}">}
    . qq{<div class="lb-bar"><span class="lb-count tnum">1 / 1</span><span class="lb-cap"></span><button class="lb-btn lb-close" aria-label="@{[t($T{close})]}">} . ic('close') . q{</button></div>}
    . qq{<button class="lb-btn lb-nav lb-prev" aria-label="@{[t($T{prev})]}">} . ic($p) . q{</button>}
    . q{<img src="" alt="">}
    . qq{<button class="lb-btn lb-nav lb-next" aria-label="@{[t($T{next})]}">} . ic($n) . q{</button>}
    . q{</div>};
}

# One video frame: YouTube (click-to-load) or a self-hosted MP4.
# With no argument it renders the first entry in @VIDEOS.
sub video_html {
  my ($v) = @_;
  $v ||= $VIDEOS[0];
  my $title = t($v->{t});
  if ($v->{yt}) {
    return qq{<div class="vid" data-yt="$v->{yt}" data-title="$title" data-rv="s">}
      . qq{<button class="vid-poster" aria-label="@{[t($T{play})]}"><img src="${A}assets/img/$v->{poster}" alt="$title">}
      . qq{<span class="play">} . ic('play') . q{</span></button></div>};
  }
  my ($w, $h) = mp4_dims("assets/video/$v->{src}");
  my $ar = $w ? qq{ style="aspect-ratio:$w/$h"} : '';
  return qq{<div class="vid vid-file"$ar data-rv="s">}
    . qq{<video controls playsinline preload="metadata" poster="${A}assets/img/$v->{poster}" aria-label="$title">}
    . qq{<source src="${A}assets/video/$v->{src}" type="video/mp4"></video></div>};
}

sub captcha {
  return qq{<div class="captcha field"><span class="q">@{[t($T{f_sum})]} <b><span class="sum-a">3</span> + <span class="sum-b">4</span></b> @{[ar() ? '؟' : '?']}</span>}
    . qq{<input class="sum-in" type="text" inputmode="numeric" aria-label="@{[t($T{f_sum_aria})]}" required>}
    . qq{<button type="button" class="reload" aria-label="@{[t($T{f_sum_reload})]}">} . ic('refresh') . q{</button>}
    . qq{<span class="err">@{[t($T{f_sum_err})]}</span></div>};
}
sub form_msg  { return qq{<div class="form-msg">} . ic('check') . '<span>' . t($T{form_ok}) . '</span></div>'; }
sub form_note { return qq{<p class="form-note">} . ic('info') . '<span>' . t($T{form_note}) . '</span></p>'; }

sub stats_block {
  my ($dark) = @_;
  my @s = (
    [33,'+',$T{stat_projects}], [50,'+',$T{stat_pools}],
    [9,'',$T{stat_services}],   [3,'',$T{stat_countries}],
  );
  my $o = '<div class="stats" data-rv>';
  for my $x (@s) {
    my $em = $x->[1] ? "<em>$x->[1]</em>" : '';
    $o .= qq{<div class="stat"><b class="tnum"><span data-count="$x->[0]">0</span>$em</b><span>@{[t($x->[2])]}</span></div>};
  }
  return $o . '</div>';
}

# ============================================================
#  WRITER
# ============================================================
sub page {
  my ($file,$title,$desc,$active,$body) = @_;
  open(my $fh, '>:encoding(UTF-8)', "$OUT/$file") or die "$OUT/$file: $!";
  print $fh head_html($title,$desc,$file), header_html($active,$file), $body, footer_html();
  close $fh;
}

# ============================================================
#  PAGES
# ============================================================
sub build_all {
  my $co = t($C{full});
  my $n = 0;

  # ---------------------------------------------------------- HOME
  {
  our @CLIENTS;
  my $slides = qq{<i style="background-image:url('${A}assets/img/a-1.jpg')"></i>}
             . join '', map { qq{<i data-bg="${A}assets/img/a-$_.jpg"></i>} } (2..4);

  # clients ticker — the list twice, so the loop is seamless
  my $clients = join '', map { '<span>' . t($_) . '</span><i>◆</i>' } (@CLIENTS, @CLIENTS);

  # intro: three capability rows beside a photo mosaic with a rotating seal
  our @INTRO_CAPS;
  my %capico = (
    pool  => '<path d="M2 17c2 0 2-1.4 4-1.4S8 17 10 17s2-1.4 4-1.4 2 1.4 4 1.4 2-1.4 4-1.4"/><path d="M2 21c2 0 2-1.4 4-1.4S8 21 10 21s2-1.4 4-1.4 2 1.4 4 1.4 2-1.4 4-1.4"/><path d="M8 13V5a2 2 0 0 1 4 0"/><path d="M16 13V5a2 2 0 0 0-4 0"/><path d="M8 8h8"/>',
    drop  => '<path d="M12 2.8s6 6.1 6 10.3a6 6 0 0 1-12 0C6 8.9 12 2.8 12 2.8z"/><path d="M9.4 14.2a2.6 2.6 0 0 0 2.6 2.6"/>',
    pipes => '<path d="M3 7h6a2 2 0 0 1 2 2v6a2 2 0 0 0 2 2h8"/><path d="M3 4v6"/><path d="M21 14v6"/><path d="M15 7h6"/><path d="M18 4v6"/>',
  );
  my $caps = '';
  for my $c (@INTRO_CAPS) {
    $caps .= qq{<li><i class="cap-ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">$capico{$c->{ico}}</svg></i>}
           . qq{<div><b>@{[t($c->{t})]}</b><span>@{[t($c->{d})]}</span></div></li>};
  }
  my @mos = ('albatros/citadel-03.jpg', 'albatros/makadi-06.jpg', 'albatros/portofino-06.jpg');
  my $seal = q{<div class="seal" aria-hidden="true">}
    . q{<svg class="seal-ring" viewBox="0 0 120 120"><defs><path id="seal-path" d="M60 60m-46 0a46 46 0 1 1 92 0a46 46 0 1 1-92 0"/></defs>}
    . q{<text><textPath href="#seal-path" textLength="289" lengthAdjust="spacing">AQUA MARINE · WATER SYSTEMS · EST. 2004 · </textPath></text></svg>}
    . q{<svg class="seal-mark" viewBox="0 0 60 60"><clipPath id="seal-clip"><circle cx="30" cy="30" r="30"/></clipPath><g clip-path="url(#seal-clip)">}
    . q{<rect width="60" height="60" fill="#6aaade"/><path d="M0 0H60V46C50 41 40 51 30 46S10 41 0 46Z" fill="#2589cd"/>}
    . q{<path d="M0 0H60V31C50 26 40 36 30 31S10 26 0 31Z" fill="#1d5fae"/><path d="M0 0H60V16C50 11 40 21 30 16S10 11 0 16Z" fill="#25306b"/></g></svg></div>};

  # services index: a list that drives a sticky preview (images load on first hover)
  my ($sx_list, $sx_media) = ('', '');
  for my $i (0..$#SERVICES) {
    my $s  = $SERVICES[$i];
    my $on = $i == 0 ? ' class="on"' : '';
    my $nn = sprintf('%02d', $i + 1);
    $sx_list .= qq{<li$on><a href="service-$s->{slug}.html" data-i="$i"><span class="n">$nn</span>}
              . qq{<span class="t">@{[t($s->{t})]}</span><span class="go">@{[ic(fwd())]}</span></a></li>};
    my $src = $i == 0
      ? qq{src="${A}assets/img/$s->{img}"}
      : qq{src="data:image/gif;base64,R0lGODlhAQABAAAAACw=" data-src="${A}assets/img/$s->{img}"};
    $sx_media .= qq{<figure data-i="$i"$on><img $src alt="@{[t($s->{t})]}">}
               . qq{<figcaption><span class="num">@{[numeral($i)]}</span><h3>@{[t($s->{t})]}</h3><p>@{[t($s->{d})]}</p>}
               . qq{<a class="cta-pill" href="service-$s->{slug}.html">@{[t($T{service_details})]}} . ic(fwd(),'ic') . q{</a></figcaption></figure>};
  }

  # projects: bento mosaic
  my $bento = '<div class="bento">';
  my $k = 0;
  for my $p (@PROJECTS) {
    my $d = sprintf('%.2f', ($k % 3) * 0.08);
    $bento .= qq{<a class="proj" href="project-$p->{slug}.html" data-rv data-delay="$d">}
            . qq{<img src="${A}assets/img/$p->{img}" alt="@{[t($p->{t})]}" loading="lazy">}
            . qq{<div class="proj-in"><span class="tag">$p->{tag}</span><h3>@{[t($p->{t})]}</h3><p>@{[t($p->{d})]}</p>}
            . qq{<span class="go">@{[t($T{view_project})]} } . ic(fwd(),'ic') . q{</span></div></a>};
    $k++;
  }
  $bento .= '</div>';

  # numbers band, with the logo's wave bands underneath
  my $waves = q{<svg class="waves" viewBox="0 0 1440 200" preserveAspectRatio="none" aria-hidden="true">}
            . q{<path d="M0 70C240 30 480 110 720 70S1200 30 1440 60V200H0Z" fill="#1d5fae" opacity=".45"/>}
            . q{<path d="M0 115C240 75 480 155 720 115S1200 75 1440 105V200H0Z" fill="#2589cd" opacity=".45"/>}
            . q{<path d="M0 160C240 120 480 200 720 160S1200 120 1440 150V200H0Z" fill="#6aaade" opacity=".5"/></svg>};
  my $nlocs = scalar @LOCATIONS;
  my $nums = qq{<div class="nums-grid">}
    . qq{<div class="num-cell" data-rv><b class="tnum">2004</b><span>@{[t($T{num_est})]}</span></div>}
    . qq{<div class="num-cell" data-rv data-delay="0.08"><b class="tnum"><span data-count="33">0</span><em>+</em></b><span>@{[t($T{stat_projects})]}</span></div>}
    . qq{<div class="num-cell" data-rv data-delay="0.16"><b class="tnum"><span data-count="50">0</span><em>+</em></b><span>@{[t($T{stat_pools})]}</span></div>}
    . qq{<div class="num-cell" data-rv data-delay="0.24"><b class="tnum"><span data-count="$nlocs">0</span></b><span>@{[t($T{num_locs})]}</span></div>}
    . q{</div>};

  # process as a timeline
  my $tl = '<ol class="tl" data-rv>';
  $tl .= qq{<li><span class="tl-dot">$_->{n}</span><h3>@{[t($_->{t})]}</h3><p>@{[t($_->{d})]}</p></li>} for @PROCESS;
  $tl .= '</ol>';

  # the Albatros albums, each opening its own filtered gallery view
  my @all = album_items();
  my $alb = '<div class="alb">';
  my $ai = 0;
  for my $al (grep { $_->{glob} } @ALBUMS) {
    my @mine = grep { $_->{cat} eq $al->{slug} } @all;
    next unless @mine;
    my $cover = $al->{cover} || $mine[0]{file};
    my $d = sprintf('%.2f', $ai * 0.07);
    $alb .= qq{<a href="gallery.html#$al->{slug}" data-rv data-delay="$d"><img src="${A}assets/img/$cover" alt="@{[t($al->{t})]}" loading="lazy">}
          . qq{<span class="alb-t"><b>@{[t($al->{t})]}</b><span>@{[photos_n(scalar @mine)]}</span></span></a>};
    $ai++;
  }
  $alb .= '</div>';

  # where we work — an outlined ticker
  my $locs = join '', map { '<span>' . t($_) . '</span><i>◆</i>' } (@LOCATIONS, @LOCATIONS);

  my $body = <<"HTML";
<section class="hero grain">
  <div class="hero-bg" aria-hidden="true">$slides</div>
  <div class="hero-scrim" aria-hidden="true"></div>
  <div class="wrap">
    <div class="hero-in">
      <span class="eyebrow">/ AQUA MARINE WATER SYSTEMS</span>
      <h1 class="display">@{[t($T{hero_a})]}<br><b>@{[t($T{hero_b})]}</b></h1>
      <p class="lead">@{[t($T{hero_lead})]}</p>
      <div class="hero-btns">
        <a class="btn btn-accent btn-lg" href="services.html">@{[t($T{browse_services})]} @{[ic(fwd(),'ic')]}</a>
        <a class="btn btn-ghost btn-lg" href="works.html">@{[t($T{track_record})]}</a>
      </div>
    </div>
  </div>
  <span class="scroll-cue">@{[t($T{scroll})]}</span>
  <div class="hero-bar"><div class="wrap"><ul>
    <li><b class="tnum">33</b><span>@{[t($T{stat_projects})]}</span></li>
    <li><b class="tnum">09</b><span>@{[t($T{stat_services})]}</span></li>
    <li><b class="tnum">03</b><span>@{[t($T{stat_countries2})]}</span></li>
    <li><b class="tnum">24/7</b><span>@{[t($T{stat_support})]}</span></li>
  </ul></div></div>
</section>

<div class="marq clients"><div class="marq-in">$clients</div></div>

<section class="section intro">
  <div class="wrap">
    <div class="intro-grid">
      <div class="intro-text" data-rv>
        <span class="eyebrow">/ ABOUT · EST. 2004</span>
        <h2 class="h2">@{[t($T{intro_h})]}</h2>
        <p class="lead">@{[t($T{about_lead})]}</p>
        <ul class="intro-caps">$caps</ul>
        <div class="intro-btns">
          <a class="cta-pill" href="about.html">@{[t($T{learn_more})]} @{[ic(fwd(),'ic')]}</a>
          <a class="btn btn-ghost" href="${A}assets/doc/AQUAMARINE_CV.pdf" target="_blank" rel="noopener">@{[ic('dl','ic')]} @{[t($T{profile})]}</a>
        </div>
      </div>
      <div class="intro-media" data-rv="s">
        <figure class="im im-a"><img src="${A}assets/img/$mos[0]" alt="" loading="lazy"></figure>
        <figure class="im im-b"><img src="${A}assets/img/$mos[1]" alt="" loading="lazy"></figure>
        <figure class="im im-c"><img src="${A}assets/img/$mos[2]" alt="" loading="lazy"></figure>
        $seal
      </div>
    </div>
  </div>
</section>

<section class="section band">
  <div class="wrap">
    <div class="sec-head">
      <div class="t" data-rv>
        <span class="eyebrow">/ OUR SERVICES</span>
        <h2 class="h2" style="margin-top:1rem">@{[t($T{sx_h})]}</h2>
        <p class="lead" style="margin-top:.7rem">@{[t($T{sx_l})]}</p>
      </div>
      <a class="btn btn-ghost" href="services.html" data-rv>@{[t($T{all_services})]} @{[ic(fwd(),'ic')]}</a>
    </div>
    <div class="sx">
      <ol class="sx-list" data-rv>$sx_list</ol>
      <div class="sx-media" data-rv="s">$sx_media</div>
    </div>
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="sec-head">
      <div class="t" data-rv>
        <span class="eyebrow">/ SELECTED PROJECTS</span>
        <h2 class="h2" style="margin-top:1rem">@{[t($T{projects_h})]}</h2>
        <p class="lead" style="margin-top:.7rem">@{[t($T{projects_lead})]}</p>
      </div>
      <a class="btn btn-ghost" href="projects.html" data-rv>@{[t($T{all_projects})]} @{[ic(fwd(),'ic')]}</a>
    </div>
    $bento
  </div>
</section>

<section class="nums">
  $waves
  <div class="wrap">
    <span class="eyebrow" data-rv>/ TRACK RECORD</span>
    <h2 class="h2" style="margin-top:1rem" data-rv>@{[t($T{nums_h})]}</h2>
    $nums
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ HOW WE WORK</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{process_h})]}</h2>
      <p class="lead" style="margin-top:.7rem">@{[t($T{process_lead})]}</p>
    </div></div>
    $tl
  </div>
</section>

<section class="section band">
  <div class="wrap">
    <div class="sec-head">
      <div class="t" data-rv>
        <span class="eyebrow">/ GALLERY</span>
        <h2 class="h2" style="margin-top:1rem">@{[t($T{alb_h})]}</h2>
        <p class="lead" style="margin-top:.7rem">@{[t($T{alb_l})]}</p>
      </div>
      <a class="btn btn-ghost" href="gallery.html" data-rv>@{[t($T{all_photos})]} @{[ic(fwd(),'ic')]}</a>
    </div>
    $alb
  </div>
</section>

<section class="section" style="padding-bottom:0">
  <div class="wrap">
    <div class="sec-head" style="margin-bottom:clamp(20px,2.4vw,30px)"><div class="t" data-rv>
      <span class="eyebrow">/ WHERE WE WORK</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{locations_h})]}</h2>
    </div></div>
  </div>
  <div class="omarq"><div class="omarq-in">$locs</div></div>
</section>

<section class="section">
  <div class="wrap">
    <div class="wt">
      @{[video_html()]}
      <div class="wt-card" data-rv data-delay="0.1">
        <span class="eyebrow">/ WATCH · TALK</span>
        <h2 class="h2">@{[t($T{wt_h})]}</h2>
        <p class="lead">@{[t($T{wt_l})]}</p>
        <a class="wt-tel" href="tel:$C{mobile}">@{[ic('phone')]} $C{mobile}</a>
        <div class="wt-btns">
          <a class="cta-pill" href="order.html">@{[t($T{order_now})]} @{[ic(fwd(),'ic')]}</a>
          <a class="btn btn-ghost" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener">@{[ic('wa','ic')]} @{[t($T{whatsapp})]}</a>
        </div>
      </div>
    </div>
  </div>
</section>
HTML
  page('index.html', "$co — " . t($T{meta_home_t}), t($T{meta_home}), 'index.html', $body); $n++;
  }

  # ---------------------------------------------------------- ABOUT
  {
  my $body = phero(t($T{who_we_are}), t($T{about_lead2}), 'about.jpg', [[t($T{who_we_are})]],
                   ['UPVC','PPR','HDPE', ar() ? 'تصميم · تنفيذ · صيانة' : 'Design · Build · Maintain'])
  . <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="split">
      <div data-rv>
        <span class="eyebrow">/ WHO WE ARE</span>
        <h2 class="h2" style="margin:1.1rem 0 1rem">@{[t($T{about_h})]}</h2>
        <p class="lead">@{[t($T{about_lead2})]}</p>
        <ul class="ticks">
          <li>@{[ic('check')]}<span>@{[t($T{about_lead})]}</span></li>
          <li>@{[ic('check')]}<span>@{[t($T{about_t1})]}</span></li>
          <li>@{[ic('check')]}<span>@{[t($T{about_t2})]}</span></li>
          <li>@{[ic('check')]}<span>@{[t($T{about_t4})]}</span></li>
        </ul>
      </div>
      <div class="split-media" data-rv="s">
        <div class="m1"><img src="${A}assets/img/aquamarine26(1).jpg" alt="@{[t($C{name})]}" loading="lazy"></div>
        <div class="m2"><img src="${A}assets/img/aquamarine1(1).jpeg" alt="@{[t($C{name})]}" loading="lazy"></div>
      </div>
    </div>
    <div style="margin-top:clamp(44px,5.5vw,72px)">@{[stats_block()]}</div>
  </div>
</section>

<section class="section band">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ HOW WE WORK</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{process_h})]}</h2>
      <p class="lead" style="margin-top:.7rem">@{[t($T{process_lead})]}</p>
    </div></div>
    @{[process_block()]}
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ WHAT WE DO</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{what_we_do})]}</h2>
      <p class="lead" style="margin-top:.7rem">@{[t($T{services_intro})]}</p>
    </div></div>
    @{[feats(\@FULLSERVICES)]}
    <div style="margin-top:clamp(32px,4vw,52px);display:flex;gap:13px;flex-wrap:wrap" data-rv>
      <a class="btn" href="services.html">@{[t($T{service_detail_cta})]} @{[ic(fwd(),'ic')]}</a>
      <a class="btn btn-ghost" href="works.html">@{[t($T{track_record})]}</a>
    </div>
  </div>
</section>

@{[imgband('aquamarine25(1).jpg', t($T{band_h}), t($T{band_lead}), 'works.html', t($T{track_record}))]}

<section class="section">
  <div class="wrap-n">
    <a class="dl" href="${A}assets/doc/AQUAMARINE_CV.pdf" target="_blank" rel="noopener" data-rv>
      <span class="ico">@{[ic('file')]}</span>
      <span style="flex:1"><b>@{[t($T{profile_full})]}</b><span>@{[t($T{profile_sub})]}</span></span>
      @{[ic('dl')]}
    </a>
  </div>
</section>

@{[cta_band()]}
HTML
  page('about.html', t($T{who_we_are}) . " — $co", t($T{meta_about}), 'about.html', $body); $n++;
  }

  # ---------------------------------------------------------- SERVICES
  {
  my $body = phero(t($NAV[2][1]), t($T{services_lead}), 'aquamarine16(1).jpg', [[t($NAV[2][1])]],
                   [ar() ? '9 خدمات' : '9 services', ar() ? 'تصميم وتنفيذ وصيانة' : 'Design, build, maintain'])
  . <<"HTML";
<section class="section">
  <div class="wrap">@{[svc_cards()]}</div>
</section>

@{[imgband('aquamarine22(1).jpg', t($T{band_h}), t($T{band_lead}), 'order.html', t($T{order_now}))]}

<section class="section band">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ FULL CAPABILITY</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{services_list_h})]}</h2>
      <p class="lead" style="margin-top:.7rem">@{[t($T{services_intro})]}</p>
    </div></div>
    @{[feats(\@FULLSERVICES)]}
  </div>
</section>

@{[cta_band()]}
HTML
  page('services.html', t($NAV[2][1]) . " — $co", t($T{meta_services}), 'services.html', $body); $n++;
  }

  # ---------------------------------------------------------- SERVICE DETAIL
  for my $i (0..$#SERVICES) {
    my $s = $SERVICES[$i];
    my ($slug,$title,$blurb,$img) = ($s->{slug}, t($s->{t}), t($s->{d}), $s->{img});
    my $prev = $i > 0          ? ["service-$SERVICES[$i-1]{slug}.html", t($SERVICES[$i-1]{t})] : undef;
    my $next = $i < $#SERVICES ? ["service-$SERVICES[$i+1]{slug}.html", t($SERVICES[$i+1]{t})] : undef;
    my $extra = ($slug eq 'steam-rooms')
      ? qq{<img src="${A}assets/img/20080119(002).jpg" alt="$title" loading="lazy" style="border-radius:var(--rad-lg);width:100%;margin:1.8rem 0">}
      : '';

    my $body = phero($title, $blurb, $img, [[t($NAV[2][1]),'services.html'],[$title]],
                     [map { t($_) } @{ $SVC_FEATURES{$slug} }])
    . subnav([['overview',t($T{jump_overview})],['included',t($T{jump_included})],
              ['work',t($T{jump_work})],['projects',t($T{jump_projects})],['contact',t($T{jump_contact})]])
    . <<"HTML";
<section class="section" id="overview">
  <div class="wrap">
    <div class="grid sidebar-grid">
      <div class="prose" data-rv>
        <span class="eyebrow">/ OVERVIEW</span>
        <h2 style="margin:1rem 0 1rem">@{[t($T{overview})]}</h2>
        <p class="lead">$blurb</p>
        <p>@{[t($T{services_intro})]}</p>
        $extra
        <div class="note">@{[ic('info')]} @{[t($T{quote_note})]} <a href="order.html">@{[t($T{quote_note2})]}</a> @{[t($T{quote_note3})]} <a class="tnum" href="tel:$C{mobile}">$C{mobile}</a>.</div>
      </div>
      <aside data-rv>
        <h3 class="h3" style="margin-bottom:1.1rem">@{[t($T{all_services})]}</h3>
        @{[svclist_all($slug)]}
        <a class="btn btn-accent" href="order.html" style="width:100%;justify-content:center;margin-top:1.2rem">@{[t($T{order_service})]} @{[ic(fwd(),'ic')]}</a>
        <a class="dl" href="${A}assets/doc/AQUAMARINE_CV.pdf" target="_blank" rel="noopener" style="margin-top:12px">
          <span class="ico">@{[ic('file')]}</span>
          <span style="flex:1"><b>@{[t($T{profile})]}</b><span>PDF</span></span>@{[ic('dl')]}
        </a>
      </aside>
    </div>
  </div>
</section>

<section class="section band" id="included">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ INCLUDED</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{whats_included})]}</h2>
    </div></div>
    @{[feats($SVC_FEATURES{$slug})]}
  </div>
</section>

<section class="section" id="work">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ ON SITE</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{from_our_work})]}</h2>
      <p class="lead" style="margin-top:.7rem">@{[t($T{from_our_work_l})]}</p>
    </div><a class="btn btn-ghost" href="gallery.html" data-rv>@{[t($T{all_photos})]} @{[ic(fwd(),'ic')]}</a></div>
    @{[strip($i * 2)]}
  </div>
</section>

<section class="section band" id="projects">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ PROJECTS</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{from_projects})]}</h2>
    </div><a class="btn btn-ghost" href="projects.html" data-rv>@{[t($T{all_projects})]} @{[ic(fwd(),'ic')]}</a></div>
    @{[proj_cards()]}
  </div>
</section>

@{[pager($prev,$next)]}
@{[cta_band()]}
HTML
    page("service-$slug.html", "$title — $co", $blurb, 'services.html', $body); $n++;
  }

  # ---------------------------------------------------------- PROJECTS
  {
  my $body = phero(t($NAV[3][1]), t($T{projects_lead}), 'aquamarine25(1).jpg', [[t($NAV[3][1])]],
                   [ar() ? 'فنادق ومنتجعات' : 'Hotels & resorts', ar() ? 'مدارس وأندية' : 'Schools & clubs', ar() ? 'صناعي' : 'Industrial'])
  . <<"HTML";
<section class="section">
  <div class="wrap">@{[proj_cards(undef,1)]}</div>
</section>

@{[imgband('aquamarine23(1).jpg', t($T{full_record}), t($T{full_record_p}), 'works.html', t($T{browse_list}))]}

<section class="section band">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ TRACK RECORD</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{numbers_h})]}</h2>
    </div></div>
    @{[stats_block()]}
  </div>
</section>

@{[cta_band()]}
HTML
  page('projects.html', t($NAV[3][1]) . " — $co", t($T{meta_projects}), 'projects.html', $body); $n++;
  }

  # ---------------------------------------------------------- PROJECT DETAIL
  for my $i (0..$#PROJECTS) {
    my $p = $PROJECTS[$i];
    my ($slug,$title,$blurb,$img,$tag) = ($p->{slug}, t($p->{t}), t($p->{d}), $p->{img}, $p->{tag});
    my $prev = $i > 0          ? ["project-$PROJECTS[$i-1]{slug}.html", t($PROJECTS[$i-1]{t})] : undef;
    my $next = $i < $#PROJECTS ? ["project-$PROJECTS[$i+1]{slug}.html", t($PROJECTS[$i+1]{t})] : undef;

    my $f = $PROJ_FACTS{$slug};
    my $facts = facts_panel([
      [$T{fact_type},  [$tag,$tag]],
      [$T{fact_loc},   $f->{loc}],
      [$T{fact_client},$f->{client}],
      [$T{fact_scope}, $f->{scope}],
    ]);

    # real scope lines where the ledger describes this project
    my @scope;
    if (my $refs = $PROJ_WORKS{$slug}) {
      push @scope, @{ $WORKS[$_]{d} } for @$refs;
    }
    @scope = @GENERIC_SCOPE unless @scope;

    my $body = phero($title, $blurb, $img, [[t($NAV[3][1]),'projects.html'],[$title]],
                     [$tag, t($f->{loc})])
    . subnav([['overview',t($T{jump_overview})],['scope',t($T{jump_scope})],
              ['work',t($T{jump_work})],['contact',t($T{jump_contact})]])
    . <<"HTML";
<section class="section" id="overview">
  <div class="wrap">
    $facts
    <div class="grid sidebar-grid" style="margin-top:clamp(36px,4.4vw,58px)">
      <div class="prose" data-rv>
        <span class="eyebrow">/ OVERVIEW</span>
        <h2 style="margin:1rem 0 1rem">@{[t($T{overview})]}</h2>
        <p class="lead">$blurb</p>
        <img src="${A}assets/img/$img" alt="$title" loading="lazy" style="border-radius:var(--rad-lg);width:100%;margin:1.8rem 0;box-shadow:var(--shadow-l)">
      </div>
      <aside data-rv>
        <h3 class="h3" style="margin-bottom:1.1rem">@{[t($T{our_services})]}</h3>
        @{[svclist_all()]}
        <a class="btn btn-accent" href="order.html" style="width:100%;justify-content:center;margin-top:1.2rem">@{[t($T{order_now})]} @{[ic(fwd(),'ic')]}</a>
      </aside>
    </div>
  </div>
</section>

<section class="section band" id="scope">
  <div class="wrap-n">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ SCOPE</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{scope_h})]}</h2>
    </div></div>
    @{[scope_list(\@scope)]}
  </div>
</section>

<section class="section" id="work">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ ON SITE</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{from_our_work})]}</h2>
    </div><a class="btn btn-ghost" href="gallery.html" data-rv>@{[t($T{all_photos})]} @{[ic(fwd(),'ic')]}</a></div>
    @{[strip($i * 4 + 1)]}
  </div>
</section>

<section class="section band">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ MORE</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{other_projects})]}</h2>
    </div></div>
    @{[proj_cards($slug)]}
  </div>
</section>

@{[pager($prev,$next)]}
@{[cta_band()]}
HTML
    page("project-$slug.html", "$title — $co", $blurb, 'projects.html', $body); $n++;
  }

  # ---------------------------------------------------------- WORKS
  {
  my (%count, $rows, $i);
  $i = 0;
  for my $w (@WORKS) {
    $i++;
    $count{$w->{c}}++;
    my $num = sprintf('%02d', $i);
    my @det = @{ $w->{d} };
    my $sub = @det == 1 ? '<small>' . t($det[0]) . '</small>'
            : @det > 1  ? '<ul>' . join('', map { '<li>' . t($_) . '</li>' } @det) . '</ul>'
            : '';
    $rows .= qq{<div class="lrow" data-cat="$w->{c}"><span class="n tnum">$num</span>}
           . qq{<div class="t">@{[t($w->{t})]}$sub</div>}
           . qq{<span class="k">@{[t($CATNAME{$w->{c}})]}</span></div>};
  }
  my $total = scalar @WORKS;
  my $chips = qq{<button class="chip on" data-filter="all">@{[t($T{filter_all})]}<span class="c">$total</span></button>};
  $chips .= qq{<button class="chip" data-filter="$_">@{[t($CATNAME{$_})]}<span class="c">$count{$_}</span></button>} for qw(pools san intl);

  my $body = phero(t($NAV[4][1]), t($T{works_intro}), 'aquamarine22(1).jpg', [[t($NAV[4][1])]],
                   ["$total " . (ar() ? 'عملاً' : 'works'), ar() ? 'مصر · قطر · السودان' : 'Egypt · Qatar · Sudan'])
  . <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="sec-head" style="margin-bottom:clamp(22px,2.6vw,32px)"><div class="t" data-rv>
      <span class="eyebrow">/ TRACK RECORD</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{works_h})]}</h2>
      <p class="lead" style="margin-top:.7rem">@{[t($T{works_lead})]}</p>
    </div></div>
    <div class="chips" data-rv>$chips</div>
    <div class="ledger" data-rv>$rows</div>
  </div>
</section>

@{[imgband('aquamarine10(1).jpg', t($T{band_h}), t($T{band_lead}), 'projects.html', t($T{all_projects}))]}
@{[cta_band()]}
HTML
  page('works.html', t($NAV[4][1]) . " — $co", t($T{meta_works}), 'works.html', $body); $n++;
  }

  # ---------------------------------------------------------- GALLERY
  {
  my @all = album_items();
  my $albums = grep { my $s = $_->{slug}; grep { $_->{cat} eq $s } @all } @ALBUMS;
  my $body = phero(t($T{gallery_h}), t($T{albums_lead}), 'albatros/makadi-01.jpg', [[t($T{gallery_h})]],
                   [photos_n(scalar @all), albums_n($albums)])
  . qq{<section class="section"><div class="wrap">}
  . qq{<div class="sec-head" style="margin-bottom:clamp(22px,2.6vw,32px)"><div class="t" data-rv>}
  . qq{<span class="eyebrow">/ ALBUMS</span><h2 class="h2" style="margin-top:1rem">@{[t($T{albums_h})]}</h2>}
  . qq{<p class="lead" style="margin-top:.7rem">@{[t($T{gallery_note})]}</p></div></div>}
  . album_shelf() . gal_html() . q{</div></section>}
  . cta_band();
  page('gallery.html', t($T{gallery_h}) . " — $co", t($T{meta_gallery}), 'gallery.html', $body); $n++;
  }

  # ---------------------------------------------------------- VIDEOS
  {
  my $cards = '';
  for my $v (@VIDEOS) {
    # portrait phone clips get a narrow column instead of towering over the film
    my ($w, $h) = $v->{src} ? mp4_dims("assets/video/$v->{src}") : ();
    my $cls = ($w && $h && $h > $w) ? 'vcard portrait' : 'vcard';
    my $link = $v->{link}
      ? qq{<a class="btn btn-ghost" href="$v->{link}" target="_blank" rel="noopener">@{[ic('yt','ic')]} @{[t($T{watch_yt})]}</a>}
      : '';
    $cards .= qq{<figure class="$cls">} . video_html($v)
            . qq{<figcaption data-rv><div><h3>@{[t($v->{t})]}</h3><p>@{[t($v->{d})]}</p></div>$link</figcaption></figure>};
  }
  my $body = phero(t($T{video_page_h}), t($T{video_page_lead}), 'a-3.jpg', [[t($T{video_page_h})]])
  . <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="vids">$cards</div>
  </div>
</section>

<section class="section band">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ MORE</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{video_related})]}</h2>
    </div></div>
    @{[svc_cards(3)]}
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ ON SITE</span>
      <h2 class="h2" style="margin-top:1rem">@{[t($T{from_our_work})]}</h2>
    </div><a class="btn btn-ghost" href="gallery.html" data-rv>@{[t($T{all_photos})]} @{[ic(fwd(),'ic')]}</a></div>
    @{[strip(6)]}
  </div>
</section>

@{[cta_band()]}
HTML
  page('videos.html', t($T{video_page_h}) . " — $co", t($T{meta_videos}), 'videos.html', $body); $n++;
  }

  # ---------------------------------------------------------- CONTACT
  {
  my $body = phero(t($T{contact_h}), t($T{contact_lead}), 'aquamarine23(1).jpg', [[t($T{contact_h})]],
                   [$C{mobile}, ar() ? 'على مدار اليوم' : 'Around the clock'])
  . <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="ccards">
      <div class="ccard" data-rv><span class="ico">@{[ic('pin')]}</span><h3>@{[t($T{address_label})]}</h3><p>@{[t($C{addr})]}</p></div>
      <div class="ccard" data-rv data-delay="0.09"><span class="ico">@{[ic('phone')]}</span><h3>@{[t($T{phone_label})]}</h3>
        <a class="tnum" href="tel:$C{mobile}">$C{mobile}</a>
        <a class="tnum" href="tel:$C{mobile2}">$C{mobile2}</a>
        <a class="tnum" href="tel:$C{land}">$C{land}</a>
        <a class="tnum" href="tel:$C{intl}">+$C{intl}</a>
      </div>
      <div class="ccard" data-rv data-delay="0.18"><span class="ico">@{[ic('mail')]}</span><h3>@{[t($T{email_label})]}</h3>
        <a href="mailto:$C{email}">$C{email}</a>
        <p style="margin-top:.5em">@{[t($T{support_24})]}</p>
      </div>
    </div>
  </div>
</section>

<section class="section band">
  <div class="wrap">
    <div class="grid form-grid">
      <div class="formcard" data-rv>
        <span class="eyebrow">/ SEND A MESSAGE</span>
        <h2 class="h2" style="margin:1rem 0 1.6rem">@{[t($T{send_message})]}</h2>
        <form data-validate data-track="contact_form" data-wa="$C{wa}" data-subject="@{[t($T{wa_subject_c})]}" novalidate>
          @{[form_msg()]}
          <div class="fgrid">
            <div class="field"><label for="c-name">@{[t($T{f_name})]} <i>*</i></label><input id="c-name" name="name" type="text" placeholder="@{[t($T{f_name_ph})]}" required><span class="err">@{[t($T{f_name_err})]}</span></div>
            <div class="field"><label for="c-phone">@{[t($T{f_phone})]} <i>*</i></label><input id="c-phone" name="phone" type="tel" inputmode="tel" placeholder="01xxxxxxxxx" required><span class="err">@{[t($T{f_phone_err})]}</span></div>
            <div class="field full"><label for="c-email">@{[t($T{f_email})]} <i>*</i></label><input id="c-email" name="email" type="email" placeholder="name\@example.com" required><span class="err">@{[t($T{f_email_err})]}</span></div>
            <div class="field full"><label for="c-msg">@{[t($T{f_message})]} <i>*</i></label><textarea id="c-msg" name="message" placeholder="@{[t($T{f_message_ph})]}" required></textarea><span class="err">@{[t($T{f_message_err})]}</span></div>
            @{[captcha()]}
          </div>
          <button class="btn btn-accent btn-lg" type="submit" style="margin-top:1.5rem">@{[ic('send','ic')]} @{[t($T{send_btn})]}</button>
          @{[form_note()]}
        </form>
      </div>
      <div data-rv data-delay="0.1">
        <h3 class="h3" style="margin-bottom:1.1rem">@{[t($T{map_h})]}</h3>
        <iframe class="map" src="$C{map}" loading="lazy" referrerpolicy="no-referrer-when-downgrade" title="@{[t($T{map_title})]}" allowfullscreen></iframe>
        <div style="display:grid;gap:12px;margin-top:18px">
          <a class="btn btn-accent" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener" style="justify-content:center">@{[ic('wa','ic')]} @{[t($T{wa_cta})]}</a>
          <a class="btn btn-ghost" href="tel:$C{mobile}" style="justify-content:center">@{[ic('phone','ic')]} <span class="tnum">$C{mobile}</span></a>
        </div>
      </div>
    </div>
  </div>
</section>
HTML
  page('contact.html', t($T{contact_h}) . " — $co", t($T{meta_contact}), 'contact.html', $body); $n++;
  }

  # ---------------------------------------------------------- ORDER
  {
  my $opts = join '', map { my $v = t($_->{t}); qq{<option value="$v">$v</option>} } @SERVICES;
  my $body = phero(t($T{order_now}), t($T{order_lead}), 'aquamarine26(1).jpg', [[t($T{order_now})]],
                   [ar() ? 'رد خلال 24 ساعة' : 'Reply within 24 hours', ar() ? 'عرض سعر مجاني' : 'Free quotation'])
  . <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="grid form-grid">
      <div class="formcard" data-rv>
        <span class="eyebrow">/ REQUEST A QUOTE</span>
        <h2 class="h2" style="margin:1rem 0 1.6rem">@{[t($T{order_h})]}</h2>
        <form data-validate data-track="order_form" data-wa="$C{wa}" data-subject="@{[t($T{wa_subject_o})]}" novalidate>
          @{[form_msg()]}
          <div class="fgrid">
            <div class="field"><label for="o-name">@{[t($T{f_name})]} <i>*</i></label><input id="o-name" name="name" type="text" placeholder="@{[t($T{f_name_ph})]}" required><span class="err">@{[t($T{f_name_err})]}</span></div>
            <div class="field"><label for="o-phone">@{[t($T{f_phone})]} <i>*</i></label><input id="o-phone" name="phone" type="tel" inputmode="tel" placeholder="01xxxxxxxxx" required><span class="err">@{[t($T{f_phone_err})]}</span></div>
            <div class="field"><label for="o-email">@{[t($T{f_email})]} <i>*</i></label><input id="o-email" name="email" type="email" placeholder="name\@example.com" required><span class="err">@{[t($T{f_email_err})]}</span></div>
            <div class="field"><label for="o-city">@{[t($T{f_city})]}</label><input id="o-city" name="city" type="text" placeholder="@{[t($T{f_city_ph})]}"></div>
            <div class="field full"><label for="o-service">@{[t($T{f_service})]} <i>*</i></label>
              <select id="o-service" name="service" required><option value="">@{[t($T{f_service_ph})]}</option>$opts</select>
              <span class="err">@{[t($T{f_service_err})]}</span></div>
            <div class="field full"><label for="o-msg">@{[t($T{f_details})]} <i>*</i></label><textarea id="o-msg" name="message" placeholder="@{[t($T{f_details_ph})]}" required></textarea><span class="err">@{[t($T{f_details_err})]}</span></div>
            @{[captcha()]}
          </div>
          <button class="btn btn-accent btn-lg" type="submit" style="margin-top:1.5rem">@{[ic('send','ic')]} @{[t($T{order_btn})]}</button>
          @{[form_note()]}
        </form>
      </div>
      <aside data-rv data-delay="0.1">
        <h3 class="h3" style="margin-bottom:1.1rem">@{[t($T{prefer_call})]}</h3>
        <div style="display:grid;gap:12px">
          <a class="btn btn-accent" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener" style="justify-content:center">@{[ic('wa','ic')]} @{[t($T{whatsapp})]}</a>
          <a class="btn btn-ghost" href="tel:$C{mobile}" style="justify-content:center">@{[ic('phone','ic')]} <span class="tnum">$C{mobile}</span></a>
          <a class="btn btn-ghost" href="mailto:$C{email}" style="justify-content:center">@{[ic('mail','ic')]} @{[t($T{email_label})]}</a>
        </div>
        <h3 class="h3" style="margin:2.2rem 0 1.1rem">@{[t($T{our_services})]}</h3>
        @{[svclist_all()]}
      </aside>
    </div>
  </div>
</section>

@{[imgband('aquamarine29(1).jpg', t($T{band_h}), t($T{band_lead}), 'works.html', t($T{track_record}))]}
@{[cta_band()]}
HTML
  page('order.html', t($T{order_now}) . " — $co", t($T{meta_order}), 'order.html', $body); $n++;
  }

  return $n;
}

# ============================================================
#  RUN BOTH LANGUAGES
# ============================================================
print "Building Aqua Marine site...\n";
mkdir 'ar' unless -d 'ar';

# English is the default language, at the root; Arabic lives under /ar/
($L,$A,$OUT,$DIR,$LANG) = (1, '',    '.',    'ltr', 'en');
my $en = build_all();
print "  English (LTR) -> ./      $en pages\n";

($L,$A,$OUT,$DIR,$LANG) = (0, '../', './ar', 'rtl', 'ar');
my $ar = build_all();
print "  Arabic  (RTL) -> ./ar/   $ar pages\n";

print "Done. ", $ar + $en, " pages total.\n";
