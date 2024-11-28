<?php
session_start();
require 'db_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userId = $_SESSION['user_id'] ?? null; // 세션에서 사용자 ID 가져오기
    $title = $_POST['title'] ?? '';
    $url = $_POST['url'] ?? '';

    if (!$userId) {
        echo "You must log in to save bookmarks.";
        exit;
    }

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
