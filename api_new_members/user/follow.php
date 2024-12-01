<?php
include '../connection.php';

$followedUserUid = $_POST['followed_user_uid'];
$followingUserUid = $_POST['following_user_uid'];

// 트윗 삽입
$sqlQuery = "INSERT INTO follows 
                        SET followed_user_uid = '$followedUserUid',
                            following_user_uid = '$followingUserUid'";


$resultQuery = $connection -> query($sqlQuery);

if($resultQuery){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>
