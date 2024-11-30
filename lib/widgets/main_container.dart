import 'dart:convert';

import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import '../tweet/tweet_pref.dart';
import 'async/async_img.dart';
import 'circular_profile.dart';
import 'dialog_container.dart';
import 'tweet_container.dart';
import '../theme/colors.dart';
import 'floating_button.dart';

List<Tweet> tweets = [];

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  final GlobalKey _buttonKey = GlobalKey(); // 특정 위젯을 찾기 위한 GlobalKey
  var formKey = GlobalKey<FormState>();
  var formKey1 = GlobalKey<FormState>();
  var tweetContentController = TextEditingController();
  var tweetPictureUploadController = TextEditingController();
  bool isOpenedOverlay = false;
  bool hasImg = false;
  String? ImgUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserTweets();
    print("yess!!");
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
            'media_url' : ImgUrl,
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
      List<Tweet> fetchedTweets = await RememberTweet.loadTweets(14);
      setState(() {
        tweets = fetchedTweets; // 가져온 데이터를 상태에 저장
      });
    } catch (e) {
      print('Error fetching tweets: $e');
      setState(() {
      });
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
      child: ListView(
        children: [
          _buildMainUploadSection(context),
          _buildSolidLine(1.0),
          tweetContainer(tweet: tweets[2]),
          tweetContainer(tweet: tweets[1]),
          tweetContainer(tweet: tweets[0]),
        ],
      ),
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
              }, colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'Upload Picture',
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
