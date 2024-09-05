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

$userName = $_POST['user_name'];
$userEmail = $_POST['user_email'];
$userPassword = md5($_POST['user_password']);

// Prepare the SQL statement
$stmt = $connectNow->prepare("INSERT INTO users_table (user_name, user_email, user_password) VALUES (?, ?, ?)");
if ($stmt === false) {
    echo json_encode(array("success" => false, "error" => "Prepare failed: " . $connectNow->error));
    exit();
}

$stmt->bind_param("sss", $userName, $userEmail, $userPassword);

// Execute the statement
if ($stmt->execute()) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false, "error" => $stmt->error));
}

// Close statement and connection
$stmt->close();
$connectNow->close();
?>
