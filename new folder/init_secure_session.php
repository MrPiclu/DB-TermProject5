<?php
session_start(); // 세션 시작

// CSRF 토큰 생성 (세션에 저장)
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32)); // 안전한 랜덤 값 생성
}

// CORS 헤더 설정 (플러터 앱에서의 요청 허용)
header('Access-Control-Allow-Origin: *'); // 실제 배포 시 특정 도메인으로 제한
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-CSRF-Token');

// OPTIONS 요청 처리 (CORS 사전 요청 대응)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
?>
