class ApiConnection {
  static const hostConnect = 'http://<replace your ipv4 address>/api_clothes_store';
  static const hostConnectUser = '$hostConnect/user';

  // sign up user
  static const validateEmail = '$hostConnect/user/validate_email.php';
  static const signUp = '$hostConnect/user/signup.php';

  // log in user
  static const logIn = '$hostConnect/user/login.php';
}
