import 'dart:convert';

import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUser{
  static const String _userKey = "currentUser"; // 저장할 키 이름

  static Future<void> saveRememberUserInfo(User userInfo) async{
    print('1');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('1');
    String userJsonData = jsonEncode(userInfo.toJson());
    print('1');
    await preferences.setString(_userKey, userJsonData);
    print('1');
  }

  // 유저 정보 불러오기 메서드
  static Future<User?> getRememberUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_userKey); // 저장된 JSON 문자열 가져오기

    if (userJson == null) return null; // 저장된 정보가 없으면 null 반환

    Map<String, dynamic> userMap = jsonDecode(userJson); // JSON 문자열을 Map으로 변환
    return User.fromJson(userMap); // Map을 User 객체로 변환
  }
}

