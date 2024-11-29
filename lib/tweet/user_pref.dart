import 'dart:convert';

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/followUser.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LoadUserInfo{
  static Future<User?> loadUserInfo(int userUid) async{
    print("entered in loaduser info in user_pref");
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
          return User.fromJson(resUserInfo['userData']);
        }else{
          print("Erorr ");
        }
      }
      // print("5");
    }catch(e){
      print('getUserInfo Catc14hed');
      print(e.toString());
    }
    return null;
  }

  static Future<bool> loadFollowInfo(int userUid) async{
    print("Load Follow Info in User_pref");
    if (userUid == -5) {
      print('Invalid user_uid ID');
      return false; // 잘못된 tweet_id 처리
    }
    try{
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

  static Future<List<FollowUser>> loadFollowingInfo(int userUid) async{
    print("Load Following Info in User_pref");
    if (userUid == -5) {
      print('Invalid user_uid ID');
      return []; // 잘못된 tweet_id 처리
    }
    try{
      var res = await http.post(
        Uri.parse(API.getFollowingUsers),
        body: {
          'followed_user_uid' : userUid.toString(), // 팔로우를 건 사람
          'type' : "following", // 팔로우를 건 사람
        },
      );

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        print("1");
        final Map<String, dynamic> decoded = jsonDecode(res.body);

        print("1");
        if(decoded['success'] == true){
          print("1");
          List<dynamic> usersJson = decoded['users'];
          print("1");

          if (usersJson.isNotEmpty) {
            print("1");
            // 전체 JSON 데이터를 User 리스트로 변환하여 반환
            return usersJson.map((json) => FollowUser.fromJson(json)).toList();
          } else {
            return [];
          }
        }else{
          return [];
        }
      }
      print("5");
    }catch(e){
      print('getFollowingUsers Catched');
      print(e.toString());
    }
    return [];
  }

  static Future<List<FollowUser>> loadFollowerInfo(int userUid) async{
    print("Load Followed Info in User_pref");
    if (userUid == -5) {
      print('Invalid user_uid ID');
      return []; // 잘못된 tweet_id 처리
    }
    try{
      var res = await http.post(
        Uri.parse(API.getFollowingUsers),
        body: {
          'followed_user_uid' : userUid.toString(), // 팔로우를 건 사람
          'type' : "followed", // 팔로우를 건 사람
        },
      );

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        print("1");
        final Map<String, dynamic> decoded = jsonDecode(res.body);

        print("1");
        if(decoded['success'] == true){
          print("1");
          List<dynamic> usersJson = decoded['users'];
          print("1");

          if (usersJson.isNotEmpty) {
            print("팔로ed");
            print("1");
            // 전체 JSON 데이터를 User 리스트로 변환하여 반환
            return usersJson.map((json) => FollowUser.fromJson(json)).toList();
          } else {
            return [];
          }
        }else{
          return [];
        }
      }
      print("5");
    }catch(e){
      print('getFollowingUsers Catched');
      print(e.toString());
    }
    return [];
  }

}

