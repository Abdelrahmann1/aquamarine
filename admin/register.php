<?php
// ============================================================
//  Enrolment. Anyone may ask for an account; nobody gets in
//  until an administrator switches them to active, so an open
//  form can never become an open door.
// ============================================================
$GLOBALS['SKIP_NAV'] = true;
require __DIR__ . '/lib.php';
session_boot();

if (!tables_ready()) redirect('install.php');
if (current_user()) redirect('index.php');

$err = '';
$done = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  $name  = trim((string) ($_POST['name'] ?? ''));
  $email = trim((string) ($_POST['email'] ?? ''));
  $pass  = (string) ($_POST['pass'] ?? '');
  $again = (string) ($_POST['again'] ?? '');

  if ($name === '' || $email === '' || $pass === '') {
    $err = 'كل الخانات مطلوبة.';
  } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $err = 'الإيميل مش صحيح.';
  } elseif (strlen($pass) < 10) {
    $err = 'الباسورد لازم 10 حروف على الأقل.';
  } elseif ($pass !== $again) {
    $err = 'الباسورد والتأكيد مش زي بعض.';
  } else {
    $s = db()->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $s->execute([$email]);
    if ($s->fetch()) {
      $err = 'في حساب بالإيميل ده بالفعل.';
    } else {
      db()->prepare(
        'INSERT INTO users (name, email, pass, role, status, created_at)
         VALUES (?, ?, ?, "staff", "pending", NOW())'
      )->execute([$name, $email, password_hash($pass, PASSWORD_DEFAULT)]);
      $done = true;
    }
  }
}

$title = 'حساب جديد';
require __DIR__ . '/head.php';
?>
<div class="gate">
  <h1>حساب جديد</h1>

  <?php if ($done): ?>
    <p class="note good">تم التسجيل. المدير لازم يوافق على الحساب قبل ما تقدر تدخل.</p>
    <p><a class="btn" href="login.php">رجوع لتسجيل الدخول</a></p>

  <?php else: ?>
    <p class="hint">بعد التسجيل المدير بيوافق على الحساب، وبعدها تقدر تدخل.</p>
    <?php if ($err): ?><p class="note bad"><?= h($err) ?></p><?php endif; ?>

    <form method="post" autocomplete="off">
      <?= csrf_field() ?>
      <label>الاسم
        <input type="text" name="name" value="<?= h($_POST['name'] ?? '') ?>" required>
      </label>
      <label>الإيميل
        <input type="email" name="email" value="<?= h($_POST['email'] ?? '') ?>" required>
      </label>
      <label>الباسورد <span class="hint">10 حروف على الأقل</span>
        <input type="password" name="pass" minlength="10" required>
      </label>
      <label>تأكيد الباسورد
        <input type="password" name="again" minlength="10" required>
      </label>
      <button class="btn" type="submit">سجّل</button>
    </form>

    <p class="alt">عندك حساب؟ <a href="login.php">ادخل من هنا</a></p>
  <?php endif; ?>
</div>
<?php require __DIR__ . '/foot.php';
