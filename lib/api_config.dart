// EMULATOR:  http://10.0.2.2

// ONLINE:  https://daawatokug.000webhostapp.com/

// OFFLINE:  http://192.168.232.21

class ApiConfig {
  static const String baseUrl =
      'https://daawatokug.000webhostapp.com'; // Replace IP address

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
  static const String fetchChannelsUrl =
      '$baseUrl/daawatokug/channels/fetch_channels.php';
  static const String fetchUsersForApprovelUrl =
      '$baseUrl/daawatokug/channels/fetch_users.php';
  static const String approveUserUrl =
      '$baseUrl/daawatokug/channels/approve_user.php';
  static const String fetchApprovedChannelsUrl =
      '$baseUrl/daawatokug/channels/fetch_approved_channels.php';
  static const String unapproveUserUrl =
      '$baseUrl/daawatokug/channels/unapprove_channel.php';
  static const String approveAdminUrl =
      '$baseUrl/daawatokug/channels/approve_admin.php';
  static const String fetchApprovedAdminsUrl =
      '$baseUrl/daawatokug/channels/fetch_approved_admins.php';
  static const String fetchfollowedUrl =
      '$baseUrl/daawatokug/channels/fetch_followed.php';
  static const String fetchUnfollowedUrl =
      '$baseUrl/daawatokug/channels/fetch_unfollowed.php';
  static const String followChannelUrl =
      '$baseUrl/daawatokug/channels/follow_channel.php';
  static const String unfollowChannelUrl =
      '$baseUrl/daawatokug/channels/unfollow_channel.php';
  static const String fetchFollowingUrl =
      '$baseUrl/daawatokug/channels/fetch_following_count.php';
  static const String fetchFollowerUrl =
      '$baseUrl/daawatokug/channels/fetch_follower_count.php';
  static const String fetchAccountLikesUrl =
      '$baseUrl/daawatokug/channels/fetch_account_likes_count.php';
  static const String fetchAccountFollowersUrl =
      '$baseUrl/daawatokug/channels/fetch_account_followers.php';
  static String fetchPaymentDetailsUrl =
      '$baseUrl/daawatokug/channels/fetch_payment_details.php';
  static String fetchPaymentInfomationUrl =
      '$baseUrl/daawatokug/channels/fetch_payment_information.php';
  static String updatePaymentDetailsUrl =
      '$baseUrl/daawatokug/channels/update_payment_details.php';
  static String fetchChannelsforDonationUrl =
      '$baseUrl/daawatokug/channels/fetch_donate_channels.php';
  static const String fetchAllUsersUrl =
      '$baseUrl/daawatokug/chats/fetch_all_users.php';
  static String getConversationsUrl =
      '$baseUrl/daawatokug/chats/fetch_conversations.php';
  static String getMessagesUrl = '$baseUrl/daawatokug/chats/fetch_messages.php';
  static String sendMessageUrl = '$baseUrl/daawatokug/chats/send_message.php';
  static String deleteMessageUrl =
      '$baseUrl/daawatokug/chats/delete_message.php';
}
