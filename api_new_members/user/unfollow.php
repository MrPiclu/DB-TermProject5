<?php
include '../connection.php';

$followedUserUid = $_POST['followed_user_uid'];
$followingUserUid = $_POST['following_user_uid'];

// 트윗 삽입
$sqlQuery = "DELETE FROM follows 
                        WHERE followed_user_uid = '$followedUserUid' AND
                            following_user_uid = '$followingUserUid'";

$resultQuery = $connection -> query($sqlQuery);


if($resultQuery && $connection->affected_rows > 0){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>
