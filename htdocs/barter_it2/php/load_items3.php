<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 12;
if (isset($_POST['pageno'])){
	$pageno = (int)$_POST['pageno'];
}else{
	$pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;

if (isset($_POST['cartuserid'])){
	$cartuserid = $_POST['cartuserid'];
}else{
	$cartuserid = '0';
}



if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlloaditem = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
	$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$userid'";
}else if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloaditem = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%'";
	$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$cartuserid'";
}else{
	$sqlloaditem = "SELECT * FROM `tbl_items`";
	$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$cartuserid'";
}


if (isset($sqlcart)){
	$resultcart = $conn->query($sqlcart);
	$number_of_result_cart = $resultcart->num_rows;
	if ($number_of_result_cart > 0) {
		$totalcart = 0;
		while ($rowcart = $resultcart->fetch_assoc()) {
			$totalcart = $totalcart+ $rowcart['cart_qty'];
		}
	}else{
		$totalcart = 0;
	}
}else{
	$totalcart = 0;
}

$result = $conn->query($sqlloaditem);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloaditem = $sqlloaditem . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloaditem);


if ($result->num_rows > 0) {
    $catches["catches"] = array();
	while ($row = $result->fetch_assoc()) {
        $catchList = array();
        $catchList['item_id'] = $row['item_id'];
        $catchList['user_id'] = $row['user_id'];
        $catchList['item_name'] = $row['item_name'];
        $catchList['item_desc'] = $row['item_desc'];
		$catchList['item_price'] = $row['item_price'];
        $catchList['item_qty'] = $row['item_qty'];
        $catchList['item_lat'] = $row['item_lat'];
        $catchList['item_long'] = $row['item_long'];
        $catchList['item_state'] = $row['item_state'];
        $catchList['item_locality'] = $row['item_locality'];
		//$itemlist['item_date'] = $row['item_date'];
        array_push($catches["catches"],$catchList);
    }
    $response = array('status' => 'success', 'data' => $catches, 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'cart_qty'=> $totalcart);
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