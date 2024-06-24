// EMULATOR:  http://10.0.2.2

// ONLINE:  https://daawatoktokugug.000webhostapp.com

// OFFLINE:  http://192.168.232.21

class ApiConfig {
  static const String baseUrl =
      'https://daawatoktokugug.000webhostapp.com'; // Replace IP address

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
      '$baseUrl/daawatokug/auth/updateprofile.php';
  static const String updateUserProfilePicUrl =
      '$baseUrl/daawatokug/profilePics/profilepic.php';
  static const String deleteUserProfilePicUrl =
      '$baseUrl/daawatokug/profilePics/deletepic.php';
  static const String emptyProfilePicUrl = '$baseUrl/daawatokug/profilePics/';
  static const String fetchVideosUrl = '$baseUrl/daawatokug/fetchvideos.php';
  static const String likeVideoUrl = '$baseUrl/daawatokug/like_video.php';
  static const String checkLikesUrl = '$baseUrl/daawatokug/likes_check.php';
  static const String deletelikeUrl = '$baseUrl/daawatokug/like_delete.php';
  static const String favoriteVideoUrl =
      '$baseUrl/daawatokug/favorite_video.php';
  static const String checkFavoritesUrl =
      '$baseUrl/daawatokug/favorites_check.php';
  static const String deleteFavoriteUrl =
      '$baseUrl/daawatokug/favorite_delete.php';
  static const String sendCommentUrl = "$baseUrl/daawatokug/comment_video.php";
  static String fetchCommentsUrl(String videoid) =>
      '$baseUrl/daawatokug/comments_fetch.php?videoid=$videoid';
  static const String deleteCommentUrl =
      '$baseUrl/daawatokug/comment_delete.php';
  static const String uploadVideoUrl = '$baseUrl/daawatokug/post_video.php';
  static const String fetchUserUploadedVideosUrl =
      '$baseUrl/daawatokug/user_videos.php';
}
