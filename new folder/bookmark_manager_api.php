<?php
session_start();
header("Content-Type: application/json");

// 데이터베이스 연결
require 'db_connection.php';

// CSRF 토큰 검증
function validateCsrfToken($token) {
    return isset($_SESSION['csrf_token']) && $token === $_SESSION['csrf_token'];
}

// HTTP 메서드에 따른 작업 분기
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    // GET 요청: 북마크 목록 가져오기
    try {
        $stmt = $pdo->query("SELECT title, url FROM bookmarks");
        $bookmarks = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($bookmarks);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(["success" => false, "error" => "Failed to fetch bookmarks"]);
    }
} elseif ($method === 'POST') {
    // POST 요청: 새 북마크 저장
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['csrf_token'], $data['title'], $data['url'])) {
        http_response_code(400);
        echo json_encode(["success" => false, "error" => "Invalid input data"]);
        exit;
    }

    if (!validateCsrfToken($data['csrf_token'])) {
        http_response_code(403);
        echo json_encode(["success" => false, "error" => "Invalid CSRF token"]);
        exit;
    }

    $title = trim($data['title']);
    $url = trim($data['url']);

    if (empty($title) || empty($url)) {
        http_response_code(400);
        echo json_encode(["success" => false, "error" => "Title and URL are required"]);
        exit;
    }

    try {
        $stmt = $pdo->prepare("INSERT INTO bookmarks (title, url) VALUES (?, ?)");
        if ($stmt->execute([$title, $url])) {
            echo json_encode(["success" => true, "message" => "Bookmark saved successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["success" => false, "error" => "Failed to save bookmark"]);
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(["success" => false, "error" => "An error occurred"]);
    }
} else {
    // 지원하지 않는 메서드
    http_response_code(405);
    echo json_encode(["success" => false, "error" => "Method not allowed"]);
}
