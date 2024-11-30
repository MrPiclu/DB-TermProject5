class Notify {
  int? id;
  final int initiator_id;
  final int user_uid;
  final String user_name;
  var tweet_id;
  var comment_id;
  var is_read;
  final String type;
  var follows_created_at;

  // 생성자에서 user_uid를 선택적으로 받음
  Notify({
    required this.user_name,
    this.id,
    required this.initiator_id,
    required this.user_uid,
    this.tweet_id,
    this.comment_id,
    this.is_read,
    required this.type,
    this.follows_created_at,
  });

  // JSON에서 객체 생성
  factory Notify.fromJson(Map<String, dynamic> json) => Notify(
    id: int.parse(json['id']) ?? 0, // 서버에서 받아온 user
    initiator_id: int.parse(json['initiator_id']) ?? 0, // 서버에서 받아온 user_uid
    user_uid: int.parse(json['user_uid']) ?? 0, // 서버에서 받아온 user_uid
    user_name: json['user_name'] ?? '', // 서버에서 받아온 user_uid
    tweet_id: json['tweet_id'] ?? 0, // 서버에서 받아온 user_uid
    comment_id: json['comment_id'] ?? 0, // 서버에서 받아온 user_uid
    is_read: json['is_read'] ?? 0, // 서버에서 받아온 user_uid
    type: json['type'] ?? '', // 서버에서 받아온 user_uid
    follows_created_at: json['created_at'] ?? '',
  );

  // 객체를 JSON으로 변환 (user_uid는 null일 수 있음)
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_uid': user_uid,
    'user_name': user_name,
    'initiator_id': initiator_id,
    'tweet_id': tweet_id?.toString() ?? '',
    'comment_id': comment_id?.toString() ?? '',
    'is_read': is_read?.toString() ?? '',
    'type': type.toString() ?? '',
    'created_at': follows_created_at?.toString() ?? '',
  };
}