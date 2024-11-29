class FollowUser {
  int following_user_uid;
  int followed_user_uid;
  var follows_created_at;

  // 생성자에서 user_uid를 선택적으로 받음
  FollowUser({
    required this.following_user_uid,
    required this.followed_user_uid,
    this.follows_created_at,
  });

  // JSON에서 객체 생성
  factory FollowUser.fromJson(Map<String, dynamic> json) => FollowUser(
    following_user_uid: int.parse(json['following_user_uid']) ?? 0, // 서버에서 받아온 user_uid
    followed_user_uid: int.parse(json['followed_user_uid']) ?? 0, // 서버에서 받아온 user_uid
    follows_created_at: json['created_at'] ?? '',
  );

  // 객체를 JSON으로 변환 (user_uid는 null일 수 있음)
  Map<String, dynamic> toJson() => {
    if (following_user_uid != null) 'user_uid': following_user_uid.toString(), // null이면 포함하지 않음
    if (followed_user_uid != null) 'user_uid': followed_user_uid.toString(), // null이면 포함하지 않음
    'created_at': follows_created_at?.toString() ?? '',
  };
}