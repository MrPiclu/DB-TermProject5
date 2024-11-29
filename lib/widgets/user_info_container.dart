import 'dart:convert';
import 'dart:ffi';

import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/tweet/media_pref.dart';
import 'package:contact1313/tweet/tweet_pref.dart';
import 'package:contact1313/tweet/user_pref.dart';
import 'package:contact1313/widgets/profile_container.dart';
import 'package:contact1313/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/media.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import '../theme/colors.dart';
import 'async/async_img.dart';
import 'circular_profile.dart';
import 'floating_button.dart';
import 'reaction_button.dart';

Media? medias;

class userInfoContainer extends StatefulWidget {

  final User? users;

  const userInfoContainer({
    super.key,
    required this.users
  });
  @override
  State<userInfoContainer> createState() => _userInfoContainerState();
}

class _userInfoContainerState extends State<userInfoContainer>{
  DateTime parsedData = DateTime(2023);
  String? fixedUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqXtvUw93BzewwknzouqY0JtoKUPNBDcXbuw&s';

  void _redirectPage(String location) {
    context.go(location);
  }
  void _incrementCounter() {
      print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // print(widget.tweet.created_at.runtimeType);
        // print(widget.tweet.created_at);
      },
      splashColor: Colors.transparent, // 물결 효과 제거
      highlightColor: Colors.transparent, // 강조 효과 제거
      onHover: (isHovering) {
        // print(isHovering ? 'Hovering' : 'Not Hovering'); // 디버깅용 출력
      },
      hoverColor: Theme.of(context).customBackgroundColor2, // 호버 시 색상 변경
      child: Ink(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildMainTweetSection(context),
              _buildSolidLine(1.0),
            ],
          ),
      ),
    );
  }

  Widget _buildMainTweetSection(BuildContext context) {
    return  Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top:9, bottom: 4, left: 4, right: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      child:
                          InkWell(
                            child:
                            CircularProfile(
                              onPressed: (){
                                _redirectPage("/${widget.users?.user_uid}/profile");
                                },
                              radius: 25,
                              userInfo: widget.users,
                              strokeRadius: 0,
                            ),
                          ),
                    ),
                    const SizedBox(height : 8),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Column(
                          children: [
                            Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.users?.user_name ?? 'Guest2', style: TextStyle(color: Theme.of(context).customTextColor1, fontSize: fontSize4)),
                                      Text('@${widget.users?.user_name ?? 'Guest2'}', style: TextStyle(color: Theme.of(context).customTextColor2, fontSize: fontSize2)),
                                      SizedBox(
                                        width: 400,
                                          child: Text(
                                              '유토리는 옳거니 걸렸구나란말을하며 다들 유이치랑 협력한놈을 추방하자 참가자 몇명떨떠름하자 유토리는 물론 반론을해도좋다며  단지 그 협력자는 반드시 이름이 나와야된다 안그러면 지 기사(시바 신지)가 날뛸것이다라고 협박',
                                              style: TextStyle(
                                                  color: Theme.of(context).customTextColor2,
                                                  fontSize: fontSize2),
                                            overflow: TextOverflow.visible,
                                          )
                                      ),
                                    ],
                                  ),
                                  const Expanded(child: SizedBox()),
                                  CustomTextButton(
                                    onPressed: (){
                                      setState(() {
                                        print("Button Clicked!!!");
                                      });
                                    },
                                    width: 100,
                                    text: "Following",
                                    fontSize: fontSize2,
                                    boxDecoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).customBackgroundColor2, width: 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
