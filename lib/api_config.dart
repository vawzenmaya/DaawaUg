// EMULATOR:  http://10.0.2.2

// ONLINE:  https://usaadz.000webhostapp.com

// OFFLINE:  http://192.168.232.21

class ApiConfig {
  static const String baseUrl =
      'https://daawaug.000webhostapp.com'; // Replace IP address

  // API endpoints
  static const String signinUrl = '$baseUrl/auth/signin.php';
  static const String signupWithEmailUrl =
      '$baseUrl/auth/signup_with_email.php';
  static const String signupWithPhoneUrl =
      '$baseUrl/auth/signup_with_phone.php';
  static const String checkUserUrl = '$baseUrl/auth/checkuser.php';
}
