class Tweet {
  int? id;
  var title;
  String body;
  int user_uid;
  var status;
  var created_at;
  var retweet_count;
  var view_count;
  var fav_count;
  var chat_count;

  // 생성자에서 user_uid를 선택적으로 받음
  Tweet({
    this.id,
    this.title,
    required this.body,
    required this.user_uid,
    this.status,
    this.created_at,
    this.retweet_count,
    this.view_count,
    this.fav_count,
    this.chat_count,
  });

  // JSON에서 객체 생성
  factory Tweet.fromJson(Map<String, dynamic> json) => Tweet(
    id: int.parse(json['id']) ?? 0, // 서버에서 받아온 user_uid
    title: json['title'] ?? '',
    body: json['body'] ?? '',
    user_uid: int.parse(json['user_uid']) ?? 0,
    status: json['status'] ?? '',
    created_at: json['created_at'] ?? '',
    retweet_count: json['retweet_count'] ?? '',
    view_count: json['view_count'] ?? '',
    fav_count: json['fav_count'] ?? '',
    chat_count: json['chat_count'] ?? '',
  );

  // 객체를 JSON으로 변환 (user_uid는 null일 수 있음)
  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id.toString(), // null이면 포함하지 않음
    'title': title,
    'body': body,
    'user_uid': user_uid,
    'status': status,
    'created_at': created_at?.toString() ?? '',
    'view_count': view_count?.toString() ?? '',
    'fav_count': fav_count?.toString() ?? '',
    'chat_count': chat_count?.toString() ?? '',
  };
}