import 'dart:convert';

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LoadUserInfo{
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

  static Future<bool> loadFollowInfo(int userUid) async{
    if (userUid == -5) {
      print('Invalid user_uid ID');
      return false; // 잘못된 tweet_id 처리
    }
    try{
      print("user uid141414 is ${userUid}");
      var res = await http.post(
        Uri.parse(API.getFollowInfo),
        body: {
          'followed_user_uid' : currentUserInfo.user_uid.toString(), // 팔로우를 건 사람
          'following_user_uid' : userUid.toString(), // 팔로우를 당한 사람
        },
      );

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        print("go next");
        var resUserInfo = jsonDecode(res.body);
        print(resUserInfo['success']);

        if(resUserInfo['success'] == true){
          print("get follow info success");
          return true;
        }else{
          print("get follow info false");
          return false;
        }
      }
      print("5");
    }catch(e){
      print('getUserInfo Catc14hed');
      print(e.toString());
    }
    return false;
  }

}

