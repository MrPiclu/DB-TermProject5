import 'dart:convert';

import 'package:contact1313/authentication/login.dart';

import '../api/api.dart';
import '../model/tweet.dart';
import 'package:http/http.dart' as http;

class RememberTweet{
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

  static Future<List<Tweet>> loadFavoriteTweets() async{
    print("entered favorite tweet");
    try{
      var res = await http.post(
          Uri.parse(API.getFavoriteTweets),
          body: {
            'user_uid' : currentUserInfo.user_uid.toString(),
          });

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        final Map<String, dynamic> decoded = jsonDecode(res.body);
        if(decoded['success'] == true){
          List<dynamic> tweetsJson = decoded['allFavTweets'];
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

  static Future<Map<String, dynamic>> loadFavoriteInfo(int tweetId) async{
    // print("Load Following Info in User_pref");
    if (tweetId == -5) {
      // print('Invalid user_uid ID');
      return {
        'userCount': 0,
        'isFavorited': false,
      }; // 잘못된 tweet_id 처리
    }
    try{
      var res = await http.post(
        Uri.parse(API.downloadFavTweet),
        body: {
          'tweet_id' : tweetId.toString(), // 팔로우를 건 사람
          'user_uid' : currentUserInfo.user_uid.toString(),
        },
      );

      // print(res.statusCode);
      // print(res.body);

      if(res.statusCode == 200){
        // print("1");
        final Map<String, dynamic> decoded = jsonDecode(res.body);

        // print("1");
        if(decoded['success'] == true){
          List<dynamic> usersJson = decoded['users'];
          bool isFavorited = decoded['isFavorited'];
          // print("아이고난시");
          // print(usersJson.toString());
          // print(isFavorited.toString());

            return {
              'userCount' : usersJson.length,
              'isFavorited' : isFavorited,
            };
        }else{
          return {
            'userCount' : 0,
            'isFavorited' : false,
          };
        }
      }
      // print("5");
    }catch(e){
      print('getFollowingUsers Catched');
      print(e.toString());
    }
    return {
      'userCount': 0,
      'isFavorited': false,
    };
  }

}

