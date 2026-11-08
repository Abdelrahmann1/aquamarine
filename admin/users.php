<?php
// Who may sign in. Administrators approve new registrations here.
require __DIR__ . '/lib.php';
if (!tables_ready()) redirect('install.php');
$me = require_admin();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  $id = (int) ($_POST['id'] ?? 0);
  $do = (string) ($_POST['do'] ?? '');

  // An administrator cannot lock themselves out of their own dashboard.
  if ($id === (int) $me['id'] && in_array($do, ['disable', 'delete', 'staff'], true)) {
    flash('مينفعش تعمل كده على حسابك إنت.');
    redirect('users.php');
  }

  $map = [
    'approve' => 'UPDATE users SET status = "active", failed = 0, locked_until = NULL WHERE id = ?',
    'disable' => 'UPDATE users SET status = "disabled" WHERE id = ?',
    'admin'   => 'UPDATE users SET role = "admin" WHERE id = ?',
    'staff'   => 'UPDATE users SET role = "staff" WHERE id = ?',
    'unlock'  => 'UPDATE users SET failed = 0, locked_until = NULL WHERE id = ?',
    'delete'  => 'DELETE FROM users WHERE id = ?',
  ];

  if (isset($map[$do]) && $id) {
    // Never delete or demote the last administrator.
    if (in_array($do, ['delete', 'disable', 'staff'], true)) {
      $admins = (int) db()->query('SELECT COUNT(*) FROM users WHERE role = "admin" AND status = "active"')->fetchColumn();
      $t = db()->prepare('SELECT role, status FROM users WHERE id = ?');
      $t->execute([$id]);
      $target = $t->fetch();
      if ($target && $target['role'] === 'admin' && $target['status'] === 'active' && $admins <= 1) {
        flash('ده آخر مدير — لازم يفضل واحد على الأقل.');
        redirect('users.php');
      }
    }
    db()->prepare($map[$do])->execute([$id]);
    flash('اتعمل.');
  }
  redirect('users.php');
}

$rows = db()->query('SELECT * FROM users ORDER BY FIELD(status,"pending","active","disabled"), created_at DESC')->fetchAll();

$title = 'المستخدمين';
require __DIR__ . '/head.php';

$act = static function (int $id, string $do, string $label, string $cls = 'ghost', string $confirm = ''): string {
  $on = $confirm ? ' onsubmit="return confirm(\'' . h($confirm) . '\')"' : '';
  return '<form method="post" style="display:inline"' . $on . '>' . csrf_field()
       . '<input type="hidden" name="id" value="' . $id . '">'
       . '<input type="hidden" name="do" value="' . h($do) . '">'
       . '<button class="btn ' . h($cls) . ' sm" type="submit">' . h($label) . '</button></form> ';
};
?>
<h1>المستخدمين</h1>
<p class="sub">أي حساب جديد بيفضل <strong>مستني</strong> لحد ما توافق عليه.</p>

<div class="panel">
  <div class="tbl-scroll">
  <table>
    <thead>
      <tr><th>الاسم</th><th>الإيميل</th><th>الصلاحية</th><th>الحالة</th><th>آخر دخول</th><th>إجراءات</th></tr>
    </thead>
    <tbody>
      <?php foreach ($rows as $u):
        $locked = $u['locked_until'] && strtotime($u['locked_until']) > time(); ?>
        <tr>
          <td><?= h($u['name']) ?><?= (int) $u['id'] === (int) $me['id'] ? ' <span class="tag">إنت</span>' : '' ?></td>
          <td class="dim" dir="ltr"><?= h($u['email']) ?></td>
          <td><span class="tag"><?= $u['role'] === 'admin' ? 'مدير' : 'موظف' ?></span></td>
          <td>
            <?php if ($u['status'] === 'pending'): ?><span class="pill s-contacted">مستني موافقة</span>
            <?php elseif ($u['status'] === 'disabled'): ?><span class="pill s-lost">موقوف</span>
            <?php else: ?><span class="pill s-won">نشط</span><?php endif; ?>
            <?php if ($locked): ?><span class="pill s-lost">مقفول</span><?php endif; ?>
          </td>
          <td class="dim"><?= h(when($u['last_login'])) ?></td>
          <td style="white-space:nowrap">
            <?php
              if ($u['status'] !== 'active') echo $act((int) $u['id'], 'approve', 'تفعيل', '');
              if ($u['status'] === 'active')  echo $act((int) $u['id'], 'disable', 'إيقاف');
              if ($locked)                    echo $act((int) $u['id'], 'unlock', 'فك القفل');
              echo $u['role'] === 'admin'
                ? $act((int) $u['id'], 'staff', 'خليه موظف')
                : $act((int) $u['id'], 'admin', 'خليه مدير');
              echo $act((int) $u['id'], 'delete', 'مسح', 'danger', 'مسح الحساب ده نهائي. متأكد؟');
            ?>
          </td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
  </div>
</div>
<?php require __DIR__ . '/foot.php';
