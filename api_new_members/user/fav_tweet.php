<?php
include '../connection.php';

$userId = $_POST['user_uid'];
$tweetId = $_POST['id'];
$isFav = $_POST['isFav'];

if($isFav == 'true'){
    // 트윗 삽입
    $sqlQuery = "UPDATE tweets 
                            SET fav_count = fav_count + 1
                            WHERE id = '$tweetId'";
}else{
    // 트윗 삽입
    $sqlQuery = "UPDATE tweets 
                            SET fav_count = fav_count - 1
                            WHERE id = '$tweetId'";
}


$resultQuery = $connection -> query($sqlQuery);

if($resultQuery){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>
