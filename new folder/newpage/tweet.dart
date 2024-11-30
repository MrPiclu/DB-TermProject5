// tweet.dart
class Tweet {
  final int id;
  final int user_uid;
  final String created_at;
  final String body;
  final int fav_count;
  final int chat_count;

  Tweet({
    required this.id,
    required this.user_uid,
    required this.created_at,
    required this.body,
    required this.fav_count,
    required this.chat_count,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      user_uid: json['user_uid'],
      created_at: json['created_at'],
      body: json['body'],
      fav_count: json['fav_count'],
      chat_count: json['chat_count'],
    );
  }
}
