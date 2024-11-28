<?php
session_start();
require 'db_connection.php';

// 로그인 상태 확인
if (!isset($_SESSION['user_id'])) {
    die("You must log in to save bookmarks.");
}

// CSRF 토큰 확인
if ($_POST['csrf_token'] !== $_SESSION['csrf_token']) {
    die("Invalid CSRF token.");
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userId = $_SESSION['user_id']; 
    $title = $_POST['title'] ?? '';
    $url = $_POST['url'] ?? '';

    // 입력값 검증
    if (empty($title) || empty($url)) {
        echo "Both title and URL are required.";
        exit;
    }

    if (!filter_var($url, FILTER_VALIDATE_URL)) {
        echo "Invalid URL format.";
        exit;
    }

    // 북마크 저장
    $query = "INSERT INTO bookmarks (user_id, bookmark_title, bookmark_url) VALUES (:user_id, :title, :url)";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
    $stmt->bindParam(':title', $title, PDO::PARAM_STR);
    $stmt->bindParam(':url', $url, PDO::PARAM_STR);

    try {
        if ($stmt->execute()) {
            echo "Bookmark saved successfully.";
        } else {
            echo "Failed to save bookmark.";
        }
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
} else {
    echo "Invalid request.";
}
?>
