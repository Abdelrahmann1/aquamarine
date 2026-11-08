<?php
// ============================================================
//  AQUA MARINE — dashboard core
//  Database, session, authentication, CSRF, small helpers.
//  Every page starts by requiring this file.
// ============================================================
declare(strict_types=1);

// Errors go to the log, never to the browser: a stack trace on a live
// page hands an attacker the file paths and the database name.
error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

function cfg(): array {
  static $c = null;
  if ($c === null) {
    $f = __DIR__ . '/config.php';
    if (!is_file($f)) {
      http_response_code(500);
      exit('config.php is missing. Copy config.sample.php to config.php and fill it in.');
    }
    $c = require $f;
  }
  return $c;
}

// $soft is for the public pages: they must render even if the database
// is unreachable, so they get null back instead of a dead end.
function db(bool $soft = false): ?PDO {
  static $pdo = null;
  static $failed = false;
  if ($failed) {
    if ($soft) return null;
    http_response_code(500);
    exit('Database connection failed. Check admin/config.php.');
  }
  if ($pdo === null) {
    $c = cfg();
    try {
      $pdo = new PDO(
        'mysql:host=' . $c['db_host'] . ';dbname=' . $c['db_name'] . ';charset=utf8mb4',
        $c['db_user'], $c['db_pass'],
        [
          PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
          PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
          // Real prepared statements, so a parameter can never be parsed as SQL.
          PDO::ATTR_EMULATE_PREPARES   => false,
        ]
      );
    } catch (PDOException $e) {
      error_log('aqm-dash db: ' . $e->getMessage());
      $failed = true;
      if ($soft) return null;
      http_response_code(500);
      exit('Database connection failed. Check admin/config.php.');
    }
  }
  return $pdo;
}

function https_here(): bool {
  return (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
      || (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https');
}

function session_boot(): void {
  if (session_status() === PHP_SESSION_ACTIVE) return;
  session_set_cookie_params([
    'lifetime' => 0,
    'path'     => '/admin/',
    'secure'   => https_here(),
    'httponly' => true,       // JavaScript cannot read the session cookie
    'samesite' => 'Lax',      // and another site cannot send it along
  ]);
  session_name('aqm_dash');
  session_start();
}

// ------------------------------------------------------------
//  CSRF — every POST carries a token tied to the session
// ------------------------------------------------------------
function csrf(): string {
  session_boot();
  if (empty($_SESSION['csrf'])) {
    $_SESSION['csrf'] = bin2hex(random_bytes(32));
  }
  return $_SESSION['csrf'];
}

function csrf_field(): string {
  return '<input type="hidden" name="csrf" value="' . h(csrf()) . '">';
}

function csrf_check(): void {
  session_boot();
  $sent = $_POST['csrf'] ?? '';
  if (!is_string($sent) || empty($_SESSION['csrf']) || !hash_equals($_SESSION['csrf'], $sent)) {
    http_response_code(400);
    exit('انتهت صلاحية الصفحة. ارجع وحاول تاني.');
  }
}

// ------------------------------------------------------------
//  Who is signed in
// ------------------------------------------------------------
function current_user(): ?array {
  static $u = null;
  if ($u !== null) return $u ?: null;
  session_boot();
  $id = $_SESSION['uid'] ?? null;
  if (!$id) { $u = false; return null; }
  $s = db()->prepare('SELECT * FROM users WHERE id = ? AND status = "active" LIMIT 1');
  $s->execute([$id]);
  $row = $s->fetch();
  if (!$row) { session_destroy(); $u = false; return null; }
  $u = $row;
  return $row;
}

function require_login(): array {
  $u = current_user();
  if (!$u) {
    $to = urlencode($_SERVER['REQUEST_URI'] ?? '/admin/');
    header('Location: login.php?next=' . $to);
    exit;
  }
  return $u;
}

function require_admin(): array {
  $u = require_login();
  if ($u['role'] !== 'admin') {
    http_response_code(403);
    exit('الصفحة دي للمدير بس.');
  }
  return $u;
}

function sign_in(array $user): void {
  session_boot();
  // A fresh session id on login, so a token captured beforehand is useless.
  session_regenerate_id(true);
  $_SESSION['uid'] = (int) $user['id'];
  $_SESSION['csrf'] = bin2hex(random_bytes(32));
  db()->prepare('UPDATE users SET last_login = NOW(), failed = 0, locked_until = NULL WHERE id = ?')
      ->execute([$user['id']]);
}

function sign_out(): void {
  session_boot();
  $_SESSION = [];
  if (ini_get('session.use_cookies')) {
    $p = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000, $p['path'], $p['domain'], $p['secure'], $p['httponly']);
  }
  session_destroy();
}

// ------------------------------------------------------------
//  Helpers
// ------------------------------------------------------------
function h($s): string {
  return htmlspecialchars((string) $s, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function redirect(string $to): void {
  header('Location: ' . $to);
  exit;
}

function flash(?string $msg = null): ?string {
  session_boot();
  if ($msg !== null) { $_SESSION['flash'] = $msg; return null; }
  $m = $_SESSION['flash'] ?? null;
  unset($_SESSION['flash']);
  return $m;
}

function client_ip(): string {
  return substr((string) ($_SERVER['REMOTE_ADDR'] ?? ''), 0, 45);
}

function money(?float $n): string {
  if ($n === null) return '—';
  return number_format($n, 0) . ' ج.م';
}

function when(?string $dt): string {
  if (!$dt) return '—';
  return date('Y/m/d · H:i', strtotime($dt));
}

const LEAD_STATUS = [
  'new'       => 'جديد',
  'contacted' => 'تم التواصل',
  'quoted'    => 'عرض سعر',
  'won'       => 'تم التعاقد',
  'lost'      => 'مرفوض',
];

const LEAD_KIND = [
  'quote'   => 'طلب تسعير',
  'order'   => 'طلب خدمة',
  'contact' => 'رسالة تواصل',
];

function tables_ready(): bool {
  try {
    db()->query('SELECT 1 FROM users LIMIT 1');
    return true;
  } catch (PDOException $e) {
    return false;
  }
}
