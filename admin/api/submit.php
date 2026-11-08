<?php
// ============================================================
//  The site's forms post here. Public by necessity, so it takes
//  only what it needs, rate-limits by address, and answers JSON.
// ============================================================
require dirname(__DIR__) . '/lib.php';

header('Content-Type: application/json; charset=utf-8');

function out(array $data, int $code = 200): void {
  http_response_code($code);
  echo json_encode($data, JSON_UNESCAPED_UNICODE);
  exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') out(['ok' => false, 'error' => 'POST only'], 405);
if (!tables_ready())                       out(['ok' => false, 'error' => 'not installed'], 503);

// Accept a JSON body as readily as a form post.
$in = $_POST;
if (empty($in)) {
  $raw = file_get_contents('php://input');
  $j = json_decode((string) $raw, true);
  if (is_array($j)) $in = $j;
}

$get = static function (string $k, int $max = 190) use ($in): ?string {
  $v = $in[$k] ?? null;
  if (!is_scalar($v)) return null;
  $v = trim((string) $v);
  if ($v === '') return null;
  // Strip control characters, then cut to the column width.
  $v = preg_replace('/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/u', '', $v);
  return mb_substr($v, 0, $max);
};

// A field no human sees; anything that fills it is a bot. Answer
// cheerfully and store nothing.
if ($get('website') !== null) out(['ok' => true]);

$name  = $get('name', 120);
$phone = $get('phone', 40);
if ($name === null || $phone === null) {
  out(['ok' => false, 'error' => 'الاسم والتليفون مطلوبين'], 422);
}
if (!preg_match('/\d{7,}/', preg_replace('/\D+/', '', $phone))) {
  out(['ok' => false, 'error' => 'رقم التليفون مش صحيح'], 422);
}

// At most ten submissions an hour from one address.
$ip = client_ip();
$s = db()->prepare('SELECT COUNT(*) FROM leads WHERE ip = ? AND created_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)');
$s->execute([$ip]);
if ((int) $s->fetchColumn() >= 10) {
  out(['ok' => false, 'error' => 'طلبات كتير في وقت قصير. جرب بعد شوية.'], 429);
}

$kind = $get('kind', 10);
if (!isset(LEAD_KIND[$kind ?? ''])) $kind = 'order';

$email = $get('email');
if ($email !== null && !filter_var($email, FILTER_VALIDATE_EMAIL)) $email = null;

$amount = $in['amount'] ?? null;
$amount = (is_numeric($amount) && $amount >= 0) ? round((float) $amount, 2) : null;

$lang = $get('lang', 2);
$lang = ($lang === 'en') ? 'en' : 'ar';

try {
  db()->prepare(
    'INSERT INTO leads
       (kind, name, phone, email, service, pool_type, pool_size, amount,
        city, message, lang, page, ip, ua, created_at)
     VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW())'
  )->execute([
    $kind, $name, $phone, $email,
    $get('service', 160), $get('pool_type', 80), $get('pool_size', 80), $amount,
    $get('city', 120), $get('message', 4000), $lang, $get('page', 190),
    $ip, mb_substr((string) ($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 255),
  ]);
  $id = (int) db()->lastInsertId();
} catch (PDOException $e) {
  error_log('aqm-dash submit: ' . $e->getMessage());
  out(['ok' => false, 'error' => 'حصل خطأ. جرب تاني.'], 500);
}

// Tell the office, if an address is configured. A mail failure must not
// cost the lead, which is already saved.
$notify = cfg()['notify'] ?? '';
if ($notify) {
  $lines = [
    'طلب جديد من الموقع',
    '',
    'النوع:    ' . (LEAD_KIND[$kind] ?? $kind),
    'الاسم:    ' . $name,
    'التليفون: ' . $phone,
  ];
  if ($email)                 $lines[] = 'الإيميل:  ' . $email;
  if ($get('service', 160))   $lines[] = 'الخدمة:   ' . $get('service', 160);
  if ($get('pool_type', 80))  $lines[] = 'الحمام:   ' . $get('pool_type', 80) . ' ' . (string) $get('pool_size', 80);
  if ($amount !== null)       $lines[] = 'السعر:    ' . number_format($amount, 0) . ' ج.م';
  if ($get('message', 4000))  $lines[] = "\n" . $get('message', 4000);
  $lines[] = '';
  $lines[] = rtrim((string) (cfg()['site'] ?? ''), '/') . '/admin/lead.php?id=' . $id;

  @mail(
    $notify,
    '=?UTF-8?B?' . base64_encode('طلب جديد — ' . $name) . '?=',
    implode("\n", $lines),
    "MIME-Version: 1.0\r\nContent-Type: text/plain; charset=UTF-8\r\n"
    . 'From: site@' . (string) ($_SERVER['HTTP_HOST'] ?? 'localhost')
  );
}

out(['ok' => true, 'id' => $id]);
