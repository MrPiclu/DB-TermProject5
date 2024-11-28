<?php
session_start(); // 세션 시작
try {
    // 데이터베이스 연결 설정
    $pdo = new PDO("mysql:host=localhost;dbname=bookmarks_db;charset=utf8", "root", "your_password");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
?>
