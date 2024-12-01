<?php
include '../connection.php';

$sqlQuery = "SELECT user_uid FROM users";

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery -> num_rows > 0){
    $userRecord = array();
    while($rowFound = $resultQuery -> fetch_assoc()){ #Assoc은 연관 배열을 가져옴
        $userRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "allUsers" => $userRecord
            )
        );
}else{
    echo json_encode(array("success" => false));
}
?>
