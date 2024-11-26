import 'package:contact1313/model/tweet.dart';

class Media {
  final int id;
  final String mediaType;
  final String mediaUrl;

  Media({required this.id, required this.mediaType, required this.mediaUrl});

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json['id'] ?? 0,
    mediaType: json['media_type'] ?? '',
    mediaUrl: json['media_url'] ?? '',
  );
}