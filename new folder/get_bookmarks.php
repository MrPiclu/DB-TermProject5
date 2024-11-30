<?php
session_start();
require 'db_connection.php'; // DB 연결 파일 포함

// CORS 설정: 플러터 앱에서의 요청 허용
header('Access-Control-Allow-Origin: *'); // 배포 환경에서는 특정 도메인으로 변경
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

// CSRF 토큰 검증
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $csrfTokenHeader = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
    if (empty($csrfTokenHeader) || $csrfTokenHeader !== $_SESSION['csrf_token']) {
        http_response_code(403); // 금지됨
        echo json_encode(["error" => "Invalid CSRF token."]);
        exit;
    }
}

$userId = $_SESSION['user_id']; // 세션에서 사용자 ID 가져오기

// 데이터베이스에서 북마크 가져오기
$query = "SELECT bookmark_title, bookmark_url FROM bookmarks WHERE user_id = :user_id";
$stmt = $pdo->prepare($query);
$stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);

try {
    $stmt->execute();
    $bookmarks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    header('Content-Type: application/json');
    if (empty($bookmarks)) {
        http_response_code(204); // 콘텐츠 없음
        echo json_encode(["message" => "No bookmarks found."]);
    } else {
        echo json_encode($bookmarks);
    }
} catch (PDOException $e) {
    http_response_code(500); // 서버 오류

    // 개발 환경에서는 상세 에러 메시지를, 배포 환경에서는 일반 메시지를 반환
    $isDevelopment = getenv('APP_ENV') === 'development';
    $errorMessage = $isDevelopment
        ? "Database error: " . $e->getMessage()
        : "An error occurred while retrieving bookmarks. Please try again later.";

    echo json_encode(["error" => $errorMessage]);
    exit;
}
?>
