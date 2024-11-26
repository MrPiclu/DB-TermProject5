class User {
  int? user_uid;
  String user_id;
  String user_name;
  String profile_image_url;
  var user_number;
  String user_email;
  var created_at;
  var updated_at;
  String user_password;

  // 생성자에서 user_uid를 선택적으로 받음
  User({
    this.user_uid,
    required this.user_id,
    required this.user_name,
    required this.profile_image_url,
    this.user_number,
    required this.user_email,
    this.created_at,
    this.updated_at,
    required this.user_password,
  });

  // JSON에서 객체 생성
  factory User.fromJson(Map<String, dynamic> json) => User(
    user_uid: int.parse(json['user_uid']) ?? 0, // 서버에서 받아온 user_uid
    user_id: json['user_id'] ?? '',
    user_name: json['user_name'] ?? '',
    profile_image_url: json['profile_image_url'] ?? '',
    user_number: json['user_number'] ?? '',
    user_email: json['user_email'] ?? '',
    created_at: json['created_at'] ?? '',
    updated_at: json['updated_at'] ?? '',
    user_password: json['user_password'] ?? '',
  );

  // 객체를 JSON으로 변환 (user_uid는 null일 수 있음)
  Map<String, dynamic> toJson() => {
    if (user_uid != null) 'user_uid': user_uid.toString(), // null이면 포함하지 않음
    'user_id': user_id,
    'user_name': user_name,
    'profile_image_url': profile_image_url,
    'user_number': user_number?.toString() ?? '',
    'user_email': user_email,
    'created_at': created_at?.toString() ?? '',
    'updated_at': updated_at?.toString() ?? '',
    'user_password': user_password,
  };
}