<?php
// ============================================================
//  Add or change one project, in both languages, with its
//  cover and its gallery.
// ============================================================
require __DIR__ . '/lib.php';
if (!tables_ready()) redirect('install.php');
$me = require_login();

const IMG_DIR = __DIR__ . '/../assets/img/projects';
const SECTORS = [
  'residential'  => 'سكني',
  'commercial'   => 'تجاري',
  'hospitality'  => 'فنادق ومنتجعات',
  'industrial'   => 'صناعي',
];

// An uploaded file is never trusted: the type comes from reading the
// image itself, and the name is one we make, so nothing executable can
// ever land in a web folder under a name the browser would run.
function save_upload(array $f, string $slug): ?string {
  $err = $f['error'] ?? UPLOAD_ERR_NO_FILE;
  if ($err === UPLOAD_ERR_NO_FILE) return null;
  if ($err !== UPLOAD_ERR_OK)      throw new RuntimeException('فشل رفع الصورة.');
  if (($f['size'] ?? 0) > 8 * 1024 * 1024) throw new RuntimeException('الصورة أكبر من 8 ميجا.');

  $info = @getimagesize($f['tmp_name']);
  if (!$info) throw new RuntimeException('الملف ده مش صورة.');

  $types = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
  $ext = $types[$info['mime']] ?? null;
  if (!$ext) throw new RuntimeException('النوع ده مش مدعوم — استخدم jpg أو png أو webp.');

  if (!is_dir(IMG_DIR) && !@mkdir(IMG_DIR, 0755, true)) {
    throw new RuntimeException('مش قادر أعمل مجلد الصور.');
  }
  $name = ($slug !== '' ? $slug : 'project') . '-' . bin2hex(random_bytes(4)) . '.' . $ext;
  if (!move_uploaded_file($f['tmp_name'], IMG_DIR . '/' . $name)) {
    throw new RuntimeException('مش قادر أحفظ الصورة. راجع صلاحيات المجلد.');
  }
  return 'projects/' . $name;
}

function slugify(string $s): string {
  $s = strtolower(trim($s));
  $s = preg_replace('/[^a-z0-9]+/', '-', $s);
  return trim((string) $s, '-');
}

$id = (int) ($_GET['id'] ?? 0);
$p = [
  'id' => 0, 'slug' => '', 'sec' => 'residential', 'tag' => '',
  'title_ar' => '', 'title_en' => '', 'place_ar' => '', 'place_en' => '', 'client_ar' => '', 'client_en' => '', 'scope_ar' => '', 'scope_en' => '',
  'year' => '', 'lead_ar' => '', 'lead_en' => '', 'body_ar' => '', 'body_en' => '',
  'cover' => '', 'featured' => 0, 'status' => 'live',
];

if ($id) {
  $s = db()->prepare('SELECT * FROM projects WHERE id = ? LIMIT 1');
  $s->execute([$id]);
  $row = $s->fetch();
  if (!$row) { http_response_code(404); exit('المشروع ده مش موجود.'); }
  $p = $row;
}

