<?php
session_start(); // 세션 시작

// 세션 설정 강화 (보안 강화)
ini_set('session.cookie_secure', '1'); // HTTPS에서만 쿠키 전송
ini_set('session.cookie_httponly', '1'); // JavaScript에서 쿠키 접근 금지
ini_set('session.use_strict_mode', '1'); // 세션 ID 강제 사용 모드
ini_set('session.cookie_samesite', 'Strict'); // CSRF 방지용 SameSite 속성 설정

// CSRF 토큰 생성 (세션에 저장)
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32)); // 안전한 랜덤 값 생성
}

// CORS 헤더 설정 (플러터 앱에서의 요청 허용)
$allowedOrigins = ['http://localhost:3000', 'https://example.com']; // 허용된 도메인
if (isset($_SERVER['HTTP_ORIGIN']) && in_array($_SERVER['HTTP_ORIGIN'], $allowedOrigins)) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
} else {
    header('Access-Control-Allow-Origin: https://example.com'); // 기본 허용 도메인
}
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-CSRF-Token');
header('Access-Control-Allow-Credentials: true'); // 인증 정보 포함

// OPTIONS 요청 처리 (CORS 사전 요청 대응)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// 디버깅용 로그 (선택 사항 - 실제 배포 시 제거)
error_log("Session initialized. CSRF Token: {$_SESSION['csrf_token']}");
?>
