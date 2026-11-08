<?php
// ============================================================
//  The bits of the site the office changes without a rebuild:
//  the headline numbers, and the photograph on each service card.
// ============================================================
require __DIR__ . '/lib.php';
if (!tables_ready()) redirect('install.php');
$me = require_login();

const SVC_DIR = __DIR__ . '/../assets/img/services';

// The numbers, in the order they read on the site. The fallback is what
// the build ships, so a cleared field goes back to it rather than blank.
const NUMBERS = [
  'n_pools'     => ['حمامات السباحة والنوافير', '50'],
  'n_projects'  => ['المشروعات في سابقة الأعمال', '33'],
  'n_countries' => ['دول العمل', '3'],
  'n_services'  => ['الخدمات الهندسية', '9'],
  'n_support'   => ['الدعم — نص كما هو', '24/7'],
];

try {
  db()->query('SELECT 1 FROM settings LIMIT 1');
  db()->query('SELECT 1 FROM service_images LIMIT 1');
} catch (PDOException $e) {
  $title = 'إعدادات الموقع';
  require __DIR__ . '/head.php';
  echo '<h1>إعدادات الموقع</h1><p class="note bad">الجداول الجديدة لسه مش موجودة.</p>'
     . ($me['role'] === 'admin'
        ? '<p><a class="btn" href="migrate.php">اعمل الجداول</a></p>'
        : '<p class="hint">كلّم المدير يعمل الجداول.</p>');
  require __DIR__ . '/foot.php';
  exit;
}

$services = [];
$seed = __DIR__ . '/seed-services.json';
if (is_file($seed)) {
  $j = json_decode((string) file_get_contents($seed), true);
  if (is_array($j)) $services = $j;
}

function save_svc_upload(array $f, string $slug): ?string {
  $err = $f['error'] ?? UPLOAD_ERR_NO_FILE;
  if ($err === UPLOAD_ERR_NO_FILE) return null;
  if ($err !== UPLOAD_ERR_OK)      throw new RuntimeException('فشل رفع الصورة.');
  if (($f['size'] ?? 0) > 8 * 1024 * 1024) throw new RuntimeException('الصورة أكبر من 8 ميجا.');

  $info = @getimagesize($f['tmp_name']);
  if (!$info) throw new RuntimeException('الملف ده مش صورة.');
  $types = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
  $ext = $types[$info['mime']] ?? null;
  if (!$ext) throw new RuntimeException('النوع ده مش مدعوم — استخدم jpg أو png أو webp.');

  if (!is_dir(SVC_DIR) && !@mkdir(SVC_DIR, 0755, true)) {
    throw new RuntimeException('مش قادر أعمل مجلد الصور.');
  }
  $name = $slug . '-' . bin2hex(random_bytes(4)) . '.' . $ext;
  if (!move_uploaded_file($f['tmp_name'], SVC_DIR . '/' . $name)) {
    throw new RuntimeException('مش قادر أحفظ الصورة.');
  }
  return 'services/' . $name;
}

