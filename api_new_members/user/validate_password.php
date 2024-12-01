<?php
include '../connection.php';

$userUid = $_POST['user_uid'];
$userPassword = md5($_POST['user_password']);

$sqlQuery = "SELECT * FROM users WHERE user_password = '$userPassword' AND user_uid = $userUid";

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery -> num_rows > 0){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>