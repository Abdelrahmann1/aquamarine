<?php
// Overview: the numbers worth seeing on arrival, then the newest leads.
require __DIR__ . '/lib.php';
if (!tables_ready()) redirect('install.php');
$me = require_login();

$total   = (int) db()->query('SELECT COUNT(*) FROM leads')->fetchColumn();
$byState = db()->query('SELECT status, COUNT(*) n FROM leads GROUP BY status')->fetchAll();
$counts  = array_fill_keys(array_keys(LEAD_STATUS), 0);
foreach ($byState as $r) { $counts[$r['status']] = (int) $r['n']; }

$month = (int) db()->query(
  'SELECT COUNT(*) FROM leads WHERE created_at >= DATE_FORMAT(NOW(), "%Y-%m-01")'
)->fetchColumn();

$worth = db()->query('SELECT SUM(amount) FROM leads WHERE amount IS NOT NULL')->fetchColumn();

$latest = db()->query('SELECT * FROM leads ORDER BY created_at DESC LIMIT 8')->fetchAll();

$pending = 0;
if ($me['role'] === 'admin') {
  $pending = (int) db()->query('SELECT COUNT(*) FROM users WHERE status = "pending"')->fetchColumn();
}

$title = 'الرئيسية';
require __DIR__ . '/head.php';
?>
<h1>أهلاً <?= h($me['name']) ?></h1>
<p class="sub">ملخّص الطلبات الجاية من الموقع.</p>

<?php if ($pending): ?>
  <p class="note bad">
    في <?= $pending ?> حساب مستني موافقتك.
    <a href="users.php">راجعهم</a>
  </p>
<?php endif; ?>

<div class="cards">
  <div class="card hot"><b><?= $counts['new'] ?></b><span>جديد — محتاج رد</span></div>
  <div class="card"><b><?= $counts['contacted'] ?></b><span>تم التواصل</span></div>
  <div class="card"><b><?= $counts['quoted'] ?></b><span>عرض سعر</span></div>
  <div class="card"><b><?= $counts['won'] ?></b><span>تم التعاقد</span></div>
  <div class="card"><b><?= $month ?></b><span>الشهر ده</span></div>
  <div class="card"><b><?= $total ?></b><span>إجمالي الطلبات</span></div>
</div>

<?php if ($worth): ?>
  <p class="sub">إجمالي قيمة الطلبات اللي اتحسبلها سعر: <strong><?= h(money((float) $worth)) ?></strong></p>
<?php endif; ?>

<h2>آخر الطلبات</h2>
<div class="panel">
  <div class="tbl-scroll">
  <table>
    <thead>
      <tr>
        <th>الاسم</th><th>التليفون</th><th>النوع</th>
        <th>الخدمة</th><th>السعر</th><th>الحالة</th><th>التاريخ</th>
      </tr>
    </thead>
    <tbody>
      <?php if (!$latest): ?>
        <tr><td colspan="7" class="empty">مفيش طلبات لسه. أول ما حد يبعت من الموقع هيظهر هنا.</td></tr>
      <?php endif; ?>
      <?php foreach ($latest as $l): ?>
        <tr>
          <td><a href="lead.php?id=<?= (int) $l['id'] ?>"><?= h($l['name']) ?></a></td>
          <td class="num" dir="ltr"><?= h($l['phone']) ?></td>
          <td><span class="tag"><?= h(LEAD_KIND[$l['kind']] ?? $l['kind']) ?></span></td>
          <td><?= h($l['service'] ?: '—') ?></td>
          <td class="num"><?= $l['amount'] !== null ? h(money((float) $l['amount'])) : '—' ?></td>
          <td><span class="pill s-<?= h($l['status']) ?>"><?= h(LEAD_STATUS[$l['status']]) ?></span></td>
          <td class="dim"><?= h(when($l['created_at'])) ?></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
  </div>
</div>

<p style="margin-top:16px"><a class="btn ghost" href="leads.php">كل الطلبات</a></p>
<?php require __DIR__ . '/foot.php';
