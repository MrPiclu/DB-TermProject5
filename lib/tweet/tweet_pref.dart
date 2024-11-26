import 'dart:convert';

import '../api/api.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RememberTweet{
  static const String _userKey = "currentUser"; // 저장할 키 이름

  static Future<List<Tweet>> loadTweets(int user_uid) async{
    if(user_uid == -5)  return [];
    try{
      var res = await http.post(
          Uri.parse(API.downloadTweet),
          body: {
            'user_uid' : user_uid.toString(),
          });

      // print(res.statusCode);
      // print(res.body);

      if(res.statusCode == 200){
        final Map<String, dynamic> decoded = jsonDecode(res.body);
        if(decoded['success'] == true){
          List<dynamic> tweetsJson = decoded['tweets'];
          return tweetsJson.map((tweet) => Tweet.fromJson(tweet)).toList();
        }else{
          // Fluttertoast.showToast(msg: 'Error occurred.');
          return [];
        }
      }else {
        throw Exception('Failed to fetch tweets: ${res.statusCode}');
      }
    }catch(e){
      print('load tweet Catched');
      print(e.toString());
      return [];
      // Fluttertoast.showToast(msg: e.toString());

    }
  }

}

