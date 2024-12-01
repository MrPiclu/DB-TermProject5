<?php
include '../connection.php';

$userUid = $_POST['user_uid'];
$tweetId = $_POST['tweet_id'];
$isFav = $_POST['isFav'];

if($isFav == 'true'){

    $sqlQuery = "INSERT INTO likes
                    SET tweet_id = '$tweetId',
                        user_uid = '$userUid'";
                            
}else{

    $sqlQuery = "DELETE FROM likes 
                            WHERE tweet_id = '$tweetId' AND
                                    user_uid = '$userUid'";

}

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery){
    echo json_encode(array("success" => true));
}else{
    echo json_encode(array("success" => false));
}
?>
