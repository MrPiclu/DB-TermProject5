<?php
session_start();
require 'db_connection.php';

$userId = $_SESSION['user_id'] ?? null;

if (!$userId) {
    echo "You must log in to view bookmarks.";
    exit;
}

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
