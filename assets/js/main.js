/* ============================================================
   AQUA MARINE WATER SYSTEMS — site behaviour
   Vanilla JS, no dependencies.
   ============================================================ */
(function () {
  'use strict';

  var $  = function (s, c) { return (c || document).querySelector(s); };
  var $$ = function (s, c) { return Array.prototype.slice.call((c || document).querySelectorAll(s)); };
  var reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  // a Microsoft Clarity custom event; does nothing when Clarity isn't installed
  var track = function (name) { if (typeof window.clarity === 'function') window.clarity('event', name); };
  // mark the contact moments: calls, WhatsApp, email and the company profile
  document.addEventListener('click', function (e) {
    var a = e.target.closest ? e.target.closest('a[href]') : null;
    if (!a) return;
    var h = a.getAttribute('href');
    if (/^tel:/i.test(h)) track('call_click');
    else if (/whatsapp\.com|wa\.me/i.test(h)) track('whatsapp_click');
    else if (/^mailto:/i.test(h)) track('email_click');
    else if (/\.pdf(?:$|[?#])/i.test(h)) track('profile_download');
  });

  /* ---------- header: stuck state + scroll progress ---------- */
  var hdr = $('.hdr');
  var bar = $('.progress i');
  var toTop = $('.fab-top');

  function onScroll() {
    var y = window.pageYOffset || document.documentElement.scrollTop;
    if (hdr) hdr.classList.toggle('stuck', y > 12);
    if (bar) {
      var h = document.documentElement.scrollHeight - window.innerHeight;
      bar.style.width = (h > 0 ? (y / h) * 100 : 0) + '%';
    }
    if (toTop) toTop.classList.toggle('on', y > 520);
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  if (toTop) {
    toTop.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: reduced ? 'auto' : 'smooth' });
    });
  }

  /* ---------- nav: sliding ink + services mega panel ---------- */
  var nav = $('.nav');
  var ink = nav && $('.ink', nav);
  var cap = $('.cap');
  if (nav && ink) {
    var activeA = $('.nav > li.active > a');
    var placeInk = function (a, instant) {
      if (!a) { ink.classList.remove('on'); return; }
      var r = a.getBoundingClientRect(), n = nav.getBoundingClientRect();
      if (instant) ink.style.transition = 'none';
      ink.style.left = (r.left - n.left) + 'px';
      ink.style.width = r.width + 'px';
      ink.classList.add('on');
      if (instant) { void ink.offsetWidth; ink.style.transition = ''; }
    };
    var rest = function () {
      placeInk(cap && cap.classList.contains('mega-open') ? $('.nav > li.has-mega > a') : activeA);
    };
    $$('.nav > li:not(.ink) > a').forEach(function (a) {
      a.addEventListener('mouseenter', function () { placeInk(a); });
      a.addEventListener('focus', function () { placeInk(a); });
    });
    nav.addEventListener('mouseleave', rest);
    placeInk(activeA, true);
    window.addEventListener('resize', function () { placeInk(activeA, true); });
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(function () { placeInk(activeA, true); });

    var megaLi = $('.nav > li.has-mega');
    var mega = $('.mega');
    if (cap && megaLi && mega) {
      var megaA = $('a', megaLi), timer = null;
      var setMega = function (open) {
        clearTimeout(timer);
        cap.classList.toggle('mega-open', open);
        megaLi.classList.toggle('open', open);
        megaA.setAttribute('aria-expanded', open ? 'true' : 'false');
        if (!open) rest();
      };
      // hover intent: small delays so crossing the gap doesn't flicker it shut
      var later = function (open) { clearTimeout(timer); timer = setTimeout(function () { setMega(open); }, open ? 60 : 180); };
      megaLi.addEventListener('mouseenter', function () { later(true); });
      megaLi.addEventListener('mouseleave', function () { later(false); });
      mega.addEventListener('mouseenter', function () { clearTimeout(timer); });
      mega.addEventListener('mouseleave', function () { later(false); });
      megaLi.addEventListener('focusin', function () { setMega(true); });
      cap.addEventListener('focusout', function (e) { if (!cap.contains(e.relatedTarget)) setMega(false); });
      // touch screens: the first tap opens the panel, a second tap follows the link
      megaA.addEventListener('click', function (e) {
        if (window.matchMedia('(hover: none)').matches && !cap.classList.contains('mega-open')) { e.preventDefault(); setMega(true); }
      });
      document.addEventListener('click', function (e) { if (!cap.contains(e.target)) setMega(false); });
      document.addEventListener('keydown', function (e) { if (e.key === 'Escape') setMega(false); });
    }
  }

  /* ---------- mobile menu: a panel that drops out of the capsule ---------- */
  var burger = $('.burger');
  var mm = $('#mmenu');
  var mmScrim = $('.mm-scrim');
  var mmTg = mm && $('.mm-tg', mm);
  var mmSub = mm && $('.mm-sub', mm);
  var mmTimer = null;
  var menuOpen = function () { return !!mm && mm.classList.contains('on'); };

  function setSub(open) {
    if (!mmTg || !mmSub) return;
    mmSub.classList.toggle('on', open);
    mmTg.setAttribute('aria-expanded', open ? 'true' : 'false');
  }

  function setMenu(open) {
    if (!mm || !burger) return;
    clearTimeout(mmTimer);
    if (open) {
      mm.hidden = false;
      mm.scrollTop = 0;
      void mm.offsetWidth;   // commit the closed pose first, so the panel animates in
      // the rows arrive one after another, then the card and the social row
      $$('.mm-nav > ul > li, .mm-card, .mm-foot', mm).forEach(function (el, i) {
        el.style.animationDelay = (0.06 + i * 0.035) + 's';
      });
      track('menu_open');
    } else {
      mmTimer = setTimeout(function () { mm.hidden = true; setSub(false); }, 450);
    }
    mm.classList.toggle('on', open);
    if (mmScrim) mmScrim.classList.toggle('on', open);
    burger.classList.toggle('on', open);
    burger.setAttribute('aria-expanded', open ? 'true' : 'false');
    document.documentElement.classList.toggle('menu-open', open);
  }

  if (burger && mm) {
    burger.addEventListener('click', function () {
      setMenu(!menuOpen());
      if (menuOpen()) { var first = $('a', mm); if (first) first.focus({ preventScroll: true }); }
    });
    if (mmScrim) mmScrim.addEventListener('click', function () { setMenu(false); });
    $$('a[href]', mm).forEach(function (a) { a.addEventListener('click', function () { setMenu(false); }); });
    if (mmTg) mmTg.addEventListener('click', function () { setSub(!mmSub.classList.contains('on')); });
    document.addEventListener('keydown', function (e) {
      if (!menuOpen()) return;
      if (e.key === 'Escape') { setMenu(false); burger.focus(); return; }
      if (e.key !== 'Tab') return;
      // Tab cycles through the burger and the panel while the menu is open
      var f = [burger].concat($$('a[href], button', mm).filter(function (el) {
        return el.offsetParent !== null && getComputedStyle(el).visibility !== 'hidden';
      }));
      var i = f.indexOf(document.activeElement);
      if (i === -1) return;
      if (e.shiftKey && i === 0) { e.preventDefault(); f[f.length - 1].focus(); }
      else if (!e.shiftKey && i === f.length - 1) { e.preventDefault(); f[0].focus(); }
    });
    // widening past the burger breakpoint brings the desktop nav back: close the panel
    var wide = window.matchMedia('(min-width: 1181px)');
    var onWide = function () { if (wide.matches && menuOpen()) setMenu(false); };
    if (wide.addEventListener) wide.addEventListener('change', onWide);
    else if (wide.addListener) wide.addListener(onWide);
  }

  /* ---------- reveal on scroll ---------- */
  var rv = $$('[data-rv]');
  if (rv.length) {
    if (!('IntersectionObserver' in window) || reduced || !document.documentElement.classList.contains('rv')) {
      rv.forEach(function (el) { el.classList.add('in'); });
    } else {
      window.rvReady = true;   // tells the <head> failsafe the page is in hand
      // threshold 0, not a percentage: a block taller than the viewport (the
      // works ledger on a phone) can never show 12% of itself at once.
      var io = new IntersectionObserver(function (entries) {
        entries.forEach(function (e) {
          if (!e.isIntersecting) return;
          var d = parseFloat(e.target.getAttribute('data-delay') || 0);
          setTimeout(function () { e.target.classList.add('in'); }, d * 1000);
          io.unobserve(e.target);
        });
      }, { threshold: 0, rootMargin: '0px 0px -8% 0px' });
      rv.forEach(function (el) {
        // a block taller than most of the screen gains nothing from fading in
        if (el.getBoundingClientRect().height > window.innerHeight * 0.9) el.classList.add('in');
        else io.observe(el);
      });
    }
  }

  /* ---------- animated counters ---------- */
  var counters = $$('[data-count]');
  if (counters.length) {
    var runCount = function (el) {
      var target = parseFloat(el.getAttribute('data-count'));
      if (reduced) { el.textContent = String(target); return; }
      var dur = 1500, t0 = null;
      function step(t) {
        if (!t0) t0 = t;
        var p = Math.min((t - t0) / dur, 1);
        var eased = 1 - Math.pow(1 - p, 3);
        el.textContent = String(Math.round(target * eased));
        if (p < 1) requestAnimationFrame(step);
      }
      requestAnimationFrame(step);
    };
    if (!('IntersectionObserver' in window)) {
      counters.forEach(runCount);
    } else {
      var cio = new IntersectionObserver(function (entries) {
        entries.forEach(function (e) {
          if (!e.isIntersecting) return;
          runCount(e.target);
          cio.unobserve(e.target);
        });
      }, { threshold: 0.5 });
      counters.forEach(function (el) { cio.observe(el); });
    }
  }

  /* ---------- gallery lightbox ---------- */
  var lb = $('.lb');
  if (lb) {
    // The markup sits inside a section's .wrap, whose z-index makes a
    // stacking context: left there, the sticky header paints over the
    // lightbox's top bar and hides its close button. Lift it to <body>.
    if (lb.parentNode !== document.body) document.body.appendChild(lb);

    // the masonry gallery and the inline photo strips share one lightbox
    var figs = $$('.gal figure, .strip figure');
    var list = figs;           // what the arrows walk through: the visible photos
    var lbImg = $('.lb img', lb);
    var lbCount = $('.lb-count', lb);
    var lbCap = $('.lb-cap', lb);
    var idx = 0;
    var seq = 0;               // guards against a slow earlier load landing last

    function show(i) {
      if (!list.length) return;
      idx = (i + list.length) % list.length;
      var f = list[idx];
      var src = f.getAttribute('data-full') || $('img', f).getAttribute('src');
      var cap = f.getAttribute('data-cap') || '';
      var mine = ++seq;
      lbImg.style.opacity = 0;
      var pre = new Image();
      pre.onload = function () {
        if (mine !== seq) return;
        lbImg.src = src;
        lbImg.alt = cap;
        lbImg.style.opacity = 1;
      };
      pre.src = src;
      if (lbCount) lbCount.textContent = (idx + 1) + ' / ' + list.length;
      if (lbCap) lbCap.textContent = cap;
    }
    function open(fig) {
      // browse only what the current album filter is showing
      list = figs.filter(function (f) { return !f.hidden; });
      show(Math.max(0, list.indexOf(fig)));
      lb.classList.add('on');
      lb.setAttribute('aria-hidden', 'false');
      document.body.style.overflow = 'hidden';
    }
    function close() {
      lb.classList.remove('on');
      lb.setAttribute('aria-hidden', 'true');
      document.body.style.overflow = '';
    }

    figs.forEach(function (f) {
      f.setAttribute('tabindex', '0');
      f.setAttribute('role', 'button');
      f.addEventListener('click', function () { open(f); });
      f.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); open(f); }
      });
    });

    var cBtn = $('.lb-close', lb);
    if (cBtn) cBtn.addEventListener('click', close);
    var pBtn = $('.lb-prev', lb);
    if (pBtn) pBtn.addEventListener('click', function () { show(idx - 1); });
    var nBtn = $('.lb-next', lb);
    if (nBtn) nBtn.addEventListener('click', function () { show(idx + 1); });
    lb.addEventListener('click', function (e) { if (e.target === lb) close(); });
    // In RTL, ArrowLeft advances; in LTR it goes back.
    var rtl = document.documentElement.getAttribute('dir') === 'rtl';
    document.addEventListener('keydown', function (e) {
      if (!lb.classList.contains('on')) return;
      if (e.key === 'Escape') close();
      if (e.key === 'ArrowLeft') show(rtl ? idx + 1 : idx - 1);
      if (e.key === 'ArrowRight') show(rtl ? idx - 1 : idx + 1);
    });

    // touch swipe
    var x0 = null;
    lb.addEventListener('touchstart', function (e) { x0 = e.touches[0].clientX; }, { passive: true });
    lb.addEventListener('touchend', function (e) {
      if (x0 === null) return;
      var dx = e.changedTouches[0].clientX - x0;
      if (Math.abs(dx) > 48) {
        var fwd = rtl ? dx > 0 : dx < 0;   // swipe against the reading direction advances
        show(fwd ? idx + 1 : idx - 1);
      }
      x0 = null;
    }, { passive: true });
  }

  /* ---------- deferred background images (hero slides 2-4) ---------- */
  var lazyBg = $$('[data-bg]');
  if (lazyBg.length) {
    var loadBg = function () {
      lazyBg.forEach(function (el) {
        el.style.backgroundImage = "url('" + el.getAttribute('data-bg') + "')";
        el.removeAttribute('data-bg');
      });
    };
    if (document.readyState === 'complete') loadBg();
    else window.addEventListener('load', loadBg);
  }

  /* ---------- video: click poster to load the embed ---------- */
  $$('.vid-poster').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var box = btn.closest('.vid');
      var id = box.getAttribute('data-yt');
      if (!id) return;
      var f = document.createElement('iframe');
      f.src = 'https://www.youtube.com/embed/' + id + '?autoplay=1&rel=0';
      f.title = box.getAttribute('data-title') || 'Video';
      f.allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture';
      f.allowFullscreen = true;
      box.appendChild(f);
      btn.remove();
    });
  });

  /* ---------- filters: works ledger chips + gallery album cards ---------- */
  var filters = $$('.chip[data-filter], .album[data-filter]');
  if (filters.length) {
    filters.forEach(function (btn) {
      btn.addEventListener('click', function () {
        var f = btn.getAttribute('data-filter');
        filters.forEach(function (b) {
          var on = b === btn;
          b.classList.toggle('on', on);
          b.setAttribute('aria-pressed', on ? 'true' : 'false');
        });
        $$('[data-cat]').forEach(function (el) {
          el.hidden = !(f === 'all' || el.getAttribute('data-cat') === f);
        });
        // ledger rows carry a running number; renumber the visible ones
        var n = 0;
        $$('.lrow').forEach(function (row) {
          if (row.hidden) return;
          var cell = row.querySelector('.n');
          if (cell) cell.textContent = String(++n).padStart(2, '0');
        });
      });
    });
  }

  /* ---------- home: services index (the list drives a sticky preview) ---------- */
  var sx = $('.sx');
  if (sx) {
    var sxRows = $$('.sx-list li', sx);
    var sxFigs = $$('.sx-media figure', sx);
    var setSx = function (i) {
      sxRows.forEach(function (li, k) { li.classList.toggle('on', k === i); });
      sxFigs.forEach(function (f, k) {
        var on = k === i;
        f.classList.toggle('on', on);
        var img = $('img', f);
        // previews other than the first only download when first shown
        if (on && img && img.getAttribute('data-src')) {
          img.src = img.getAttribute('data-src');
          img.removeAttribute('data-src');
        }
      });
    };
    sxRows.forEach(function (li, i) {
      var a = $('a', li);
      a.addEventListener('mouseenter', function () { setSx(i); });
      a.addEventListener('focus', function () { setSx(i); });
    });
  }

  /* ---------- gallery: open an album straight from a link (gallery.html#makadi) ---------- */
  if (location.hash && $('.albums')) {
    var wantAlbum = decodeURIComponent(location.hash.slice(1)).replace(/"/g, '');
    var albumCard = $('.album[data-filter="' + wantAlbum + '"]');
    if (albumCard) {
      albumCard.click();
      $('.albums').scrollIntoView({ block: 'start', behavior: reduced ? 'auto' : 'smooth' });
    }
  }

  /* ---------- forms: math check + validation ---------- */
  $$('form[data-validate]').forEach(function (form) {
    var a, b;

    function newSum() {
      a = 2 + Math.floor(Math.random() * 8);
      b = 1 + Math.floor(Math.random() * 8);
      var qa = $('.sum-a', form), qb = $('.sum-b', form), inp = $('.sum-in', form);
      if (qa) qa.textContent = String(a);
      if (qb) qb.textContent = String(b);
      if (inp) inp.value = '';
    }
    newSum();
    var reload = $('.reload', form);
    if (reload) reload.addEventListener('click', function (e) { e.preventDefault(); newSum(); });

    function markBad(field, bad) {
      var w = field.closest('.field') || field.closest('.captcha');
      if (w) w.classList.toggle('bad', bad);
    }

    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var ok = true;
      var first = null;

      $$('[required]', form).forEach(function (f) {
        var bad = !f.value.trim() || (f.type === 'email' && !/^[^@\s]+@[^@\s]+\.[^@\s]{2,}$/.test(f.value.trim()));
        if (f.classList.contains('sum-in')) bad = parseInt(f.value, 10) !== a + b;
        markBad(f, bad);
        if (bad) { ok = false; if (!first) first = f; }
      });

      if (!ok) { if (first) first.focus(); return; }
      track(form.getAttribute('data-track') || 'form_sent');

      // No backend on this static build — hand the enquiry to WhatsApp,
      // which is how the company already takes orders.
      var get = function (n) { var el = form.querySelector('[name="' + n + '"]'); return el ? el.value.trim() : ''; };
      var lines = [
        form.getAttribute('data-subject') || 'رسالة من الموقع',
        get('name') ? 'الاسم: ' + get('name') : '',
        get('phone') ? 'الموبايل: ' + get('phone') : '',
        get('email') ? 'الإيميل: ' + get('email') : '',
        get('service') ? 'الخدمة: ' + get('service') : '',
        get('city') ? 'المحافظة: ' + get('city') : '',
        get('message') ? '\n' + get('message') : ''
      ].filter(Boolean);

      var wa = form.getAttribute('data-wa');
      if (wa) window.open('https://api.whatsapp.com/send?phone=' + wa + '&text=' + encodeURIComponent(lines.join('\n')), '_blank', 'noopener');

      var msg = $('.form-msg', form);
      if (msg) {
        msg.classList.add('ok');
        msg.scrollIntoView({ block: 'center', behavior: reduced ? 'auto' : 'smooth' });
      }
      form.reset();
      newSum();
    });

    $$('input,select,textarea', form).forEach(function (f) {
      f.addEventListener('input', function () { markBad(f, false); });
    });
  });


  /* ---------- current year ---------- */
  $$('.yr').forEach(function (el) { el.textContent = new Date().getFullYear(); });
})();
