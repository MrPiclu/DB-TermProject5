<?php
include '../connection.php';

$userUid = $_POST['user_uid'];

$sqlQuery = "SELECT tweets.* FROM tweets 
                        LEFT JOIN likes ON tweets.id = likes.tweet_id WHERE likes.user_uid = '$userUid'";


$resultQuery = $connection -> query($sqlQuery);

if($resultQuery -> num_rows > 0){
    $tweetRecord = array();
    while($rowFound = $resultQuery -> fetch_assoc()){ #Assoc은 연관 배열을 가져옴
        $tweetRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "allFavTweets" => $tweetRecord
            )
        );
}else{
    echo json_encode(array("success" => false));
}
?>
