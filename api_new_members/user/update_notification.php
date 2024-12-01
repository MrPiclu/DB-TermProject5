<?php
include '../connection.php';

$initiatorId = $_POST['initiator_id']; // 알림 보낸 사람
$userUid = $_POST['user_uid']; // 알림 받은 사람
$tweetId = $_POST['tweet_id'] ?? null; //트윗 관련 (like, comment) 아닐 경우 null 가능
$type = $_POST['type']; // 알림 타입

$sqlQuery = "INSERT INTO notifications
                SET tweet_id = '$tweetId',
                    user_uid = '$userUid',
                    initiator_id = '$initiatorId',
                    type = '$type'"; //'follow','mention','like','retweet','comment'

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>
