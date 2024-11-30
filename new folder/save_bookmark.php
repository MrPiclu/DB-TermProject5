<?php
session_start();
require 'db_connection.php';

// CORS 설정
header('Access-Control-Allow-Origin: *'); // 실제 배포 시 특정 도메인으로 제한
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-CSRF-Token');

// OPTIONS 요청 처리 (CORS 사전 요청 대응)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// 로그인 상태 확인
if (!isset($_SESSION['user_id'])) {
    http_response_code(401); // 인증 실패
    header('Content-Type: application/json');
    echo json_encode(['error' => 'You must log in to save bookmarks.']);
    exit;
}

// CSRF 토큰 확인
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        http_response_code(403); // 금지됨
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Invalid CSRF token.']);
        exit;
    }

    // 사용자 입력 가져오기
    $userId = $_SESSION['user_id'];
    $title = trim($_POST['title'] ?? '');
    $url = trim($_POST['url'] ?? '');

    // 입력값 검증
    if (empty($title) || empty($url)) {
        http_response_code(400); // 잘못된 요청
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Both title and URL are required.']);
        exit;
    }

    // 제목 길이 제한
    if (strlen($title) > 100) {
        http_response_code(400);
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Title cannot be longer than 100 characters.']);
        exit;
    }

    // URL 형식 검증
    if (!filter_var($url, FILTER_VALIDATE_URL)) {
        http_response_code(400);
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Invalid URL format.']);
        exit;
    }

    // URL과 제목을 안전하게 처리
    $safeTitle = htmlspecialchars($title, ENT_QUOTES, 'UTF-8');
    $safeUrl = htmlspecialchars($url, ENT_QUOTES, 'UTF-8');

    // 북마크 저장 쿼리
    $query = "INSERT INTO bookmarks (user_id, bookmark_title, bookmark_url) VALUES (:user_id, :title, :url)";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
    $stmt->bindParam(':title', $safeTitle, PDO::PARAM_STR);
    $stmt->bindParam(':url', $safeUrl, PDO::PARAM_STR);

    try {
        // 실행 후 성공 여부 확인
        if ($stmt->execute()) {
            http_response_code(201); // 생성됨
            header('Content-Type: application/json');
            echo json_encode(['success' => 'Bookmark saved successfully.']);
        } else {
            http_response_code(500); // 서버 오류
            header('Content-Type: application/json');
            echo json_encode(['error' => 'Failed to save bookmark.']);
        }
    } catch (PDOException $e) {
        // 데이터베이스 오류 처리
        http_response_code(500); // 서버 오류
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    // POST 이외의 메서드에 대한 응답
    http_response_code(405); // 허용되지 않은 메서드
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Invalid request method.']);
}
