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

// Get the email from POST data
$userEmail = $_POST['user_email'];

// Sanitize the email input
$userEmail = $connectNow->real_escape_string($userEmail);

// Prepare and execute the SQL query
$sqlQuery = "SELECT * FROM users_table WHERE user_email='$userEmail'";
$resultOfQuery = $connectNow->query($sqlQuery);

// Check if there are any rows returned
if ($resultOfQuery->num_rows > 0) {
    // Email found
    echo json_encode(array("emailFound" => true));
} else {
    // Email not found
    echo json_encode(array("emailFound" => false));
}

// Close connection
$connectNow->close();
?>
