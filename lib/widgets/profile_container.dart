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
import '../model/followUser.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import '../tweet/user_pref.dart';
import '../user/user_pref.dart';
import 'circular_profile.dart';
import 'following_info_container.dart';
import 'tweet_container.dart';
import '../theme/colors.dart';
import 'floating_button.dart';
import 'package:http/http.dart' as http;


class ProfileContainer extends StatefulWidget {
  final  int userUid;
  const ProfileContainer({super.key, required this.userUid});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  final GlobalKey _buttonKey = GlobalKey(); // 특정 위젯을 찾기 위한 GlobalKey
  var changePasswordController = TextEditingController();

  bool isLoading = true;
  bool isFollowing = false;
  int follower = 0;
  int following = 0;
  @override

  List<Tweet> tweets = [];
  User? userInfo;

  var formKey = GlobalKey<FormState>();
  var userNameController = TextEditingController();
  var userIdController = TextEditingController();

  bool isInEditMode = false;
  bool isOpenedOverlay = false;


  void initState() {
    super.initState();
    // TODO: implement initState\
    loadAllData();
  }

  Future<void> loadAllData() async {
    await loadFollowInfo();   // 세 번째 함수 실행
    await fetchUserTweets();  // 첫 번째 함수 완료 후
    await loadUserInfo();
    await _loadFollowCount();
  }

