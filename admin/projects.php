<?php
// The projects, in the order they appear on the site.
require __DIR__ . '/lib.php';
if (!tables_ready()) redirect('install.php');
$me = require_login();

try {
  db()->query('SELECT 1 FROM projects LIMIT 1');
} catch (PDOException $e) {
  $title = 'المشروعات';
  require __DIR__ . '/head.php';
  echo '<h1>المشروعات</h1><p class="note bad">جدول المشروعات لسه مش موجود.</p>'
     . ($me['role'] === 'admin'
        ? '<p><a class="btn" href="migrate.php">اعمل الجداول</a></p>'
        : '<p class="hint">كلّم المدير يعمل الجداول.</p>');
  require __DIR__ . '/foot.php';
  exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  $id = (int) ($_POST['id'] ?? 0);
  $do = (string) ($_POST['do'] ?? '');

  if ($do === 'delete' && $id) {
    if ($me['role'] !== 'admin') { http_response_code(403); exit('المسح للمدير بس.'); }
    // The images rows go with it (ON DELETE CASCADE); the files on disk
    // are removed here so nothing is orphaned.
    $s = db()->prepare('SELECT file FROM project_images WHERE project_id = ?');
    $s->execute([$id]);
    foreach ($s->fetchAll() as $img) {
      $p = __DIR__ . '/../assets/img/projects/' . basename($img['file']);
      if (is_file($p)) @unlink($p);
    }
    db()->prepare('DELETE FROM projects WHERE id = ?')->execute([$id]);
    flash('المشروع اتمسح.');
  }

  if (($do === 'up' || $do === 'down') && $id) {
    $dir = $do === 'up' ? -1 : 1;
    db()->prepare('UPDATE projects SET sort = sort + ? WHERE id = ?')->execute([$dir * 15, $id]);
    // Re-number from zero so the gaps never grow.
    $k = 0;
    foreach (db()->query('SELECT id FROM projects ORDER BY sort, id')->fetchAll() as $r) {
      db()->prepare('UPDATE projects SET sort = ? WHERE id = ?')->execute([$k++, $r['id']]);
    }
  }

  if ($do === 'toggle' && $id) {
    db()->prepare('UPDATE projects SET status = IF(status = "live", "draft", "live") WHERE id = ?')
        ->execute([$id]);
  }

  redirect('projects.php');
}

$rows = db()->query(
  'SELECT p.*, (SELECT COUNT(*) FROM project_images i WHERE i.project_id = p.id) AS imgs
   FROM projects p ORDER BY p.sort, p.id'
)->fetchAll();

$title = 'المشروعات';
require __DIR__ . '/head.php';

$btn = static function (int $id, string $do, string $label, string $cls = 'ghost', string $ask = ''): string {
  $on = $ask ? ' onsubmit="return confirm(\'' . h($ask) . '\')"' : '';
  return '<form method="post" style="display:inline"' . $on . '>' . csrf_field()
       . '<input type="hidden" name="id" value="' . $id . '">'
       . '<input type="hidden" name="do" value="' . h($do) . '">'
       . '<button class="btn ' . h($cls) . ' sm" type="submit">' . h($label) . '</button></form> ';
};
?>
<h1>المشروعات</h1>
<p class="sub"><?= count($rows) ?> مشروع. الترتيب هنا هو الترتيب على الموقع.</p>

<p><a class="btn" href="project-edit.php">+ مشروع جديد</a></p>

<div class="panel">
  <div class="tbl-scroll">
  <table>
    <thead>
      <tr><th>الصورة</th><th>المشروع</th><th>القطاع</th><th>صور</th><th>الحالة</th><th>الترتيب</th><th></th></tr>
    </thead>
    <tbody>
      <?php if (!$rows): ?>
        <tr><td colspan="7" class="empty">مفيش مشروعات. اضغط «مشروع جديد».</td></tr>
      <?php endif; ?>
      <?php foreach ($rows as $p): ?>
        <tr>
          <td>
            <?php if ($p['cover']): ?>
              <img src="../assets/img/<?= h(strpos($p['cover'], '/') === false ? $p['cover'] : $p['cover']) ?>"
                   alt="" style="width:76px;height:50px;object-fit:cover;border-radius:7px;display:block">
            <?php else: ?><span class="hint">—</span><?php endif; ?>
          </td>
          <td>
            <a href="project-edit.php?id=<?= (int) $p['id'] ?>"><?= h($p['title_ar']) ?></a>
            <div class="hint" dir="ltr"><?= h($p['title_en']) ?></div>
          </td>
          <td><span class="tag"><?= h($p['sec']) ?></span></td>
          <td class="num"><?= (int) $p['imgs'] ?></td>
          <td>
            <?= $p['status'] === 'live'
                ? '<span class="pill s-won">منشور</span>'
                : '<span class="pill s-contacted">مسودة</span>' ?>
          </td>
          <td style="white-space:nowrap">
            <?= $btn((int) $p['id'], 'up', '▲') ?><?= $btn((int) $p['id'], 'down', '▼') ?>
          </td>
          <td style="white-space:nowrap">
            <a class="btn ghost sm" href="project-edit.php?id=<?= (int) $p['id'] ?>">تعديل</a>
            <?= $btn((int) $p['id'], 'toggle', $p['status'] === 'live' ? 'اخفي' : 'انشر') ?>
            <?php if ($me['role'] === 'admin'): ?>
              <?= $btn((int) $p['id'], 'delete', 'مسح', 'danger', 'مسح المشروع ده وصوره نهائي. متأكد؟') ?>
            <?php endif; ?>
          </td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
  </div>
</div>
<?php require __DIR__ . '/foot.php';
