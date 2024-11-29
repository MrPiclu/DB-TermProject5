class API{
  static const hostConnect = "http://192.168.0.20/api_new_members";
  static const hostConnectUser = "$hostConnect/user";

  static const validateEmail = "$hostConnect/user/validate_email.php";
  static const signup = "$hostConnect/user/signup.php";
  static const login = "$hostConnect/user/login.php";

  static const getUserInfo = "$hostConnect/user/get_user_info.php";
  static const getFollowInfo = "$hostConnect/user/get_follow_info.php";

  static const uploadTweet = "$hostConnect/user/upload_tweet.php";
  static const downloadTweets = "$hostConnect/user/download_tweet.php";
  static const downloadTweetMedia = "$hostConnect/user/download_tweet_media.php";
  static const getFollowingUsers = "$hostConnect/user/get_following_users.php";

  static const follow = "$hostConnect/user/follow.php";
  static const unFollow = "$hostConnect/user/unfollow.php";

  static const favTweet = "$hostConnect/user/fav_tweet.php";
  static const updateFavTweet = "$hostConnect/user/update_fav_tweet.php";
  static const downloadFavTweet = "$hostConnect/user/download_fav_tweet.php";

}