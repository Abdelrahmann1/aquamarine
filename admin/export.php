<?php
// The current filter, as a CSV Excel will open with Arabic intact.
require __DIR__ . '/lib.php';
if (!tables_ready()) redirect('install.php');
require_login();

$status = (string) ($_GET['status'] ?? '');
if ($status !== '' && !isset(LEAD_STATUS[$status])) $status = '';
$q = trim((string) ($_GET['q'] ?? ''));

$where = [];
$args  = [];
if ($status !== '') { $where[] = 'status = ?'; $args[] = $status; }
if ($q !== '') {
  $where[] = '(name LIKE ? OR phone LIKE ? OR email LIKE ? OR service LIKE ?)';
  $like = '%' . $q . '%';
  array_push($args, $like, $like, $like, $like);
}
$sql = $where ? ' WHERE ' . implode(' AND ', $where) : '';

$s = db()->prepare('SELECT * FROM leads' . $sql . ' ORDER BY created_at DESC');
$s->execute($args);

header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="leads-' . date('Y-m-d') . '.csv"');

$out = fopen('php://output', 'w');
// Excel needs the byte-order mark to read UTF-8 Arabic correctly.
fwrite($out, "\xEF\xBB\xBF");

fputcsv($out, [
  'رقم', 'النوع', 'الاسم', 'التليفون', 'الإيميل', 'الخدمة',
  'نوع الحمام', 'المقاس', 'السعر', 'المنطقة', 'الرسالة',
  'اللغة', 'الحالة', 'ملاحظات', 'التاريخ',
]);

while ($l = $s->fetch()) {
  fputcsv($out, [
    $l['id'],
    LEAD_KIND[$l['kind']] ?? $l['kind'],
    $l['name'],
    // A leading tab keeps Excel from eating the leading zero of a phone number.
    "\t" . $l['phone'],
    $l['email'],
    $l['service'],
    $l['pool_type'],
    $l['pool_size'],
    $l['amount'],
    $l['city'],
    $l['message'],
    $l['lang'],
    LEAD_STATUS[$l['status']] ?? $l['status'],
    $l['note'],
    $l['created_at'],
  ]);
}
fclose($out);
