<?php
session_start(); // 세션 시작

// CORS 설정: 다른 출처의 요청 허용 (플러터 앱과 연동)
header('Access-Control-Allow-Origin: *'); // 배포 환경에서는 특정 도메인으로 변경
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-CSRF-Token');

// OPTIONS 요청 처리 (CORS 사전 요청 대응)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

try {
    // 환경 변수에서 데이터베이스 연결 정보 가져오기
    $dsn = getenv('DB_DSN') ?: "mysql:host=localhost;dbname=bookmarks_db;charset=utf8";
    $username = getenv('DB_USERNAME') ?: "root"; // 환경 변수에서 DB 사용자 이름 가져오기
    $password = getenv('DB_PASSWORD') ?: "your_password"; // 환경 변수에서 DB 비밀번호 가져오기

    // PDO 객체 생성
    $pdo = new PDO($dsn, $username, $password);

    // PDO 에러 모드를 예외 모드로 설정
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // PDO 페치 모드 기본 설정
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    // 성공적으로 연결된 경우 JSON 응답 반환 (테스트용)
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        echo json_encode(["success" => true, "message" => "Database connected successfully"]);
    }
} catch (PDOException $e) {
    // 데이터베이스 연결 실패 시 JSON 에러 응답
    http_response_code(500);

    // 개발 환경에 따라 에러 메시지 분리
    $isDevelopment = getenv('APP_ENV') === 'development';
    $errorMessage = $isDevelopment
        ? "Database connection failed: " . $e->getMessage()
        : "Database connection failed. Please contact the administrator.";

    echo json_encode(["error" => $errorMessage]);
    exit;
}
?>
