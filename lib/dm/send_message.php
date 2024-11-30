<?php
$host = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_x";

$conn = new mysqli($host, $username, $password, $dbname);

// POST 요청 처리
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $sender_id = $_POST['sender_id'];       // 발신자 ID
    $receiver_id = $_POST['receiver_id'];   // 수신자 ID
    $content = $_POST['content'];           // 메시지 내용

    // direct_messages 테이블에 데이터 삽입
    $sql = "INSERT INTO direct_messages (sender_id, receiver_id, content) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("iis", $sender_id, $receiver_id, $content);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "error" => $stmt->error]);
    }
}
?>
