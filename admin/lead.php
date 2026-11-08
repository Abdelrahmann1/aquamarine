<?php
// One lead: everything the visitor sent, plus the status and the note.
require __DIR__ . '/lib.php';
if (!tables_ready()) redirect('install.php');
$me = require_login();

$id = (int) ($_GET['id'] ?? 0);
$s = db()->prepare('SELECT * FROM leads WHERE id = ? LIMIT 1');
$s->execute([$id]);
$l = $s->fetch();
if (!$l) { http_response_code(404); exit('الطلب ده مش موجود.'); }

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();

  if (isset($_POST['delete'])) {
    if ($me['role'] !== 'admin') { http_response_code(403); exit('المسح للمدير بس.'); }
    db()->prepare('DELETE FROM leads WHERE id = ?')->execute([$id]);
    flash('الطلب اتمسح.');
    redirect('leads.php');
  }

  $status = (string) ($_POST['status'] ?? 'new');
  if (!isset(LEAD_STATUS[$status])) $status = 'new';
  $note = trim((string) ($_POST['note'] ?? ''));

  db()->prepare('UPDATE leads SET status = ?, note = ? WHERE id = ?')
      ->execute([$status, $note !== '' ? $note : null, $id]);

  flash('اتحفظ.');
  redirect('lead.php?id=' . $id);
}

$waPhone = preg_replace('/\D+/', '', (string) $l['phone']);
if (strpos($waPhone, '0') === 0) $waPhone = '2' . $waPhone;   // Egyptian local to international

$title = 'طلب #' . $l['id'];
require __DIR__ . '/head.php';
?>
<a class="back" href="leads.php">← كل الطلبات</a>
<h1><?= h($l['name']) ?></h1>
<p class="sub">
  <span class="tag"><?= h(LEAD_KIND[$l['kind']] ?? $l['kind']) ?></span>
  · وصل <?= h(when($l['created_at'])) ?>
</p>

<div class="split">
  <div class="box">
    <h2>تفاصيل الطلب</h2>
    <dl class="facts">
      <dt>الاسم</dt><dd><?= h($l['name']) ?></dd>
      <dt>التليفون</dt><dd class="ltr"><?= h($l['phone']) ?></dd>
      <?php if ($l['email']): ?><dt>الإيميل</dt><dd class="ltr"><?= h($l['email']) ?></dd><?php endif; ?>
      <?php if ($l['city']): ?><dt>المنطقة</dt><dd><?= h($l['city']) ?></dd><?php endif; ?>
      <?php if ($l['service']): ?><dt>الخدمة</dt><dd><?= h($l['service']) ?></dd><?php endif; ?>
      <?php if ($l['pool_type']): ?><dt>نوع الحمام</dt><dd><?= h($l['pool_type']) ?></dd><?php endif; ?>
      <?php if ($l['pool_size']): ?><dt>المقاس</dt><dd class="ltr"><?= h($l['pool_size']) ?></dd><?php endif; ?>
      <?php if ($l['amount'] !== null): ?><dt>السعر المحسوب</dt><dd><?= h(money((float) $l['amount'])) ?></dd><?php endif; ?>
      <dt>اللغة</dt><dd><?= $l['lang'] === 'en' ? 'إنجليزي' : 'عربي' ?></dd>
      <?php if ($l['page']): ?><dt>الصفحة</dt><dd class="ltr"><?= h($l['page']) ?></dd><?php endif; ?>
    </dl>

    <?php if ($l['message']): ?>
      <h2>الرسالة</h2>
      <p class="msg"><?= h($l['message']) ?></p>
    <?php endif; ?>

    <h2>تواصل</h2>
    <p>
      <a class="btn sm" href="https://wa.me/<?= h($waPhone) ?>" target="_blank" rel="noopener">واتساب</a>
      <a class="btn ghost sm" href="tel:<?= h($l['phone']) ?>">اتصال</a>
      <?php if ($l['email']): ?>
        <a class="btn ghost sm" href="mailto:<?= h($l['email']) ?>">إيميل</a>
      <?php endif; ?>
    </p>
  </div>

  <div class="box">
    <h2>الحالة والمتابعة</h2>
    <form method="post">
      <?= csrf_field() ?>
      <label>الحالة
        <select name="status">
          <?php foreach (LEAD_STATUS as $k => $label): ?>
            <option value="<?= h($k) ?>"<?= $l['status'] === $k ? ' selected' : '' ?>><?= h($label) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <label>ملاحظات داخلية
        <textarea name="note" placeholder="اللي اتقال في المكالمة، الميعاد، السعر المتفق عليه…"><?= h($l['note'] ?? '') ?></textarea>
      </label>
      <button class="btn" type="submit">حفظ</button>
    </form>

    <?php if ($me['role'] === 'admin'): ?>
      <form method="post" style="margin-top:24px"
            onsubmit="return confirm('مسح الطلب ده نهائي. متأكد؟')">
        <?= csrf_field() ?>
        <input type="hidden" name="delete" value="1">
        <button class="btn danger sm" type="submit">مسح الطلب</button>
      </form>
    <?php endif; ?>
  </div>
</div>
<?php require __DIR__ . '/foot.php';
