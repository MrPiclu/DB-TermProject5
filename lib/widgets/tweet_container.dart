import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/tweet/media_pref.dart';
import 'package:contact1313/tweet/user_pref.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/media.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import '../tweet/tweet_pref.dart';
import 'async/async_img.dart';
import 'circular_profile.dart';
import 'reaction_button.dart';
import 'package:http/http.dart' as http;


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
  int favCount = 0;
  int chatCount = 0;


  DateTime parsedData = DateTime(2023);

  bool isFavorited = false;
  bool isLoading = true;
  String? fixedUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqXtvUw93BzewwknzouqY0JtoKUPNBDcXbuw&s';


   @override
  void initState() {
     super.initState();
    // TODO: implement initState
     loadAllData();
  }

  Future<void> loadAllData() async {
    await loadUserInfo();
    await _loadMedias();  // 세 번째 함수 실행
    await _downloadFav();
    setState(() {
      _convertDate();
      isLoading = false;
    });
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
      User? fetchedUser = await LoadUserInfo.loadUserInfo(widget.tweet.user_uid ?? -5);
      if(!mounted) return;
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
    final tweetId = widget.tweet.id;
    try {
      Media? fetchedMedias = await LoadTweetMedias.loadMedia(tweetId!);
      if (mounted && widget.tweet.id == tweetId) { // 매칭 보장
        setState(() {
          medias = fetchedMedias;
          fixedUrl = medias?.mediaUrl;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching media: $e');
    }
  }

  Future<void> _fav() async{
    print("entered in favoriting");
    try{
      var res = await http.post(
          Uri.parse(API.favTweet),
          body: {
            'user_uid' : currentUserInfo.user_uid.toString(), // 팔로우를 건 사람
            'id' : widget.tweet.id.toString(), // 팔로우를 당한 사람
            'isFav' : 'true',
          });

      setState(() {
        favCount = widget.tweet.fav_count + 1;
      });

      print("Favorite!! ");
      print(res.statusCode);
      print(res.body);
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _updateFav(String type) async{
    print("entered in favoriting");
    try{
      var res = await http.post(
          Uri.parse(API.updateFavTweet),
          body: {
            'user_uid' : currentUserInfo.user_uid.toString(), // 팔로우를 건 사람
            'tweet_id' : widget.tweet.id.toString(), // 팔로우를 당한 사람
            'isFav' : type,
          });
      print("Favorite!! ");
      print(res.statusCode);
      print(res.body);

      await _downloadFav();

    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _downloadFav() async{
    try{
      Map<String, dynamic> info = await RememberTweet.loadFavoriteInfo(widget.tweet.id ?? 0);
      setState(() {
        favCount = info['userCount'];
        isFavorited = info['isFavorited'];
      });

    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? Center(
      child: Container(
        child: const CircularProgressIndicator(),
      ),
    )
    : InkWell(
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
                                _redirectPage("/${userInfo?.user_uid}/profile");
                                },
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                // width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).customBackgroundColor2,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.tweet.body, style: TextStyle(color: Theme.of(context).customTextColor2, fontSize: fontSize2),),
                                    const SizedBox(height: 8),
                                    AsyncDynamicHeightContainer(imgUrl: fixedUrl!,),
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
          ReactionButton(
            onPressed: (){
              setState(() {
                isFavorited ?  _updateFav('false') : _updateFav('true');
              });
          },
            colorVal: Theme.of(context).customTransparentColor, toolTip: 'D1M',
           icon: Icons.favorite, iconSize: iconSize2, width: 48, height: 36,
            iconColor: isFavorited ? Theme.of(context).customIconHighlightedColor3 : Theme.of(context).customIconColor1, count: favCount.toString(),
          ),
          const SizedBox(width: 8),
          ReactionButton(onPressed: _incrementCounter, colorVal: Theme.of(context).customTransparentColor, toolTip: 'BookMark',
            icon: Icons.chat_bubble, iconSize: iconSize2, width: 48, height: 36, iconColor: Theme.of(context).customIconColor1,
            count: widget.tweet.chat_count,
          ),
          const Expanded(child: SizedBox()),
          ReactionButton(onPressed: _incrementCounter, colorVal: Theme.of(context).customTransparentColor, toolTip: 'Setting',
            icon: Icons.bookmark, iconSize: iconSize2, width: 48, height: 36, iconColor: Theme.of(context).customIconInvertColor1,
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
