<?php
include '../connection.php';

$userUid = $_POST['user_uid'];
$userPassword = md5($_POST['user_password']);

$sqlQuery = "UPDATE users SET user_password = '$userPassword' WHERE user_uid = '$userUid'";

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>