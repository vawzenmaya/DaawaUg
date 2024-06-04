// EMULATOR:  http://10.0.2.2

// ONLINE:  https://daawaug.000webhostapp.com

// OFFLINE:  http://192.168.232.21

class ApiConfig {
  static const String baseUrl =
      'https://daawaug.000webhostapp.com'; // Replace IP address

  // API endpoints
  static const String signinUrl = '$baseUrl/daawatokug/auth/signin.php';
  static const String signupWithEmailUrl =
      '$baseUrl/daawatokug/auth/signup_with_email.php';
  static const String signupWithPhoneUrl =
      '$baseUrl/daawatokug/auth/signup_with_phone.php';
  static const String checkUserUrl = '$baseUrl/daawatokug/auth/checkuser.php';
  static const String resetPasswordWithPhoneUrl =
      '$baseUrl/daawatokug/auth/reset_password_with_phone.php';
  static String getUserDataUrl(String userid) =>
      '$baseUrl/daawatokug/auth/fetchUserData.php?userid=$userid';
  static const String updateUserProfileUrl =
      '$baseUrl/daawatokug/auth/updateUserProfile.php';
}
