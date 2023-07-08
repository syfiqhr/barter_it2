<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 10;
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

if (isset($_POST['user_id'])){
	$userid = $_POST['user_id'];	
	$sqlloadcatches = "SELECT * FROM `tbl_items` WHERE user_id = '$user_id'";
	//$sqlcart = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
}else if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloadcatches = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%'";
	//$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$cartuserid'";
}else{
	$sqlloadcatches = "SELECT * FROM `tbl_items`";
	//$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$cartuserid'";
}

if (isset($sqlcart)){
	$resultcart = $conn->query($sqlcart);
	$number_of_result_cart = $resultcart->num_rows;
	if ($number_of_result_cart > 0) {
		$totalcart = 0;
		while ($rowcart = $resultcart->fetch_assoc()) {
			$totalcart = $totalcart+ $rowcart['item_qty'];
		}
	}else{
		$totalcart = 0;
	}
}else{
	$totalcart = 0;
}
$result = $conn->query($sqlloadcatches);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadcatches = $sqlloadcatches . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadcatches);


if ($result->num_rows > 0) {
    $catches["catches"] = array();
	while ($row = $result->fetch_assoc()) {
        $catchlist = array();
        $catchlist['item_id'] = $row['item_id'];
        $catchlist['user_id'] = $row['user_id'];
        $catchlist['item_name'] = $row['item_name'];
        $catchlist['item_type'] = $row['item_type'];
        $catchlist['item_desc'] = $row['item_desc'];
        $catchlist['item_price'] = $row['item_price'];
        $catchlist['item_qty'] = $row['item_qty'];
        $catchlist['item_lat'] = $row['item_lat'];
        $catchlist['item_long'] = $row['item_long'];
        $catchlist['item_state'] = $row['item_state'];
        $catchlist['item_locality'] = $row['item_locality'];
        array_push($catches["catches"],$catchlist);
    }
    $response = array('status' => 'success', 'data' => $catches, 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result", 'item_qty'=> $totalcart);
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