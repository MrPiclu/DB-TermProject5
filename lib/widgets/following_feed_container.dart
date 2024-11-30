import 'dart:convert';

import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/followUser.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import '../tweet/tweet_pref.dart';
import '../tweet/user_pref.dart';
import 'async/async_img.dart';
import 'circular_profile.dart';
import 'dialog_container.dart';
import 'tweet_container.dart';
import '../theme/colors.dart';
import 'floating_button.dart';

class FollowingFeedContainer extends StatefulWidget {
  const FollowingFeedContainer({super.key});

  @override
  State<FollowingFeedContainer> createState() => _FollowingFeedContainerState();
}

class _FollowingFeedContainerState extends State<FollowingFeedContainer> {
  final GlobalKey _buttonKey = GlobalKey(); // 특정 위젯을 찾기 위한 GlobalKey
  var formKey = GlobalKey<FormState>();
  var formKey1 = GlobalKey<FormState>();
  var tweetContentController = TextEditingController();
  var tweetPictureUploadController = TextEditingController();
  bool isOpenedOverlay = false;
  bool hasImg = false;
  String? ImgUrl;
  bool _isLoading = true;
  User? getUser;

  List<Tweet?> tweets = [];
  User? userInfo;
  List<User?> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllData();
    print("yess!!");
  }

  Future<void> loadAllData() async {
    await _loadFollowingInfo();   // 세 번째 함수 실행
    await fetchUserTweets();
    setState(() {
      _isLoading = false;
    });
  }

  void _redirectPage(String location) {
    context.go(location);
  }

  _uploadTweet() async{
    try{
      print("3");
      var res = await http.post(
          Uri.parse(API.uploadTweet),
          body: {
            'tweet_id' : 18.toString(),
            'body' : tweetContentController.text.trim(),
            'user_uid' : currentUserInfo.user_uid.toString(),
            'media_url' : ImgUrl.toString(),
            'media_type' : 'image',
          });

      print("3");

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        var resLogin = jsonDecode(res.body);
        if(resLogin['success'] == true){
          setState(() {
            tweetContentController.clear();
            hasImg = false;
            ImgUrl = null;
          });
        }else{
          // Fluttertoast.showToast(msg: 'Error occurred.');
          print("Erorr login");
        }
        print('yes');
      }
    }catch(e){
      print('saveInfo Catched');
      print(e.toString());
      // Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> fetchUserTweets() async {
    try {
      List<Tweet?> allTweets = []; // 모든 트윗을 저장할 리스트
      int totalTweets = 0;

      for (int i = 0; i < users.length; i++) {
        if (users[i]?.user_uid == null) continue; // 유저 UID가 없으면 스킵

        try {
          // 각 유저의 트윗 가져오기
          List<Tweet> fetchedTweets = await RememberTweet.loadTweets(users[i]?.user_uid ?? -5);

          print('${users[i]?.user_name} + 시');
          print('${fetchedTweets.length} 길이 ㄷㄷ');

          for(int k = 0; k < fetchedTweets.length; k++){
            // 가져온 트윗을 `allTweets`에 추가
            allTweets.add(fetchedTweets[k]);
          }
          totalTweets += fetchedTweets.length;

          print("현재 총 트윗 수: $totalTweets");
        } catch (e) {
          print('Error fetching tweets for user ${users[i]?.user_name}: $e');
        }
      }

      // 트윗을 created_at을 기준으로 정렬
      allTweets.sort((a, b) {
        final aDate = DateTime.parse(a?.created_at);
        final bDate = DateTime.parse(b?.created_at);
        return bDate.compareTo(aDate); // 최신순 정렬
      });

      // 트윗을 상태로 저장하고 로딩 상태 변경
      setState(() {
        tweets = allTweets; // 모든 트윗 저장
        _isLoading = false; // 로딩 상태 해제
      });
    } catch (e) {
      print('Error fetching tweets: $e');
      setState(() {
        _isLoading = false; // 에러 발생 시 로딩 상태 해제
      });
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
      List<FollowUser> fetchedFollowingInfo = await LoadUserInfo.loadFollowingInfo(currentUserInfo.user_uid ?? -5);
      if(!mounted) return;

      print("Loading Follow Info....");
      users = List<User?>.filled(fetchedFollowingInfo.length, null);

      print("Loading Follow Info....");
      for(int i = 0; i < fetchedFollowingInfo.length; i++){
        await loadFollowingUser(fetchedFollowingInfo[i].following_user_uid);
        print("${getUser!.user_name} + 아이고난");
        users[i] = getUser;
      };

    }catch(e){
      print("아이고난맨");
      print(e.toString());
    }
  }

  void toggleOverlay() {
    print(isOpenedOverlay);
      setState(() {
        isOpenedOverlay ? removeOverlay() : addOverlay();
        isOpenedOverlay = !isOpenedOverlay;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 603,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: tweets.isEmpty ? 2 : tweets.length + 2, //프로필과 실선(경계선) + 트윗 수
          itemBuilder: (BuildContext ctx, int idx){
            return _isLoading
                ? Center(
                    child: Container(
                        width: 603,
                        child: CircularProgressIndicator()
                    ),
                  )
                : idx == 0 ? _buildMainUploadSection(context)
                : idx == 1 ? _buildSolidLine(1.0)
                : tweetContainer(tweet: tweets[idx - 2]!);
          }
      )
    );
  }

  Widget _buildIconRow() {
    return Stack(

      children:[
        Row(
          children: [
            FloatingButton(
              key: _buttonKey,
              onPressed: () {
                addOverlay();
              }, colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'Uploa1d Picture',
              icon: Icons.photo, iconSize: iconSize2, height: 24, width: 48,iconColor: hasImg ?  Colors.redAccent : Theme.of(context).customIconColor1,
            ),
            const SizedBox(width: 8),
            FloatingButton(
              onPressed:(){
                removeOverlay();
              }, colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'Share Location',
              icon: Icons.location_on_sharp, iconSize: iconSize2, height: 24, width: 48,iconColor: Theme.of(context).customIconColor1,
            ),
          ]
      ),

      ]
    );
  }

  final overlays = <OverlayEntry>[];

  void addOverlay(){
    if(overlays.length > 0){
      removeOverlay();
    }else{
      overlays.add(overlayEntry);
      Overlay.of(context).insert(overlays.last);
    }
  }

  void removeOverlay(){
    if(overlays.isNotEmpty) overlays.removeLast().remove();
    setState(() {
      tweetPictureUploadController.clear();
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
                    top: offset.dy + size.height, // 버튼 바로 아래에 위치
                    left: offset.dy - size.width / 2 , // 버튼의 왼쪽 정렬
                    child: Container(
                      height: hasImg ? 300 : _isSearchingImg ? 300 : 120,
                      width: 210,
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
                            hasImg ? SizedBox() :
                            Form(
                              key: formKey,
                              child:
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextFormField(
                                      controller: tweetPictureUploadController,
                                      validator: (val) =>
                                      val == "" ? "Please enter" : null,
                                      onChanged: (val) {
                                        setState(() {
                                          _hasText = val.isNotEmpty;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none, hintText: 'Enter Image Url..',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).customTextColor2,
                                            fontSize: fontSize2,
                                            fontFamily: 'ABeeZee',
                                          )
                                      ),
                                    )
                                ),
                              ),
                            ),
                            Expanded(
                                child:
                                    hasImg ?
                                      AsyncDynamicHeightContainer(
                                        key: ValueKey(ImgUrl),
                                          imgUrl: ImgUrl!,
                                          errorNotifier : errorNotifier)
                                : _hasText && _isSearchingImg ?
                                AsyncDynamicHeightContainer(
                                    key: ValueKey(ImgUrl),
                                    imgUrl: ImgUrl!,
                                    errorNotifier : errorNotifier)
                                    : SizedBox(),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: errorNotifier,
                              builder: (context, hasError, child){
                                return
                                  FloatingButton(
                                    onPressed:(){
                                      _hasText ?
                                        hasImg ?
                                        setState(() {
                                            removeOverlay();
                                            ImgUrl = null;
                                          _isSearchingImg = false;
                                          hasImg = false;
                                        })
                                        : setState(() {
                                          ImgUrl = tweetPictureUploadController.text.toString();
                                          print(hasError);
                                          print(_isSearchingImg);
                                          print(hasImg);
                                          hasImg = hasError ? false : _isSearchingImg ? true : false;
                                          _isSearchingImg = true;
                                          hasImg ? {
                                            removeOverlay(),
                                          } : null;
                                        })
                                      :
                                      setState(() {
                                        removeOverlay();
                                        ImgUrl = null;
                                        _isSearchingImg = false;
                                        hasImg = false;
                                      });
                                    }, colorVal: Theme.of(context).customTransparentColor, toolTip :'Share Lo1ca1tion',
                                    icon: hasError ? Icons.search : hasImg ? Icons.close : Icons.check, iconSize: iconSize2, height: 30, width: 210,iconColor: _hasText ? Theme.of(context).customIconColor1 : Theme.of(context).customIconInvertColor1,
                                  );
                              },
                            )
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

  Widget _buildMainUploadSection(BuildContext context) {
    return  Container(
        width: double.infinity,
        height: 119,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child:
              Row(
                children: [
                  CircularProfile(onPressed: (){
                    _redirectPage(
                        "/${currentUserInfo.user_uid}/profile");
                    dispose();
                    },
                    strokeRadius: 0,
                    radius: 25,
                    userInfo: currentUserInfo,
                  ),
                  const SizedBox(width: 13),
                  Form(
                    key: formKey1,
                    child:
                    Expanded(
                      child: TextFormField(
                        controller: tweetContentController,
                        validator: (val) =>
                        val == "" ? "Please enter" : null,
                        decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'What\'s Happening',
                          hintStyle: TextStyle(
                                color: Theme.of(context).customTextColor2,
                                fontSize: fontSize2,
                                fontFamily: 'ABeeZee',
                              )
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height : 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 2, left: 14, right: 6, bottom: 2),
                child: Row(
                    children: [
                      const SizedBox(width: 45,),
                      _buildIconRow(),
                      Expanded(child: Container()),
                      FloatingButton(
                        onPressed:_uploadTweet, colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'Upload Tweet',
                        icon: Icons.upload, iconSize: iconSize2, height: 27, width: 96,iconColor: Theme.of(context).customIconColor2, //글을 적으면 iconColor1으로 변경됨
                      ),
                    ]
                ),
              ),
            )
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
