<?php
include '../connection.php';

$userEmail = $_POST['user_email'];
$userPassword = md5($_POST['user_password']);

$sqlQuery = "SELECT * FROM users 
                WHERE user_email = '$userEmail' AND
                    user_password = '$userPassword'";

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery -> num_rows > 0){

    $userRecord = array();
    while($rowFound = $resultQuery -> fetch_assoc()){ #Assoc은 연관 배열을 가져옴
        $userRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "userData" => $userRecord[0], 
            )
        );
}else{
    echo json_encode(array("success" => false));
}
?>
