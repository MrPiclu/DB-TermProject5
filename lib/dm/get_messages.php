<?php
$host = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_x";

$conn = new mysqli($host, $username, $password, $dbname);

// GET 요청 처리
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $receiver_id = $_GET['receiver_id'];  // 수신자 ID

    // direct_messages 테이블에서 데이터 조회
    $sql = "SELECT sender_id, content, created_at, is_read FROM direct_messages WHERE receiver_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $receiver_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $messages = [];
    while ($row = $result->fetch_assoc()) {
        $messages[] = $row;
    }

    echo json_encode($messages);
}
?>