  Future<void> loadUserInfo() async{
    print("Entered load user info in profile container");
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

  Future<void> fetchUserTweets() async {
    print("Entered in fetch User Tweets in profile_container");
    try {
      List<Tweet> fetchedTweets = await RememberTweet.loadTweets(widget.userUid ?? -5);
      if(!mounted) return;
      setState(() {
        tweets = fetchedTweets; // 가져온 데이터를 상태에 저장
        isLoading = false; // 로딩 상태 변경
      });
    } catch (e) {
      setState(() {
        isLoading = false; // 로딩 상태 변경
      });
    }
  }

  Future<void> loadFollowInfo() async{
    try{
      print("Loading Follow Info....");
      if(!mounted) return;
      setState(() async {
        bool fetchedFollowingInfo = await LoadUserInfo.loadFollowInfo(widget.userUid ?? -5);
        isFollowing = fetchedFollowingInfo;
        print("|||${isFollowing}");
        isLoading = false;
      });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _follow() async{
    print("entered in follow");
    try{
      var res = await http.post(
          Uri.parse(API.follow),
          body: {
            'followed_user_uid' : currentUserInfo.user_uid.toString(), // 팔로우를 건 사람
            'following_user_uid' : userInfo!.user_uid.toString(), // 팔로우를 당한 사람
          });
      print("Following: ");
      print(res.statusCode);
      print(res.body);
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _unFollow() async{
    try{
      var res = await http.post(
          Uri.parse(API.unFollow),
          body: {
            'followed_user_uid' : currentUserInfo.user_uid.toString(), // 팔로우를 건 사람
            'following_user_uid' : userInfo!.user_uid.toString(), // 팔로우를 당한 사람
          });

      print("UnFollowing: ");
      print(currentUserInfo.user_uid);
      print(userInfo!.user_uid);
      print(res.statusCode);
      print(res.body);
    }catch(e){
      print(e.toString());
    }

  }

  Future<void> _loadFollowCount() async{
    try{
      print("Loading Follow Info.... 15152");
      List<FollowUser> fetchedFollowingInfo = await LoadUserInfo.loadFollowingInfo(widget.userUid ?? -5);
      List<FollowUser> fetchedFollowerInfo = await LoadUserInfo.loadFollowerInfo(widget.userUid ?? -5);
      print("are you fdone?");
      if(!mounted) null;
      setState(() {
        following = fetchedFollowingInfo.length;
        follower = fetchedFollowerInfo.length;
      });
    }catch(e){
      print(e.toString());
    }
    return null;

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
                itemCount: tweets.isEmpty ? 2 : tweets.length + 2, //프로필과 실선(경계선) + 트윗 수
                  itemBuilder: (BuildContext ctx, int idx){
                    return isLoading
                        ? Center(
                      child: Container(
                          width: 603,
                      ),
                    )
                    : idx == 0 ? _buildProfileSection()
                      : idx == 1 ? _buildSolidLine(1.0)
                          : tweetContainer(tweet: tweets[idx - 2], key: ValueKey(tweets[idx - 2].id),);
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

  Widget _buildProfileSection(){
    return  SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
            },
            splashColor: Colors.transparent, // 물결 효과 제거
            highlightColor: Colors.transparent, // 강조 효과 제거
            onHover: (isHovering) {
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
                      const Expanded(
                        child: SizedBox(),
                      ),
                      CustomTextButton(
                        key: _buttonKey,
                          onPressed: (){
                              currentUserInfo.user_uid == userInfo?.user_uid
                                ? addOverlay()
                                : setState(() {
                                isFollowing ? _unFollow() : _follow();
                                isFollowing = !isFollowing;
                              });
                          },
                          width: 110,
                          height: 36,
                          text: currentUserInfo.user_uid == userInfo?.user_uid ? "Edit" : isFollowing ? "Following" : "Follow",
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
                    CircularProfile(onPressed: (){},radius: 70,userInfo: userInfo, strokeRadius: 5,)
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
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         userInfo?.user_name ?? "Guest1",
                        style: TextStyle(
                          color: Theme.of(context).customTextColor1,
                          fontSize: fontSize5,
                          fontFamily: 'ABeeZee',
                        ),
                      ),
                      Text(
                        '@${userInfo?.user_id ?? "Guest1"}',
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
                        // userInfo?.user_email ?? 'none',
                        isFollowing ? 'true' : 'false',
                        style: TextStyle(
                          color: Theme.of(context).customTextColor1,
                          fontSize: fontSize2,
                          fontFamily: 'ABeeZee',
                        ),
                      ),
                      Text(
                        'Join in ${userInfo?.created_at ?? "2024-11-11"}',
                        style: TextStyle(
                          color: Theme.of(context).customTextColor2,
                          fontSize: fontSize2,
                          fontFamily: 'ABeeZee',
                        ),
                      ),
                      Row(
                        children: [
                          CustomTextButton(
                            onPressed: (){
                              print("Button Clicked!!!");
                              setState(() {
                                _redirectPage("/${userInfo?.user_uid}/followers");
                              });
                            },
                            text : "${follower} Followers",
                            fontSize: fontSize2,
                            boxDecoration: BoxDecoration(
                                color: Colors.transparent
                            ),
                          ),
                          CustomTextButton(
                            onPressed: (){
                              print("Button Clicked!!!");
                              setState(() {
                                _redirectPage("/${userInfo?.user_uid}/following");
                              });
                            },
                            text : "${following} Following",
                            fontSize: fontSize2,
                            boxDecoration: BoxDecoration(
                                color: Colors.transparent
                            ),
                          ),
                        ],
                      )
                    ],

                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          )
        ],
      ),
    );
  }

  void toggleOverlay() {
    print(isOpenedOverlay);
    setState(() {
      isOpenedOverlay ? removeOverlay() : addOverlay();
      isOpenedOverlay = !isOpenedOverlay;
    });
  }

  final overlays = <OverlayEntry>[];

  void addOverlay(){
    if(overlays.length > 1){
      removeOverlay();
    }else{
      overlays.add(overlayEntry);
      Overlay.of(context).insert(overlays.last);
    }
  }


  void removeOverlay(){
    if(overlays.isNotEmpty) overlays.removeLast().remove();
    setState(() {

    });
  }

  OverlayEntry get overlayEntry{
    final ValueNotifier<bool> errorNotifier = ValueNotifier<bool>(false);
    final RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    bool _hasText = false;
    bool _isSearchingImg = false;
    bool _isSearchSuccess = false;



    return OverlayEntry(
        opaque: false,
        builder: (context){

          return StatefulBuilder(
              builder: (context, setState){
                return  Stack(
                  children: [
                    // GestureDetector로 바깥 클릭 시 오버레이 닫기
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          removeOverlay();
                        },
                      ),
                    ),
                    Positioned(
                      top: offset.dy + size.height + 15, // 버튼 바로 아래에 위치
                      left: offset.dy + size.width / 2 + 70, // 버튼의 왼쪽 정렬
                      child: Container(
                        width: 165,
                        decoration: BoxDecoration(
                            color: Theme.of(context).customBackgroundColor1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: lineColor1,
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextButton(
                                onPressed: (){
                                  print("Button Clicked!!!");
                                },
                                text : "Change Profile",
                                fontSize: fontSize2,
                                boxDecoration: BoxDecoration(
                                    color: Colors.transparent
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextButton(
                                onPressed: (){
                                  print("Button Clicked!!!");
                                  setState(() {
                                    _redirectPage("/resetPassword");
                                    removeOverlay();
                                  });
                                },
                                text : "Change Password",
                                fontSize: fontSize2,
                                boxDecoration: BoxDecoration(
                                    color: Colors.transparent
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
          );
        }
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
