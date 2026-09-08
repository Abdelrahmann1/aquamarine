/* ============================================================
   AQUA MARINE WATER SYSTEMS — site behaviour
   Vanilla JS, no dependencies.
   ============================================================ */
(function () {
  'use strict';

  var $  = function (s, c) { return (c || document).querySelector(s); };
  var $$ = function (s, c) { return Array.prototype.slice.call((c || document).querySelectorAll(s)); };
  var reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

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

  /* ---------- mobile drawer ---------- */
  var burger = $('.burger');
  var drawer = $('.drawer');

  function setDrawer(open) {
    if (!drawer) return;
    drawer.classList.toggle('on', open);
    if (burger) {
      burger.classList.toggle('on', open);
      burger.setAttribute('aria-expanded', open ? 'true' : 'false');
    }
    document.body.style.overflow = open ? 'hidden' : '';
    if (open) {
      // stagger the top-level links
      $$('.drawer > ul > li > a, .drawer > ul > li > .drow', drawer).forEach(function (a, i) {
        a.style.animationDelay = (0.12 + i * 0.055) + 's';
      });
    }
  }
  if (burger) burger.addEventListener('click', function () { setDrawer(!drawer.classList.contains('on')); });
  var dclose = $('.dclose');
  if (dclose) dclose.addEventListener('click', function () { setDrawer(false); });
  $$('.drawer a[href]').forEach(function (a) {
    a.addEventListener('click', function () { setDrawer(false); });
  });
  // drawer submenus
  $$('.dtoggle').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var sub = btn.closest('li').querySelector('.sub-m');
      btn.classList.toggle('on');
      if (sub) sub.classList.toggle('on');
    });
  });

  /* ---------- reveal on scroll ---------- */
  var rv = $$('[data-rv]');
  if (rv.length) {
    if (!('IntersectionObserver' in window) || reduced) {
      rv.forEach(function (el) { el.classList.add('in'); });
    } else {
      var io = new IntersectionObserver(function (entries) {
        entries.forEach(function (e) {
          if (!e.isIntersecting) return;
          var d = parseFloat(e.target.getAttribute('data-delay') || 0);
          setTimeout(function () { e.target.classList.add('in'); }, d * 1000);
          io.unobserve(e.target);
        });
      }, { threshold: 0.12, rootMargin: '0px 0px -60px' });
      rv.forEach(function (el) { io.observe(el); });
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
    // the masonry gallery and the inline photo strips share one lightbox
    var figs = $$('.gal figure, .strip figure');
    var lbImg = $('.lb img', lb);
    var lbCount = $('.lb-count', lb);
    var lbCap = $('.lb-cap', lb);
    var idx = 0;

    function show(i) {
      if (!figs.length) return;
      idx = (i + figs.length) % figs.length;
      var src = figs[idx].getAttribute('data-full') || $('img', figs[idx]).getAttribute('src');
      var cap = figs[idx].getAttribute('data-cap') || '';
      lbImg.style.opacity = 0;
      var pre = new Image();
      pre.onload = function () {
        lbImg.src = src;
        lbImg.alt = cap;
        lbImg.style.opacity = 1;
      };
      pre.src = src;
      if (lbCount) lbCount.textContent = (idx + 1) + ' / ' + figs.length;
      if (lbCap) lbCap.textContent = cap;
    }
    function open(i) {
      show(i);
      lb.classList.add('on');
      lb.setAttribute('aria-hidden', 'false');
      document.body.style.overflow = 'hidden';
    }
    function close() {
      lb.classList.remove('on');
      lb.setAttribute('aria-hidden', 'true');
      document.body.style.overflow = '';
    }

    figs.forEach(function (f, i) {
      f.setAttribute('tabindex', '0');
      f.setAttribute('role', 'button');
      f.addEventListener('click', function () { open(i); });
      f.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); open(i); }
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

  /* ---------- works ledger filter ---------- */
  var chips = $$('.chip[data-filter]');
  if (chips.length) {
    chips.forEach(function (chip) {
      chip.addEventListener('click', function () {
        var f = chip.getAttribute('data-filter');
        chips.forEach(function (c) { c.classList.toggle('on', c === chip); });
        $$('.lrow').forEach(function (row) {
          var cat = row.getAttribute('data-cat') || '';
          row.hidden = !(f === 'all' || cat === f);
        });
        // renumber the visible rows
        var n = 0;
        $$('.lrow').forEach(function (row) {
          if (row.hidden) return;
          n++;
          var cell = row.querySelector('.n');
          if (cell) cell.textContent = String(n).padStart(2, '0');
        });
      });
    });
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

  /* ---------- newsletter (no backend) ---------- */
  $$('.nl-form').forEach(function (f) {
    f.addEventListener('submit', function (e) {
      e.preventDefault();
      var i = $('input', f);
      if (!i || !/^[^@\s]+@[^@\s]+\.[^@\s]{2,}$/.test(i.value.trim())) { i.focus(); return; }
      var btn = $('button', f);
      if (btn) { btn.textContent = 'تم الاشتراك ✓'; btn.disabled = true; }
      i.value = '';
    });
  });

  /* ---------- current year ---------- */
  $$('.yr').forEach(function (el) { el.textContent = new Date().getFullYear(); });
})();
