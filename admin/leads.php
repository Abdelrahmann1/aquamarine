<?php
// The full list: filter by status, search by name or phone, page through.
require __DIR__ . '/lib.php';
if (!tables_ready()) redirect('install.php');
require_login();

$status = (string) ($_GET['status'] ?? '');
if ($status !== '' && !isset(LEAD_STATUS[$status])) $status = '';

$q    = trim((string) ($_GET['q'] ?? ''));
$page = max(1, (int) ($_GET['p'] ?? 1));
$per  = 25;

$where = [];
$args  = [];
if ($status !== '') { $where[] = 'status = ?'; $args[] = $status; }
if ($q !== '') {
  $where[] = '(name LIKE ? OR phone LIKE ? OR email LIKE ? OR service LIKE ?)';
  $like = '%' . $q . '%';
  array_push($args, $like, $like, $like, $like);
}
$sql = $where ? ' WHERE ' . implode(' AND ', $where) : '';

$found = (int) (function () use ($sql, $args) {
  $s = db()->prepare('SELECT COUNT(*) FROM leads' . $sql);
  $s->execute($args);
  return $s->fetchColumn();
})();

$pages = max(1, (int) ceil($found / $per));
$page  = min($page, $pages);
$off   = ($page - 1) * $per;

// LIMIT and OFFSET are integers we computed, never user text.
$s = db()->prepare('SELECT * FROM leads' . $sql . ' ORDER BY created_at DESC LIMIT ' . $per . ' OFFSET ' . $off);
$s->execute($args);
$rows = $s->fetchAll();

$keep = static function (array $over = []) use ($status, $q) {
  $p = array_filter(array_merge(['status' => $status, 'q' => $q], $over), static fn($v) => $v !== '' && $v !== null);
  return $p ? '?' . http_build_query($p) : '';
};

$title = 'الطلبات';
require __DIR__ . '/head.php';
?>
<h1>الطلبات</h1>
<p class="sub"><?= $found ?> طلب<?= $status || $q ? ' بالفلتر الحالي' : '' ?>.</p>

<div class="bar">
  <a class="chip<?= $status === '' ? ' on' : '' ?>" href="leads.php<?= $q ? '?q=' . urlencode($q) : '' ?>">الكل</a>
  <?php foreach (LEAD_STATUS as $k => $label): ?>
    <a class="chip<?= $status === $k ? ' on' : '' ?>" href="leads.php<?= $keep(['status' => $k, 'p' => null]) ?>"><?= h($label) ?></a>
  <?php endforeach; ?>

  <form class="grow" method="get">
    <?php if ($status !== ''): ?><input type="hidden" name="status" value="<?= h($status) ?>"><?php endif; ?>
    <input type="search" name="q" value="<?= h($q) ?>" placeholder="اسم أو تليفون…" style="width:220px;margin:0">
    <button class="btn sm" type="submit">بحث</button>
    <a class="btn ghost sm" href="export.php<?= $keep() ?>">تحميل CSV</a>
  </form>
</div>

<div class="panel">
  <div class="tbl-scroll">
  <table>
    <thead>
      <tr>
        <th>الاسم</th><th>التليفون</th><th>النوع</th><th>الخدمة</th>
        <th>الحمام</th><th>السعر</th><th>الحالة</th><th>التاريخ</th>
      </tr>
    </thead>
    <tbody>
      <?php if (!$rows): ?>
        <tr><td colspan="8" class="empty">مفيش نتايج.</td></tr>
      <?php endif; ?>
      <?php foreach ($rows as $l): ?>
        <tr>
          <td><a href="lead.php?id=<?= (int) $l['id'] ?>"><?= h($l['name']) ?></a></td>
          <td class="num" dir="ltr"><?= h($l['phone']) ?></td>
          <td><span class="tag"><?= h(LEAD_KIND[$l['kind']] ?? $l['kind']) ?></span></td>
          <td><?= h($l['service'] ?: '—') ?></td>
          <td class="dim"><?= h(trim(($l['pool_type'] ?? '') . ' ' . ($l['pool_size'] ?? '')) ?: '—') ?></td>
          <td class="num"><?= $l['amount'] !== null ? h(money((float) $l['amount'])) : '—' ?></td>
          <td><span class="pill s-<?= h($l['status']) ?>"><?= h(LEAD_STATUS[$l['status']]) ?></span></td>
          <td class="dim"><?= h(when($l['created_at'])) ?></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
  </div>
</div>

<?php if ($pages > 1): ?>
  <div class="bar" style="margin-top:16px">
    <?php for ($i = 1; $i <= $pages; $i++): ?>
      <a class="chip<?= $i === $page ? ' on' : '' ?>" href="leads.php<?= $keep(['p' => $i]) ?>"><?= $i ?></a>
    <?php endfor; ?>
  </div>
<?php endif; ?>
<?php require __DIR__ . '/foot.php';
