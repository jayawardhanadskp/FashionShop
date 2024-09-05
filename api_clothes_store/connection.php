<?php
// Database connection
$serverHost = "localhost";
$user = "root";
$password = "";
$database = "cloths_app_db";

$connectNow = new mysqli($serverHost, $user, $password, $database);

// Check connection
if ($connectNow->connect_error) {
    echo json_encode(array("success" => false, "error" => "Connection failed: " . $connectNow->connect_error));
    exit();
}
?>
