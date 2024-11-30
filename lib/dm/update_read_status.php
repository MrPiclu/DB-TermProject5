<?php
// 데이터베이스 연결 설정
$host = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_x";

$conn = new mysqli($host, $username, $password, $dbname);

// POST 요청 처리
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $message_id = $_POST['message_id']; // 메시지 ID

    // direct_messages 테이블에서 해당 메시지의 읽음 상태를 업데이트
    $sql = "UPDATE direct_messages SET is_read = 1 WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $message_id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]); // 성공 응답
    } else {
        echo json_encode(["status" => "error", "error" => $stmt->error]); // 오류 응답
    }
}
?>
