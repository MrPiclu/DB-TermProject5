import 'dart:convert';
import 'package:contact1313/authentication/login.dart';

import '../api/api.dart';
import '../model/media.dart';
import 'package:http/http.dart' as http;

import '../model/notification.dart';

class LoadNotifications {
  static Future<List<Notify>> loadNotifications(int user_uid) async {
    print('2');
    if (user_uid == -5) {
      print('Invalid tweet ID');
      return []; // 잘못된 tweet_id 처리
    }
    try {
      print('2');
      var res = await http.post(
        Uri.parse(API.downloadNotify),
        body: {
          'user_uid': user_uid.toString(),
        },
      );
      print('2');

      print(res.statusCode);
      print(res.body);
      print('2');

      if (res.statusCode == 200) {
        print('2');
        final Map<String, dynamic> decoded = jsonDecode(res.body);
        print('3');

        if (decoded['success'] == true) {
          print('3');
          List<dynamic> notifiesJson = decoded['notifications'];
          print(notifiesJson);

          if (notifiesJson.isNotEmpty) {
            print('3');
            // 첫 번째 Media 반환
            return notifiesJson.map((notify) => Notify.fromJson(notify)).toList();
          } else {
            print('3');
            print('No media found for this tweet.');
            return [];
          }
        } else {
          print('3');
          print('Error fetching notify: ${decoded['notifications']}');
          return [];
        }
      } else {
        print('3');
        throw Exception('Failed to fetch media: ${res.statusCode}');
      }
    } catch (e) {
      print('Error in loadMedia: $e');
      return []; // 에러 발생 시 null 반환
    }
  }
}
