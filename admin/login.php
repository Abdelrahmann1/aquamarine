<?php
// ============================================================
//  Sign in. Five wrong tries lock the account for 15 minutes,
//  so a stolen email cannot be brute-forced.
// ============================================================
$GLOBALS['SKIP_NAV'] = true;
require __DIR__ . '/lib.php';
session_boot();

if (tables_ready() && current_user()) redirect('index.php');
if (!tables_ready()) redirect('install.php');

// Only ever bounce back to a page inside this folder.
$next = (string) ($_GET['next'] ?? 'index.php');
if (!preg_match('~^[a-z0-9_-]+\.php(\?[^\s"<>]*)?$~i', $next)) $next = 'index.php';

$err = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  $email = trim((string) ($_POST['email'] ?? ''));
  $pass  = (string) ($_POST['pass'] ?? '');

  $s = db()->prepare('SELECT * FROM users WHERE email = ? LIMIT 1');
  $s->execute([$email]);
  $u = $s->fetch();

  $locked = $u && $u['locked_until'] && strtotime($u['locked_until']) > time();

  if ($locked) {
    $mins = (int) ceil((strtotime($u['locked_until']) - time()) / 60);
    $err = 'الحساب مقفول مؤقتًا. جرب تاني بعد ' . $mins . ' دقيقة.';

  } elseif ($u && password_verify($pass, $u['pass'])) {
    if ($u['status'] === 'pending') {
      $err = 'حسابك اتسجل، بس لسه مستني موافقة المدير.';
    } elseif ($u['status'] === 'disabled') {
      $err = 'الحساب ده موقوف.';
    } else {
      sign_in($u);
      redirect($next);
    }

  } else {
    if ($u) {
      $n = (int) $u['failed'] + 1;
      $lock = $n >= 5 ? date('Y-m-d H:i:s', time() + 900) : null;
      db()->prepare('UPDATE users SET failed = ?, locked_until = ? WHERE id = ?')
          ->execute([$n, $lock, $u['id']]);
    }
    // The same message either way, so this page cannot be used to
    // discover which email addresses have an account.
    $err = 'الإيميل أو الباسورد غلط.';
  }
}

$title = 'تسجيل الدخول';
require __DIR__ . '/head.php';
?>
<div class="gate">
  <h1>لوحة تحكم Aqua Marine</h1>
  <p class="hint">سجّل دخولك عشان تشوف الطلبات.</p>

  <?php if ($err): ?><p class="note bad"><?= h($err) ?></p><?php endif; ?>

  <form method="post">
    <?= csrf_field() ?>
    <label>الإيميل
      <input type="email" name="email" value="<?= h($_POST['email'] ?? '') ?>" required autofocus>
    </label>
    <label>الباسورد
      <input type="password" name="pass" required>
    </label>
    <button class="btn" type="submit">دخول</button>
  </form>

  <p class="alt">معندكش حساب؟ <a href="register.php">سجّل واحد جديد</a></p>
</div>
<?php require __DIR__ . '/foot.php';
