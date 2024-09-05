<?php
// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

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

// Retrieve and sanitize input
$userEmail = $_POST['user_email'];
$userPassword = md5($_POST['user_password']); 

// Prepare the SQL statement
$stmt = $connectNow->prepare("SELECT * FROM users_table WHERE user_email = ? AND user_password = ?");
if ($stmt === false) {
    echo json_encode(array("success" => false, "error" => "Prepare failed: " . $connectNow->error));
    exit();
}

// Bind parameters and execute the statement
$stmt->bind_param("ss", $userEmail, $userPassword);
$stmt->execute();

// Store the result
$stmt->store_result();

// Check if any rows match the query
if ($stmt->num_rows > 0) {
    // Fetch the result as an associative array
    $stmt->bind_result($id, $name, $email, $password); 
    $stmt->fetch();
    
    // Construct user data array
    $userRecode = array(
        "user_id" => $id,
        "user_name" => $name,
        "user_email" => $email,
        "user_password" =>  $password
    );
    
    echo json_encode(
        array(
            "success" => true,
            "userData" => $userRecode
        )
    );
} else {
    echo json_encode(array("success" => false, "error" => "Invalid email or password"));
}

// Close statement and connection
$stmt->close();
$connectNow->close();
?>
