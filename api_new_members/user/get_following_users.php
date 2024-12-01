<?php
include '../connection.php';

$followedUserUid = $_POST['followed_user_uid'];
$type = $_POST['type'];

if($type == 'followed'){
    $sqlQuery = "SELECT * FROM follows 
                    WHERE following_user_uid = '$followedUserUid'";
}else{
    $sqlQuery = "SELECT * FROM follows 
                    WHERE followed_user_uid = '$followedUserUid'";
}


$resultQuery = $connection -> query($sqlQuery);

if($resultQuery -> num_rows > 0){
    $followRecord = array();
    while($rowFound = $resultQuery -> fetch_assoc()){ #Assoc은 연관 배열을 가져옴
        $followRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "users" => $followRecord
            )
        );
}else{
    echo json_encode(array("success" => false));
}
?>
