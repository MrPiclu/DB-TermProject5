<?php
include '../connection.php';


$body = $_POST['body'];
$userUid = $_POST['user_uid'];
$mediaType = $_POST['media_type'] ?? null; // 미디어 타입
$mediaUrl = $_POST['media_url'] ?? null; // 미디어 URL


// 트윗 삽입
$insertTweetQuery = "INSERT INTO tweets 
                        SET body = '$body',
                            user_uid = '$userUid'";

$resultQuery = $connection -> query($insertTweetQuery);

// 방금 삽입된 트윗 ID 가져오기
$tweetId = $connection -> insert_id;

if($mediaUrl != 'null'){
    $insertMediaQuery = "INSERT INTO medias 
                            SET tweet_id = '$tweetId',
                                media_type = '$mediaType',
                                media_url = '$mediaUrl'";
    
    $resultQuery = $connection -> query($insertMediaQuery);
}

if($resultQuery){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>