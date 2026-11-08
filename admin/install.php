<?php
// ============================================================
//  First run: build the tables and the first administrator.
//  Once one administrator exists this page refuses to do anything,
//  so it cannot be used to mint a second one later.
// ============================================================
$GLOBALS['SKIP_NAV'] = true;
require __DIR__ . '/lib.php';

// Setup is reachable only with the key from config.php. Without it this
// page does not exist, so the gap before the first administrator is shut.
$key = (string) (cfg()['install_key'] ?? '');
if ($key === '' || !hash_equals($key, (string) ($_GET['key'] ?? $_POST['key'] ?? ''))) {
  http_response_code(404);
  exit('Not found.');
}

$SCHEMA = require __DIR__ . '/schema.php';


$err = '';
$done = false;

// Already set up? Then this page is closed for good.
$locked = false;
if (tables_ready()) {
  $n = (int) db()->query('SELECT COUNT(*) FROM users WHERE role = "admin"')->fetchColumn();
  $locked = $n > 0;
}

if (!$locked && $_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  $name  = trim((string) ($_POST['name'] ?? ''));
  $email = trim((string) ($_POST['email'] ?? ''));
  $pass  = (string) ($_POST['pass'] ?? '');

  if ($name === '' || $email === '' || $pass === '') {
    $err = 'كل الخانات مطلوبة.';
  } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $err = 'الإيميل مش صحيح.';
  } elseif (strlen($pass) < 10) {
    $err = 'الباسورد لازم 10 حروف على الأقل.';
  } else {
    try {
      foreach ($SCHEMA as $sql) { db()->exec($sql); }
      $s = db()->prepare(
        'INSERT INTO users (name, email, pass, role, status, created_at)
         VALUES (?, ?, ?, "admin", "active", NOW())'
      );
      $s->execute([$name, $email, password_hash($pass, PASSWORD_DEFAULT)]);
      $done = true;
    } catch (PDOException $e) {
      error_log('aqm-dash install: ' . $e->getMessage());
      $err = 'فشل إنشاء الجداول. راجع صلاحيات اليوزر على الداتابيز.';
    }
  }
}

$title = 'تجهيز الداشبورد';
require __DIR__ . '/head.php';
?>
<div class="gate">
  <h1>تجهيز الداشبورد</h1>

  <?php if ($locked): ?>
    <p class="note bad">الداشبورد متجهّزة قبل كده. الصفحة دي مقفولة.</p>
    <p><a class="btn" href="login.php">تسجيل الدخول</a></p>
    <p class="hint">امسح <code>admin/install.php</code> من السيرفر.</p>

  <?php elseif ($done): ?>
    <p class="note good">تمام. الجداول اتعملت وحساب المدير جاهز.</p>
    <p><a class="btn" href="login.php">تسجيل الدخول</a></p>
    <p class="hint"><strong>مهم:</strong> امسح <code>admin/install.php</code> من السيرفر دلوقتي.</p>

  <?php else: ?>
    <p class="hint">الحساب ده هيبقى المدير. هو اللي هيوافق على أي حساب جديد بعد كده.</p>
    <?php if ($err): ?><p class="note bad"><?= h($err) ?></p><?php endif; ?>
    <form method="post" autocomplete="off">
      <?= csrf_field() ?>
      <input type="hidden" name="key" value="<?= h($_GET['key'] ?? '') ?>">
      <label>الاسم
        <input type="text" name="name" value="<?= h($_POST['name'] ?? '') ?>" required>
      </label>
      <label>الإيميل
        <input type="email" name="email" value="<?= h($_POST['email'] ?? '') ?>" required>
      </label>
      <label>الباسورد <span class="hint">10 حروف على الأقل</span>
        <input type="password" name="pass" minlength="10" required>
      </label>
      <button class="btn" type="submit">ابدأ</button>
    </form>
  <?php endif; ?>
</div>
<?php require __DIR__ . '/foot.php';