$err = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();

  // --- one gallery image removed -------------------------------
  if (isset($_POST['drop_image'])) {
    $imgId = (int) $_POST['drop_image'];
    $s = db()->prepare('SELECT * FROM project_images WHERE id = ? AND project_id = ?');
    $s->execute([$imgId, $id]);
    if ($img = $s->fetch()) {
      $file = IMG_DIR . '/' . basename($img['file']);
      if (is_file($file)) @unlink($file);
      db()->prepare('DELETE FROM project_images WHERE id = ?')->execute([$imgId]);
      flash('الصورة اتمسحت.');
    }
    redirect('project-edit.php?id=' . $id);
  }

  // --- the project itself --------------------------------------
  foreach (['tag','title_ar','title_en','place_ar','place_en','client_ar','client_en','scope_ar','scope_en','year','lead_ar','lead_en','body_ar','body_en'] as $k) {
    $p[$k] = trim((string) ($_POST[$k] ?? ''));
  }
  $p['sec']      = isset(SECTORS[$_POST['sec'] ?? '']) ? $_POST['sec'] : 'residential';
  $p['status']   = (($_POST['status'] ?? '') === 'draft') ? 'draft' : 'live';
  $p['featured'] = empty($_POST['featured']) ? 0 : 1;
  $p['slug']     = slugify((string) ($_POST['slug'] ?? '')) ?: slugify($p['title_en']);

  if ($p['title_ar'] === '' || $p['title_en'] === '') {
    $err = 'الاسم بالعربي والإنجليزي مطلوبين.';
  } elseif ($p['slug'] === '') {
    $err = 'محتاج slug — حروف إنجليزي وأرقام وشرطات.';
  } else {
    $s = db()->prepare('SELECT id FROM projects WHERE slug = ? AND id <> ? LIMIT 1');
    $s->execute([$p['slug'], $id]);
    if ($s->fetch()) $err = 'في مشروع تاني بنفس الـ slug.';
  }

  if (!$err) {
    try {
      $cover = save_upload($_FILES['cover'] ?? [], $p['slug']);
      if ($cover) $p['cover'] = $cover;

      if ($id) {
        db()->prepare(
          'UPDATE projects SET slug=?, sec=?, tag=?, title_ar=?, title_en=?, place_ar=?, place_en=?,
             client_ar=?, client_en=?, scope_ar=?, scope_en=?,
             year=?, lead_ar=?, lead_en=?, body_ar=?, body_en=?, cover=?, featured=?, status=?, updated_at=NOW()
           WHERE id=?'
        )->execute([
          $p['slug'], $p['sec'], $p['tag'] ?: null, $p['title_ar'], $p['title_en'],
          $p['place_ar'] ?: null, $p['place_en'] ?: null,
          $p['client_ar'] ?: null, $p['client_en'] ?: null,
          $p['scope_ar'] ?: null, $p['scope_en'] ?: null, $p['year'] ?: null,
          $p['lead_ar'] ?: null, $p['lead_en'] ?: null, $p['body_ar'] ?: null, $p['body_en'] ?: null,
          $p['cover'] ?: null, $p['featured'], $p['status'], $id,
        ]);
      } else {
        $next = (int) db()->query('SELECT COALESCE(MAX(sort), -1) + 1 FROM projects')->fetchColumn();
        db()->prepare(
          'INSERT INTO projects
             (slug, sec, tag, title_ar, title_en, place_ar, place_en,
              client_ar, client_en, scope_ar, scope_en, year,
              lead_ar, lead_en, body_ar, body_en, cover, featured, sort, status, created_at)
           VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW())'
        )->execute([
          $p['slug'], $p['sec'], $p['tag'] ?: null, $p['title_ar'], $p['title_en'],
          $p['place_ar'] ?: null, $p['place_en'] ?: null,
          $p['client_ar'] ?: null, $p['client_en'] ?: null,
          $p['scope_ar'] ?: null, $p['scope_en'] ?: null, $p['year'] ?: null,
          $p['lead_ar'] ?: null, $p['lead_en'] ?: null, $p['body_ar'] ?: null, $p['body_en'] ?: null,
          $p['cover'] ?: null, $p['featured'], $next, $p['status'],
        ]);
        $id = (int) db()->lastInsertId();
      }

      // --- gallery additions -------------------------------------
      if (!empty($_FILES['gallery']['name'][0])) {
        $g = $_FILES['gallery'];
        $n = (int) db()->query('SELECT COALESCE(MAX(sort), -1) + 1 FROM project_images WHERE project_id = ' . $id)->fetchColumn();
        for ($i = 0; $i < count($g['name']); $i++) {
          $one = [
            'name' => $g['name'][$i], 'type' => $g['type'][$i], 'tmp_name' => $g['tmp_name'][$i],
            'error' => $g['error'][$i], 'size' => $g['size'][$i],
          ];
          $file = save_upload($one, $p['slug']);
          if ($file) {
            db()->prepare('INSERT INTO project_images (project_id, file, sort, created_at) VALUES (?,?,?,NOW())')
                ->execute([$id, $file, $n++]);
          }
        }
      }

      flash('اتحفظ.');
      redirect('project-edit.php?id=' . $id);

    } catch (RuntimeException $e) {
      $err = $e->getMessage();
    } catch (PDOException $e) {
      error_log('aqm-dash project save: ' . $e->getMessage());
      $err = 'فشل الحفظ. جرب تاني.';
    }
  }
}

$images = [];
if ($id) {
  $s = db()->prepare('SELECT * FROM project_images WHERE project_id = ? ORDER BY sort, id');
  $s->execute([$id]);
  $images = $s->fetchAll();
}

$title = $id ? 'تعديل مشروع' : 'مشروع جديد';
require __DIR__ . '/head.php';
?>
<a class="back" href="projects.php">← كل المشروعات</a>
<h1><?= $id ? h($p['title_ar']) : 'مشروع جديد' ?></h1>

<?php if ($err): ?><p class="note bad"><?= h($err) ?></p><?php endif; ?>

