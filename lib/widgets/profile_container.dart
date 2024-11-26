import 'dart:convert';

import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/tweet/media_pref.dart';
import 'package:contact1313/tweet/tweet_pref.dart';
import 'package:contact1313/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';

import '../api/api.dart';
import '../authentication/login.dart';
import '../main.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import '../user/user_pref.dart';
import 'circular_profile.dart';
import 'tweet_container.dart';
import '../theme/colors.dart';
import 'floating_button.dart';
import 'package:http/http.dart' as http;

List<Tweet> tweets = [];

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({super.key});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserTweets();
  }

  Future<void> fetchUserTweets() async {
    try {
      List<Tweet> fetchedTweets = await RememberTweet.loadTweets(currentUserInfo.user_uid ?? -5);
      setState(() {
        tweets = fetchedTweets; // 가져온 데이터를 상태에 저장
        isLoading = false; // 로딩 상태 변경
      });
    } catch (e) {
      print('Error fetching tweets: $e');
      setState(() {
        isLoading = false; // 로딩 상태 변경
      });
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
    return Column(
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
                itemCount: tweets.length + 2, //프로필과 실선(경계선) + 트윗 수
                  itemBuilder: (BuildContext ctx, int idx){
                    return idx == 0
                        ? _buildProfileSection()
                        : idx == 1 ? _buildSolidLine(1.0)
                          : tweetContainer(tweet: tweets[idx - 2]);
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
                      onPressed:() => _redirectPage("/home"), colorVal: Theme.of(context).customTransparentColor, toolTip :'',
                      icon: Icons.arrow_back, iconSize: iconSize2, height: 24, width: 24,iconColor: Theme.of(context).customIconColor2, //글을 적으면 iconColor1으로 변경됨
                    ),
                    const SizedBox(width: 13),
                    Text(
                      currentUserInfo?.user_name ?? "Guest",
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

  Widget _buildProfileSection(){
    return  SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              print('Edit it');
            },
            splashColor: Colors.transparent, // 물결 효과 제거
            highlightColor: Colors.transparent, // 강조 효과 제거
            onHover: (isHovering) {
              print(isHovering ? 'Hovering' : 'Not Hovering'); // 디버깅용 출력
            },
            hoverColor: Theme.of(context).customBackgroundColor1, // 호버 시 색상 변경
            child: Ink(
              height: 220,
              decoration: BoxDecoration(color: Theme.of(context).customBackgroundColor2),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child:
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container( //유저 프로필 및 프로필 수정 부분
                  clipBehavior: Clip.none,
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(),
                      ),
                      CustomTextButton(
                          onPressed: (){},
                          width: 110,
                          height: 36,
                          text: "Edit",
                          fontSize: fontSize3,
                          boxDecoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).customBackgroundColor2, width: 1),
                              borderRadius: BorderRadius.circular(30),
                          ),
                      ),

                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child:
                    CircularProfile(onPressed: (){},radius: 70,userInfo: currentUserInfo, strokeRadius: 5,)
                )
              ],
            ),
          ),
          Row(
            children: [
              Container( //유저 정보
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                height: 150,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUserInfo?.user_name ?? "ShimaRin",
                      style: TextStyle(
                        color: Theme.of(context).customTextColor1,
                        fontSize: fontSize5,
                        fontFamily: 'ABeeZee',
                      ),
                    ),Text(
                      '@${currentUserInfo?.user_id ?? "Shima_ringring"}',
                      style: TextStyle(
                        color: Theme.of(context).customTextColor2,
                        fontSize: fontSize2,
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      tweets[0].body,
                      style: TextStyle(
                        color: Theme.of(context).customTextColor1,
                        fontSize: fontSize2,
                        fontFamily: 'ABeeZee',
                      ),
                    ),Text(
                      'Join in ${currentUserInfo?.created_at ?? "2024-11-11"}',
                      style: TextStyle(
                        color: Theme.of(context).customTextColor2,
                        fontSize: fontSize2,
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                    Row(
                      children: [

                        Text(
                          "8 Followers",
                          style: TextStyle(
                            color: Theme.of(context).customTextColor1,
                            fontSize: fontSize2,
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "0 Following",
                          style: TextStyle(
                            color: Theme.of(context).customTextColor1,
                            fontSize: fontSize2,
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                      ],
                    )
                  ],

                ),
              ),
              Expanded(child: SizedBox()),
            ],
          )
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
