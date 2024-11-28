import 'dart:convert';

import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/tweet/media_pref.dart';
import 'package:contact1313/tweet/tweet_pref.dart';
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
User? userInfo;

class tweetContainer extends StatefulWidget {

  final Tweet tweet;

  const tweetContainer({
    super.key,
    required this.tweet
  });
  @override
  State<tweetContainer> createState() => _tweetContainerState();
}

class _tweetContainerState extends State<tweetContainer>{
  DateTime parsedData = DateTime(2023);
  bool isLoading = true;

   @override
  void initState() {
     super.initState();
    // TODO: implement initState
     loadUserInfo();
     _loadMedias();
     _convertDate();
  }


  void _redirectPage(String location) {
    context.go(location);
  }
  void _incrementCounter() {
      print('hello');
  }

  void _convertDate(){
    parsedData = DateTime.parse(widget.tweet.created_at);
  }

  Future<void> loadUserInfo() async{
    try{
      User? fetchedUser = await RememberTweet.loadUserInfo(widget.tweet.user_uid ?? -5);
      if(mounted){
        setState(() {
          userInfo = fetchedUser; // 가져온 데이터를 상태에 저장
          print(userInfo?.user_name);
        });
      }

    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _loadMedias() async {
    try {
      Media? fetchedMedias = await LoadTweetMedias.loadMedia(widget.tweet.id ?? -5);
      if(mounted){
        setState(() {
          medias = fetchedMedias; // 가져온 데이터를 상태에 저장
          // print(widget.tweet.body);
          // print(medias?.mediaUrl);
          isLoading = false; // 로딩 상태 변경
        });
      }
    } catch (e) {
      print('Error fetching tweets: $e');
    }
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
                              onPressed: (){_redirectPage("/${userInfo?.user_uid}/profile");},
                              radius: 25,
                              userInfo: userInfo,
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
                                  Text(userInfo?.user_name ?? 'Guest2', style: TextStyle(color: Theme.of(context).customTextColor1, fontSize: fontSize4)),
                                  SizedBox(width: 8),
                                  Text('@${userInfo?.user_name ?? 'Guest2'}', style: TextStyle(color: Theme.of(context).customTextColor2, fontSize: fontSize2)),
                                  Expanded(child: SizedBox()),
                                  Text('${DateFormat("dd, MMM").format(parsedData)}', style: TextStyle(color: Theme.of(context).customTextColor2, fontSize: fontSize4)),
                                ]
                            ),
                            SizedBox(height: 10),
                            Container(
                                padding: EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).customBackgroundColor2,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.tweet.body, style: TextStyle(color: Theme.of(context).customTextColor2, fontSize: fontSize2),),
                                    const SizedBox(height: 8),
                                    AsyncDynamicHeightContainer(
                                      key: ValueKey(medias?.mediaUrl ?? 'default_key'),
                                      imgUrl: medias!.mediaUrl,
                                    )
                                  ],
                                ),

                              ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                _buildSolidLine(0.4),
                Container(
                  padding: const EdgeInsets.all(4),
                  child: _buildReactionButtonRow(),
                ),
              ],
            ),
          );

  }

  Widget _buildReactionButtonRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ReactionButton(onPressed: _incrementCounter, colorVal: Theme.of(context).customTransparentColor, toolTip: 'DM',
           icon: Icons.favorite, iconSize: iconSize2, width: 36, height: 36, iconColor: Theme.of(context).customIconColor1,
          ),
          const SizedBox(width: 8),
          ReactionButton(onPressed: _incrementCounter, colorVal: Theme.of(context).customTransparentColor, toolTip: 'BookMark',
            icon: Icons.chat_bubble, iconSize: iconSize2, width: 36, height: 36, iconColor: Theme.of(context).customIconColor1,
          ),
          const Expanded(child: SizedBox()),
          ReactionButton(onPressed: _incrementCounter, colorVal: Theme.of(context).customTransparentColor, toolTip: 'Setting',
            icon: Icons.bookmark, iconSize: iconSize2, width: 36, height: 36, iconColor: Theme.of(context).customIconInvertColor1,
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
