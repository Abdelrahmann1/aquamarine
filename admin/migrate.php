<?php
// ============================================================
//  Build any table the dashboard is missing, and — the first
//  time only — fill projects from the site's own six entries.
//  Safe to run again: nothing is dropped or overwritten.
// ============================================================
require __DIR__ . '/lib.php';
$me = require_admin();

$SCHEMA = require __DIR__ . '/schema.php';
$report = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();

  foreach ($SCHEMA as $name => $sql) {
    try {
      db()->exec($sql);
      $report[$name] = 'جاهز';
    } catch (PDOException $e) {
      error_log('aqm-dash migrate ' . $name . ': ' . $e->getMessage());
      $report[$name] = 'فشل — شوف اللوج';
    }
  }

  // Seed the projects once, from the file the build ships.
  $seed = __DIR__ . '/seed-projects.json';
  if (isset($report['projects']) && $report['projects'] === 'جاهز' && is_file($seed)) {
    $have = (int) db()->query('SELECT COUNT(*) FROM projects')->fetchColumn();
    if ($have === 0) {
      $rows = json_decode((string) file_get_contents($seed), true);
      if (is_array($rows)) {
        $ins = db()->prepare(
          'INSERT INTO projects
             (slug, sec, tag, title_ar, title_en, lead_ar, lead_en,
              place_ar, place_en, client_ar, client_en, scope_ar, scope_en,
              body_ar, body_en, cover, sort, status, created_at)
           VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"live",NOW())'
        );
        $i = 0;
        foreach ($rows as $r) {
          $ins->execute([
            $r['slug'] ?? '', $r['sec'] ?? 'residential', $r['tag'] ?? null,
            $r['title_ar'] ?? '', $r['title_en'] ?? '',
            $r['lead_ar'] ?? null, $r['lead_en'] ?? null,
            $r['place_ar'] ?? null, $r['place_en'] ?? null,
            $r['client_ar'] ?? null, $r['client_en'] ?? null,
            $r['scope_ar'] ?? null, $r['scope_en'] ?? null,
            $r['body_ar'] ?? null, $r['body_en'] ?? null,
            $r['cover'] ?? null, $i++,
          ]);
        }
        $report['projects'] = 'جاهز — واتعبّى بـ ' . $i . ' مشروع';
      }
    }
  }
}

$have = [];
foreach (array_keys($SCHEMA) as $t) {
  try { db()->query('SELECT 1 FROM `' . $t . '` LIMIT 1'); $have[$t] = true; }
  catch (PDOException $e) { $have[$t] = false; }
}

$title = 'تحديث قاعدة البيانات';
require __DIR__ . '/head.php';
?>
<h1>تحديث قاعدة البيانات</h1>
<p class="sub">بيعمل الجداول الناقصة بس. مش بيمسح ولا بيغيّر حاجة موجودة.</p>

<?php if ($report): ?>
  <div class="panel" style="margin-bottom:20px">
    <div class="tbl-scroll"><table>
      <thead><tr><th>الجدول</th><th>النتيجة</th></tr></thead>
      <tbody>
        <?php foreach ($report as $t => $r): ?>
          <tr><td><code><?= h($t) ?></code></td><td><?= h($r) ?></td></tr>
        <?php endforeach; ?>
      </tbody>
    </table></div>
  </div>
<?php endif; ?>

<div class="panel">
  <div class="tbl-scroll"><table>
    <thead><tr><th>الجدول</th><th>الحالة دلوقتي</th></tr></thead>
    <tbody>
      <?php foreach ($have as $t => $ok): ?>
        <tr>
          <td><code><?= h($t) ?></code></td>
          <td><?= $ok ? '<span class="pill s-won">موجود</span>' : '<span class="pill s-lost">ناقص</span>' ?></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table></div>
</div>

<form method="post" style="margin-top:20px">
  <?= csrf_field() ?>
  <button class="btn" type="submit">اعمل الجداول الناقصة</button>
</form>
<?php require __DIR__ . '/foot.php';
