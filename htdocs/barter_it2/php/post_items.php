<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$item_name = $_POST['item_name'];
$item_desc = $_POST['item_desc'];
$item_price = $_POST['item_price'];
$item_qty = $_POST['item_qty'];
$item_type = $_POST['item_type'];
$item_lat = $_POST['item_lat'];
$item_long = $_POST['item_long'];
$item_state = $_POST['item_state'];
$item_locality = $_POST['item_locality'];
$image = $_POST['image'];

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,`item_name`, `item_desc`, `item_type`, `item_price`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$user_id','$item_name','$item_desc','$item_type','$item_price','$item_qty','$item_lat','$item_long','$item_state','$item_locality')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($image);
	$path = '../assets/items/'.$filename.'.png';
	file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>