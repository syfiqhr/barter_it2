<?php
if (!isset($_GET)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

if (isset($_GET['image'])) {
    $image = $_GET['image'];
    $userId = $_GET['user_id'];
    
    $decoded_string = base64_decode($image);
	$path = '../assets/profileimages/'.$userId.'.png';
	file_put_contents($path, $decoded_string);
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
    // $decoded_string = base64_decode($encoded_string);
    // $path = '../assets/profileimages/' . $userid . '.png';
    // if (file_put_contents($path, $decoded_string)){
    //     $response = array('status' => 'success', 'data' => null);
    //     sendJsonResponse($response);
    // }else{
    //     $response = array('status' => 'failed', 'data' => null);
    //     sendJsonResponse($response);
    // }
    die();
}

if (isset($_GET['newphone'])) {
    $phone = $_GET['newphone'];
    $userId = $_GET['user_id'];
    $sqlupdate = "UPDATE tbl_users SET user_phone ='$phone' WHERE user_id = '$userId'";
    databaseUpdate($sqlupdate);
    die();
}

if (isset($_GET['oldpass'])) {
    $oldpass = sha1($_POST['oldpass']);
    $newpass = sha1($_POST['newpass']);
    $userId = $_POST['user_id'];
    include_once("dbconnect.php");
    $sqllogin = "SELECT * FROM tbl_users WHERE user_id = '$userId' AND user_password = '$oldpass'";
    $result = $conn->query($sqllogin);
    if ($result->num_rows > 0) {
    	$sqlupdate = "UPDATE tbl_users SET user_password ='$newpass' WHERE user_id = '$userId'";
            if ($conn->query($sqlupdate) === TRUE) {
                $response = array('status' => 'success', 'data' => null);
                sendJsonResponse($response);
            } else {
                $response = array('status' => 'failed', 'data' => null);
                sendJsonResponse($response);
            }
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

if (isset($_GET['newname'])) {
    $name = $_GET['newname'];
    $userId = $_GET['user_id'];
    $sqlupdate = "UPDATE tbl_users SET user_name ='$name' WHERE user_id = '$userId'";
    databaseUpdate($sqlupdate);
    die();
}

// if (isset($_POST['selecttoken'])) {
//     $token = $_POST['selecttoken'];
//     $userid = $_POST['userid'];
//     $sqlupdate = "UPDATE tbl_users SET user_token =('$token'+ user_token) WHERE user_id = '$userid'"; //need to add (usertoken + token)
//     databaseUpdate($sqlupdate);
//     die();
// }

function databaseUpdate($sql){
    include_once("dbconnect.php");
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>