import 'dart:convert';

import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/tweet/media_pref.dart';
import 'package:contact1313/tweet/tweet_pref.dart';
import 'package:contact1313/widgets/text_button.dart';
import 'package:contact1313/widgets/user_info_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';

import '../api/api.dart';
import '../authentication/login.dart';
import '../main.dart';
import '../model/followUser.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import '../tweet/user_pref.dart';
import '../user/user_pref.dart';
import 'circular_profile.dart';
import 'tweet_container.dart';
import '../theme/colors.dart';
import 'floating_button.dart';
import 'package:http/http.dart' as http;

List<User?> users = [];
User? userInfo;

class FollowingInfoContainer extends StatefulWidget {
  final  int userUid;
  const FollowingInfoContainer({super.key, required this.userUid});

  @override
  State<FollowingInfoContainer> createState() => _FollowingInfoContainerState();
}

class _FollowingInfoContainerState extends State<FollowingInfoContainer> {
  bool isLoading = true;
  bool isFollowing = false;
  User? getUser;

  @override

  void initState() {
    super.initState();
    // TODO: implement initState\
    loadAllData();
  }

  Future<void> loadAllData() async {
    await loadUserInfo();
    await _loadFollowingInfo();   // 세 번째 함수 실행
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadUserInfo() async{
    print("Entered load user info in follow container");
    try{
      print("1");
      User? fetchedUser = await LoadUserInfo.loadUserInfo(widget.userUid ?? -5);
      print("2");
      if(!mounted) return;
      setState(() {
        userInfo = fetchedUser; // 가져온 데이터를 상태에 저장
      });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> loadFollowingUser(int userUid) async{
    print("Entered load user info in follow container");
    try{
      print("1");
      User? fetchedUser = await LoadUserInfo.loadUserInfo(userUid ?? -5);
      print("2");
      if(!mounted) return;
      setState(() {
        getUser = fetchedUser; // 가져온 데이터를 상태에 저장
      });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _loadFollowingInfo() async{
    try{
      print("Loading Follow Info....");
      List<FollowUser> fetchedFollowingInfo = await LoadUserInfo.loadFollowingInfo(widget.userUid ?? -5);
      if(!mounted) return;

      users = List<User?>.filled(fetchedFollowingInfo.length, null);

      for(int i = 0; i < fetchedFollowingInfo.length; i++){
        await loadFollowingUser(fetchedFollowingInfo[i].following_user_uid);
        print("${getUser!.user_name} + 아이고난");
        users[i] = getUser;
      };

      setState(() async {
      });
    }catch(e){
      print(e.toString());
    }

  }

  void _redirectPage(String location) {
    context.go(location);
  }
  void _incrementCounter() {
      print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          height: 64,
          width: 603,
          child:_buildMainUploadSection(context),
        ),
        Container(
          width: 603,
          height: MediaQuery.of(context).size.height - 64,
          child:
          ListView.builder(
              itemCount: users.isEmpty ? 1 : users.length, //프로필과 실선(경계선) + 트윗 수
              itemBuilder: (BuildContext ctx, int idx){
                return isLoading
                    ? Center(
                  child: Container(
                      child: CircularProgressIndicator()
                  ),
                ): users.isEmpty
                    ? Center(
                    child: Container(
                      width: 603,
                      height: 150,
                      child: _buildNoUserSection(),
                     ),
                    )
                    : userInfoContainer(users: users[idx], key: ValueKey(users[idx]?.user_uid),);
              }
          )
        ),
      ],
    );
  }

  Widget _buildMainUploadSection(BuildContext context) {
    return  Container(
      color: Theme.of(context).customBackgroundColor1,
      width: double.infinity,
      height: 64,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(3),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    FloatingButton(
                      onPressed:() => _redirectPage("/${userInfo?.user_uid}/profile"), colorVal: Theme.of(context).customTransparentColor, toolTip :'',
                      icon: Icons.arrow_back, iconSize: iconSize2, height: 24, width: 24,iconColor: Theme.of(context).customIconColor2, //글을 적으면 iconColor1으로 변경됨
                    ),
                    const SizedBox(width: 13),
                    Text(
                      userInfo?.user_name ?? "Guest",
                      style: TextStyle(
                        color: Theme.of(context).customTextColor2,
                        fontSize: fontSize5,
                        fontFamily: 'ABeeZee',
                        height: 1.0, // vertical center
                      ),
                    )
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoUserSection(){
    return  const SizedBox(
      child: Column(
        children: [
          SizedBox(height: 40,),
          Text(
              '아직 팔로잉 하지 않았습니다',
            style: TextStyle(
              fontSize: fontSize6
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text('다른 유저를 팔로우하면 여기에 표시됩니다.',
            style: TextStyle(
                fontSize: fontSize4,
                color: textColor2
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconRow() {
    return Row(
        children: [
          FloatingButton(
            onPressed:_incrementCounter, colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'Upload Picture',
            icon: Icons.photo, iconSize: iconSize2, height: 24, width: 48,iconColor: Theme.of(context).customIconColor1,
          ),
          const SizedBox(width: 8),
          FloatingButton(
            onPressed:_incrementCounter, colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'Share Location',
            icon: Icons.location_on_sharp, iconSize: iconSize2, height: 24, width: 48,iconColor: Theme.of(context).customIconColor1,
          ),
        ]
    );
  }


  Widget _buildSolidLine(double radius){
    return Container(
      width: double.infinity,
      height: radius,
      color: Theme.of(context).dividerColor,
    );
  }

}
