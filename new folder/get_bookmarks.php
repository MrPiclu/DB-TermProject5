<?php
session_start();
require 'db_connection.php';

// 로그인 상태 확인
if (!isset($_SESSION['user_id'])) {
    echo "You must log in to view bookmarks.";
    exit;
}

$userId = $_SESSION['user_id'];

$query = "SELECT bookmark_title, bookmark_url FROM bookmarks WHERE user_id = :user_id";
$stmt = $pdo->prepare($query);
$stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);

try {
    $stmt->execute();
    $bookmarks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($bookmarks)) {
        echo "<p>No bookmarks found.</p>";
    } else {
        foreach ($bookmarks as $bookmark) {
            echo "<p><a href='" . htmlspecialchars($bookmark['bookmark_url']) . "' target='_blank'>" . htmlspecialchars($bookmark['bookmark_title']) . "</a></p>";
        }
    }
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>
