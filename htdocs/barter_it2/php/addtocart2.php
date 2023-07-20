<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemId = $_POST['item_id'];
$itemQty = $_POST['item_qty'];
$cartQty = $_POST['cart_qty'];
$cartPrice = $_POST['cart_price'];
$userId = $_POST['user_id'];
$sellerId = $_POST['seller_id'];

$checkitemid = "SELECT * FROM `tbl_carts` WHERE `user_id` = '$userId' AND  `item_id` = '$itemId'";

$resultqty = $conn->query($checkitemid);
$numresult = $resultqty->num_rows;

if ($numresult > 0) {
	$sql = "UPDATE `tbl_carts` SET `cart_qty`= ('cart_qty' + '$cartQty'),`cart_price`= ('cart_price'+ '$cartPrice') WHERE `user_id` = '$userId' AND  `item_id` = '$itemId'";
}else{
	$sql = "INSERT INTO `tbl_carts`(`item_id`, `cart_qty`, `cart_price`, `user_id`, `seller_id`) VALUES ('$itemId','$cartQty','$cartPrice','$userId','$sellerId')";
}

if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => $sql);
		sendJsonResponse($response);
	}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>