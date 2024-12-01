<?php
include '../connection.php';

$tweetId = $_POST['tweet_id'];

$insertMediaQuery = "SELECT media_url FROM medias 
                        WHERE tweet_id = '$tweetId'";

$resultQuery = $connection -> query($insertMediaQuery);

if($resultQuery -> num_rows > 0){

    $mediaRecord = array();
    while($rowFound = $resultQuery -> fetch_assoc()){ #Assoc은 연관 배열을 가져옴
        $mediaRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "medias" => $mediaRecord
            )
        );
}else{
    echo json_encode(array("success" => false));
}
?>