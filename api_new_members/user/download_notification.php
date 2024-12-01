<?php
include '../connection.php';

$userUid = $_POST['user_uid'];

$insertMediaQuery = "SELECT notifications.*, users.user_name FROM notifications
                        LEFT JOIN users ON notifications.initiator_id = users.user_uid WHERE notifications.user_uid = '$userUid'";

$resultQuery = $connection -> query($insertMediaQuery);

if($resultQuery -> num_rows > 0){

    $notiRecord = array();
    while($rowFound = $resultQuery -> fetch_assoc()){ #Assoc은 연관 배열을 가져옴
        $notiRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "notifications" => $notiRecord
            )
        );
}else{
    echo json_encode(array("success" => false));
}
?>