<?php
include '../connection.php';

$userId = $_POST['user_id'];
$userName = $_POST['user_name'];
$profileImageUrl = $_POST['profile_image_url'];
$userEmail = $_POST['user_email'];
$userPassword = md5($_POST['user_password']);

$sqlQuery = "INSERT INTO users 
                SET user_id = '$userId',
                    user_name = '$userName', 
                    profile_image_url = '$profileImageUrl', 
                    user_email = '$userEmail',
                    user_password = '$userPassword'";

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>
