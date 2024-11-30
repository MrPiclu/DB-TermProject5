<?php
session_start(); // 세션 시작

// CORS 설정: 다른 출처의 요청 허용 (플러터 앱과 연동)
header('Access-Control-Allow-Origin: *'); // 실제 앱 배포 시에는 * 대신 특정 도메인을 명시하세요.
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-CSRF-Token');

// OPTIONS 요청 처리 (CORS 사전 요청 대응)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

try {
    // 데이터베이스 연결 설정
    $dsn = "mysql:host=localhost;dbname=bookmarks_db;charset=utf8";
    $username = "root"; // 실제 데이터베이스 사용자명으로 변경
    $password = "your_password"; // 실제 비밀번호로 변경

    $pdo = new PDO($dsn, $username, $password);

    // PDO 에러 모드를 예외 모드로 설정
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // PDO 페치 모드 기본 설정
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    // 데이터베이스 연결 실패 시 JSON 에러 응답
    http_response_code(500);
    echo json_encode(["error" => "Database connection failed: " . $e->getMessage()]);
    exit;
}
?>
