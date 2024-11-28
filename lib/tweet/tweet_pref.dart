import 'dart:convert';

import '../api/api.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RememberTweet{
  static const String _userKey = "currentUser"; // 저장할 키 이름

  static Future<List<Tweet>> loadTweets(int userUid) async{
    if(userUid == -5)  return [];
    try{
      var res = await http.post(
          Uri.parse(API.downloadTweets),
          body: {
            'user_uid' : userUid.toString(),
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

  static Future<List<Tweet>> loadTweet(int userUid) async{
    if(userUid == -5)  return [];
    try{
      var res = await http.post(
          Uri.parse(API.downloadTweets),
          body: {
            'user_uid' : userUid.toString(),
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

  static Future<User?> loadUserInfo(int userUid) async{
    if (userUid == -5) {
      print('Invalid user_uid ID');
      return null; // 잘못된 tweet_id 처리
    }
    try{
      print("user uid is ${userUid}");
      var res = await http.post(
        Uri.parse(API.getUserInfo),
        body: {
          'user_uid': userUid.toString(),
        },
      );

      print("go next");

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        print("go next");
        var resUserInfo = jsonDecode(res.body);

        if(resUserInfo['success'] == true){
          print("go next");

          print("get user info success");
          print(resUserInfo['userData']);
          return User.fromJson(resUserInfo['userData']);
        }else{
          print("Erorr ");
        }
      }
      print("5");
    }catch(e){
      print('getUserInfo Catc14hed');
      print(e.toString());
    }
    return null;
  }


}

