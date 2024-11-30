<?php
session_start();
require 'db_connection.php';

// CORS 설정: 플러터 앱에서의 요청 허용
header('Access-Control-Allow-Origin: *'); // 실제 배포 시에는 * 대신 특정 도메인으로 제한
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-CSRF-Token');

// OPTIONS 요청 처리 (CORS 사전 요청 대응)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// 로그인 상태 확인
if (!isset($_SESSION['user_id'])) {
    http_response_code(401); // 인증되지 않음
    echo json_encode(["error" => "You must log in to view bookmarks."]);
    exit;
}

$userId = $_SESSION['user_id'];

$query = "SELECT bookmark_title, bookmark_url FROM bookmarks WHERE user_id = :user_id";
$stmt = $pdo->prepare($query);
$stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);

try {
    $stmt->execute();
    $bookmarks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    header('Content-Type: application/json');
    if (empty($bookmarks)) {
        echo json_encode(["message" => "No bookmarks found."]);
    } else {
        echo json_encode($bookmarks);
    }
} catch (PDOException $e) {
    http_response_code(500); // 서버 오류
    echo json_encode(["error" => "Database error: " . $e->getMessage()]);
}
?>
