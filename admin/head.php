<?php
// Shared page opening. $title is set by the page before requiring this.
// On install.php the tables may not exist yet, so the user lookup is guarded.
$me   = (isset($GLOBALS['SKIP_NAV']) || !tables_ready()) ? null : current_user();
$here = basename((string) ($_SERVER['PHP_SELF'] ?? ''));
$msg  = flash();
?><!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow">
<title><?= h($title ?? 'لوحة التحكم') ?> — Aqua Marine</title>
<link rel="stylesheet" href="admin.css?v=1">
</head>
<body class="<?= $me ? 'in' : 'out' ?>">

<?php if ($me): ?>
<header class="top">
  <div class="wrap">
    <a class="brand" href="index.php">Aqua&nbsp;Marine <span>لوحة التحكم</span></a>
    <nav class="nav">
      <a href="index.php"<?= $here === 'index.php' ? ' class="on"' : '' ?>>الرئيسية</a>
      <a href="leads.php"<?= in_array($here, ['leads.php', 'lead.php'], true) ? ' class="on"' : '' ?>>الطلبات</a>
      <a href="projects.php"<?= in_array($here, ['projects.php', 'project-edit.php'], true) ? ' class="on"' : '' ?>>المشروعات</a>
      <a href="site.php"<?= $here === 'site.php' ? ' class="on"' : '' ?>>إعدادات الموقع</a>
      <?php if ($me['role'] === 'admin'): ?>
        <a href="users.php"<?= $here === 'users.php' ? ' class="on"' : '' ?>>المستخدمين</a>
        <?php // migrate.php stays on the server for a future upgrade, but off
              // the menu: it is a setup tool, not something to use day to day. ?>
      <?php endif; ?>
    </nav>
    <div class="who">
      <span><?= h($me['name']) ?></span>
      <a class="out-btn" href="logout.php">خروج</a>
    </div>
  </div>
</header>
<?php endif; ?>

<main class="wrap main">
<?php if ($msg): ?><p class="note good"><?= h($msg) ?></p><?php endif; ?>
