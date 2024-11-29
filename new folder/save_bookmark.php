<?php
session_start();
require 'db_connection.php';

// 로그인 상태 확인
if (!isset($_SESSION['user_id'])) {
    header('Content-Type: application/json');
    echo json_encode(['error' => 'You must log in to save bookmarks.']);
    exit;
}

// CSRF 토큰 확인
if ($_POST['csrf_token'] !== $_SESSION['csrf_token']) {
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Invalid CSRF token.']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 사용자 입력 가져오기
    $userId = $_SESSION['user_id']; 
    $title = trim($_POST['title'] ?? '');
    $url = trim($_POST['url'] ?? '');

    // 입력값 검증
    if (empty($title) || empty($url)) {
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Both title and URL are required.']);
        exit;
    }

    // 제목 길이 제한 (예: 100자 이내)
    if (strlen($title) > 100) {
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Title cannot be longer than 100 characters.']);
        exit;
    }

    // URL 형식 검증
    if (!filter_var($url, FILTER_VALIDATE_URL)) {
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Invalid URL format.']);
        exit;
    }

    // URL 안전성 검사 (XSS, SQL 인젝션 방지)
    $url = htmlspecialchars($url, ENT_QUOTES, 'UTF-8');

    // 북마크 저장 쿼리
    $query = "INSERT INTO bookmarks (user_id, bookmark_title, bookmark_url) VALUES (:user_id, :title, :url)";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
    $stmt->bindParam(':title', $title, PDO::PARAM_STR);
    $stmt->bindParam(':url', $url, PDO::PARAM_STR);

    try {
        // 실행 후 성공 여부 확인
        if ($stmt->execute()) {
            header('Content-Type: application/json');
            echo json_encode(['success' => 'Bookmark saved successfully.']);
        } else {
            header('Content-Type: application/json');
            echo json_encode(['error' => 'Failed to save bookmark.']);
        }
    } catch (PDOException $e) {
        // 데이터베이스 오류 처리
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Invalid request method.']);
}