$err = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();

  // --- the numbers ---------------------------------------------
  if (isset($_POST['numbers'])) {
    $up = db()->prepare('INSERT INTO settings (k, v, updated_at) VALUES (?, ?, NOW())
                         ON DUPLICATE KEY UPDATE v = VALUES(v), updated_at = NOW()');
    $del = db()->prepare('DELETE FROM settings WHERE k = ?');
    foreach (NUMBERS as $k => $meta) {
      $v = trim((string) ($_POST[$k] ?? ''));
      if ($v === '') { $del->execute([$k]); continue; }
      $up->execute([$k, mb_substr($v, 0, 190)]);
    }
    flash('الأرقام اتحفظت.');
    redirect('site.php');
  }

  // --- one service photograph ----------------------------------
  if (isset($_POST['svc'])) {
    $slug = (string) $_POST['svc'];
    $known = false;
    foreach ($services as $s) { if (($s['slug'] ?? '') === $slug) { $known = true; break; } }
    if (!$known) { http_response_code(400); exit('الخدمة دي مش موجودة.'); }

    if (isset($_POST['revert'])) {
      $s = db()->prepare('SELECT file FROM service_images WHERE slug = ?');
      $s->execute([$slug]);
      if ($row = $s->fetch()) {
        $p = SVC_DIR . '/' . basename($row['file']);
        if (is_file($p)) @unlink($p);
      }
      db()->prepare('DELETE FROM service_images WHERE slug = ?')->execute([$slug]);
      flash('رجعت الصورة الأصلية.');
      redirect('site.php');
    }

    try {
      $file = save_svc_upload($_FILES['img'] ?? [], $slug);
      if ($file === null) {
        $err = 'اختار صورة الأول.';
      } else {
        // the one it replaces goes with it, so uploads do not pile up
        $s = db()->prepare('SELECT file FROM service_images WHERE slug = ?');
        $s->execute([$slug]);
        if ($row = $s->fetch()) {
          $p = SVC_DIR . '/' . basename($row['file']);
          if (is_file($p)) @unlink($p);
        }
        db()->prepare('INSERT INTO service_images (slug, file, updated_at) VALUES (?, ?, NOW())
                       ON DUPLICATE KEY UPDATE file = VALUES(file), updated_at = NOW()')
            ->execute([$slug, $file]);
        flash('الصورة اتغيّرت.');
        redirect('site.php');
      }
    } catch (RuntimeException $e) {
      $err = $e->getMessage();
    }
  }
}

$set = [];
foreach (db()->query('SELECT k, v FROM settings')->fetchAll() as $r) $set[$r['k']] = $r['v'];

$imgs = [];
foreach (db()->query('SELECT slug, file FROM service_images')->fetchAll() as $r) $imgs[$r['slug']] = $r['file'];

$title = 'إعدادات الموقع';
require __DIR__ . '/head.php';
?>
<h1>إعدادات الموقع</h1>
<p class="sub">الأرقام اللي في الصفحة الرئيسية، وصورة كل خدمة.</p>

<?php if ($err): ?><p class="note bad"><?= h($err) ?></p><?php endif; ?>

<h2>الأرقام</h2>
<div class="box">
  <p class="hint">بتظهر تحت الهيرو وفي بلوك الإحصائيات. سيب الخانة فاضية ترجع للرقم الأصلي.</p>
  <form method="post">
    <?= csrf_field() ?>
    <input type="hidden" name="numbers" value="1">
    <div class="cards" style="margin-bottom:18px">
      <?php foreach (NUMBERS as $k => $meta): ?>
        <label style="margin:0"><?= h($meta[0]) ?>
          <input type="text" name="<?= h($k) ?>" dir="ltr"
                 value="<?= h($set[$k] ?? '') ?>" placeholder="<?= h($meta[1]) ?>">
        </label>
      <?php endforeach; ?>
    </div>
    <button class="btn" type="submit">حفظ الأرقام</button>
  </form>
</div>

<h2>صور الخدمات</h2>
<?php if (!$services): ?>
  <p class="note bad">ملف الخدمات مش موجود على السيرفر.</p>
<?php endif; ?>

<div class="cards">
  <?php foreach ($services as $s):
    $slug = (string) ($s['slug'] ?? '');
    $own  = $imgs[$slug] ?? '';
    $show = $own !== '' ? $own : (string) ($s['img'] ?? ''); ?>
    <div class="card" style="padding:12px">
      <img src="../assets/img/<?= h($show) ?>" alt=""
           style="width:100%;height:120px;object-fit:cover;border-radius:8px;display:block;margin-bottom:10px">
      <b style="font-size:14.5px;font-weight:600;display:block;margin-bottom:2px"><?= h($s['t'] ?? $slug) ?></b>
      <span class="hint" style="display:block;margin-bottom:10px">
        <?= $own !== '' ? 'صورة مرفوعة' : 'الصورة الأصلية' ?>
      </span>

      <form method="post" enctype="multipart/form-data">
        <?= csrf_field() ?>
        <input type="hidden" name="svc" value="<?= h($slug) ?>">
        <input type="file" name="img" accept="image/jpeg,image/png,image/webp" required
               style="margin-bottom:8px;font-size:13px">
        <button class="btn sm" type="submit">غيّر الصورة</button>
      </form>

      <?php if ($own !== ''): ?>
        <form method="post" style="margin-top:8px"
              onsubmit="return confirm('ترجع الصورة الأصلية؟')">
          <?= csrf_field() ?>
          <input type="hidden" name="svc" value="<?= h($slug) ?>">
          <input type="hidden" name="revert" value="1">
          <button class="btn ghost sm" type="submit">رجّع الأصلية</button>
        </form>
      <?php endif; ?>
    </div>
  <?php endforeach; ?>
</div>
<?php require __DIR__ . '/foot.php';
