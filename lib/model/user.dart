class User {
  int? user_uid;
  String? user_id;
  String? user_name;
  var profile_image_url;
  var user_number;
  String? user_email;
  var created_at;
  var updated_at;
  String? user_password;

  User(this.user_uid,
      this.user_id,
      this.user_name,
      this.profile_image_url,
      this.user_number,
      this.user_email,
      this.created_at,
      this.updated_at,
      this.user_password,);

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        int.tryParse(json['user_uid']?.toString() ?? '0') ?? 0,
        json['user_id'] ?? '',
        json['user_name'] ?? '',
        json['profile_image_url'] ?? '',
        json['user_number'] ?? '',
        json['user_email'] ?? '',
        json['created_at'] ?? '',
        json['updated_at'] ?? '',
        json['user_password'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        'user_uid': user_id?.toString() ?? '',
        // Convert to string or empty if null
        'user_id': user_id ?? '',
        'user_name': user_name ?? '',
        // Use empty string if null
        'profile_image_url': profile_image_url?.toString() ?? '',
        'user_number': user_number?.toString() ?? '',
        'user_email': user_email ?? '',
        'created_at': created_at?.toString() ?? '',
        'updated_at': updated_at?.toString() ?? '',
        'user_password': user_password ?? '',
      };
}