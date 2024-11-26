import 'dart:convert';
import '../api/api.dart';
import '../model/media.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;

class LoadTweetMedias {
  static const String _userKey = "currentUser"; // 저장할 키 이름

  static Future<Media?> loadMedia(int tweet_id) async {
    if (tweet_id == -5) {
      print('Invalid tweet ID');
      return null; // 잘못된 tweet_id 처리
    }
    try {
      var res = await http.post(
        Uri.parse(API.downloadTweetMedia),
        body: {
          'tweet_id': tweet_id.toString(),
        },
      );

      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(res.body);

        if (decoded['success'] == true) {
          List<dynamic> mediasJson = decoded['medias'];

          if (mediasJson.isNotEmpty) {
            // 첫 번째 Media 반환
            return Media.fromJson(mediasJson[0]);
          } else {
            print('No media found for this tweet.');
            return null;
          }
        } else {
          print('Error fetching media: ${decoded['message']}');
          return null;
        }
      } else {
        throw Exception('Failed to fetch media: ${res.statusCode}');
      }
    } catch (e) {
      print('Error in loadMedia: $e');
      return null; // 에러 발생 시 null 반환
    }
  }
}
