<?php
include '../connection.php';

$tweetId = $_POST['tweet_id'];
$userUid = $_POST['user_uid'];

$sqlQuery = "SELECT * FROM likes
                WHERE tweet_id = '$tweetId'";
      
$resultQuery = $connection -> query($sqlQuery);

$sqlQuery1 = "SELECT * FROM likes
                WHERE tweet_id = '$tweetId' AND
                        user_uid = '$userUid'";
      
$resultQuery1 = $connection -> query($sqlQuery1);


if($resultQuery -> num_rows > 0){
    $followRecord = array();
    while($rowFound = $resultQuery -> fetch_assoc()){ #Assoc은 연관 배열을 가져옴
        $followRecord[] = $rowFound;
    }
    if($resultQuery1 -> num_rows > 0){
        echo json_encode(
            array(
                "success" => true,
                "users" => $followRecord,
                "isFavorited" => true,
                )
            );
    }else{
        echo json_encode(
            array(
                "success" => true,
                "users" => $followRecord,
                "isFavorited" => false,
                )
            );
    }
}else{
    echo json_encode(array("success" => false));
}
?>