<form method="post" enctype="multipart/form-data">
  <?= csrf_field() ?>
  <div class="split">
    <div class="box">
      <h2>المحتوى</h2>

      <label>الاسم بالعربي <i>*</i>
        <input type="text" name="title_ar" value="<?= h($p['title_ar']) ?>" required>
      </label>
      <label>الاسم بالإنجليزي <i>*</i>
        <input type="text" name="title_en" dir="ltr" value="<?= h($p['title_en']) ?>" required>
      </label>

      <label>الوصف المختصر — عربي
        <textarea name="lead_ar"><?= h($p['lead_ar']) ?></textarea>
      </label>
      <label>الوصف المختصر — إنجليزي
        <textarea name="lead_en" dir="ltr"><?= h($p['lead_en']) ?></textarea>
      </label>

      <label>التفاصيل — عربي
        <textarea name="body_ar" style="min-height:160px"><?= h($p['body_ar']) ?></textarea>
      </label>
      <label>التفاصيل — إنجليزي
        <textarea name="body_en" dir="ltr" style="min-height:160px"><?= h($p['body_en']) ?></textarea>
      </label>
    </div>

    <div class="box">
      <h2>التصنيف</h2>
      <label>القطاع
        <select name="sec">
          <?php foreach (SECTORS as $k => $v): ?>
            <option value="<?= h($k) ?>"<?= $p['sec'] === $k ? ' selected' : '' ?>><?= h($v) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <label>التصنيف الصغير <span class="hint">HOTEL · VILLA · RESORT…</span>
        <input type="text" name="tag" dir="ltr" value="<?= h($p['tag']) ?>">
      </label>
      <label>المكان — عربي
        <input type="text" name="place_ar" value="<?= h($p['place_ar']) ?>">
      </label>
      <label>المكان — إنجليزي
        <input type="text" name="place_en" dir="ltr" value="<?= h($p['place_en']) ?>">
      </label>
      <label>العميل — عربي
        <input type="text" name="client_ar" value="<?= h($p['client_ar']) ?>">
      </label>
      <label>العميل — إنجليزي
        <input type="text" name="client_en" dir="ltr" value="<?= h($p['client_en']) ?>">
      </label>
      <label>نطاق العمل — عربي <span class="hint">سطر واحد مختصر</span>
        <input type="text" name="scope_ar" value="<?= h($p['scope_ar']) ?>">
      </label>
      <label>نطاق العمل — إنجليزي
        <input type="text" name="scope_en" dir="ltr" value="<?= h($p['scope_en']) ?>">
      </label>
      <label>السنة
        <input type="text" name="year" dir="ltr" value="<?= h($p['year']) ?>">
      </label>
      <label>الرابط (slug) <span class="hint">يتساب فاضي يتولّد لوحده</span>
        <input type="text" name="slug" dir="ltr" value="<?= h($p['slug']) ?>">
      </label>
      <label>الحالة
        <select name="status">
          <option value="live"<?= $p['status'] === 'live' ? ' selected' : '' ?>>منشور</option>
          <option value="draft"<?= $p['status'] === 'draft' ? ' selected' : '' ?>>مسودة</option>
        </select>
      </label>
      <label style="display:flex;align-items:center;gap:8px">
        <input type="checkbox" name="featured" value="1"<?= $p['featured'] ? ' checked' : '' ?>
               style="width:auto;margin:0">
        مشروع مميّز
      </label>

      <h2>الصورة الرئيسية</h2>
      <?php if ($p['cover']): ?>
        <img src="../assets/img/<?= h($p['cover']) ?>" alt=""
             style="width:100%;border-radius:9px;margin-bottom:10px;display:block">
      <?php endif; ?>
      <label>رفع صورة جديدة <span class="hint">jpg / png / webp — أقل من 8 ميجا</span>
        <input type="file" name="cover" accept="image/jpeg,image/png,image/webp">
      </label>

      <h2>صور إضافية</h2>
      <label>ضيف صور
        <input type="file" name="gallery[]" accept="image/jpeg,image/png,image/webp" multiple>
      </label>

      <button class="btn" type="submit">حفظ</button>
    </div>
  </div>
</form>

<?php if ($images): ?>
  <h2>الألبوم (<?= count($images) ?>)</h2>
  <div class="cards">
    <?php foreach ($images as $img): ?>
      <div class="card" style="padding:10px">
        <img src="../assets/img/<?= h($img['file']) ?>" alt=""
             style="width:100%;height:110px;object-fit:cover;border-radius:7px;display:block;margin-bottom:8px">
        <form method="post" onsubmit="return confirm('مسح الصورة دي؟')">
          <?= csrf_field() ?>
          <input type="hidden" name="drop_image" value="<?= (int) $img['id'] ?>">
          <button class="btn danger sm" type="submit">مسح</button>
        </form>
      </div>
    <?php endforeach; ?>
  </div>
<?php endif; ?>
<?php require __DIR__ . '/foot.php';
