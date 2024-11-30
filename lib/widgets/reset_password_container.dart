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


class ResetPasswordContainer extends StatefulWidget {
  const ResetPasswordContainer({super.key});

  @override
  State<ResetPasswordContainer> createState() => _ResetPasswordContainerState();
}

class _ResetPasswordContainerState extends State<ResetPasswordContainer> {
  var formKey = GlobalKey<FormState>();
  var formKey1 = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var currentPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  var reEnterPasswordController = TextEditingController();

  bool isLoading = true;
  bool isFollowing = false;
  bool isValidatePW = false;
  bool changedPW = false;
  User? getUser;

  List<User?> users = [];
  User? userInfo;

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
      User? fetchedUser = await LoadUserInfo.loadUserInfo(currentUserInfo.user_uid ?? -5);
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
      List<FollowUser> fetchedFollowingInfo = await LoadUserInfo.loadFollowingInfo(currentUserInfo.user_uid ?? -5);
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

  verifyPassword() async{
    try{
      print("3");
      var res = await http.post(
          Uri.parse(API.validatePassword),
          body: {
            'user_uid' : currentUserInfo.user_uid.toString(),
            'user_password' : currentPasswordController.text.trim(),
          });

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        var responseBody = jsonDecode(res.body);
        
        if(responseBody['success'] == true){

          setState(() {
            currentPasswordController.clear();
            isValidatePW = true;
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

  changePassword() async{
    try{
      print("3");
      var res = await http.post(
          Uri.parse(API.changePassword),
          body: {
            'user_uid' : currentUserInfo.user_uid.toString(),
            'user_password' : passwordController.text.trim(),
          });

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        var responseBody = jsonDecode(res.body);

        if(responseBody['success'] == true){

          setState(() {
            passwordController.clear();
            reEnterPasswordController.clear();
            isValidatePW = false;
            changedPW = true;
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
        _buildNoUserSection()
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
    return  SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40,),
          const Text(
              'Change Password',
            style: TextStyle(
              fontSize: fontSize6
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            constraints: BoxConstraints(
                minWidth: 210
            ),
            width: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1
                          ),
                          borderRadius: BorderRadius.circular(24),
                          color: isValidatePW ? Theme.of(context).customBackgroundColor2 : Theme.of(context).customBackgroundColor1,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: currentPasswordController,
                            validator: (val) =>
                            val == "" ? isValidatePW ? null : "Please enter current password" : null,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: isValidatePW ? 'Verified' : 'Current password'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Form(
                  key:formKey1,
                  child: Column(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 1
                            ),
                            borderRadius: BorderRadius.circular(24),
                          color: isValidatePW ? Theme.of(context).customBackgroundColor1 : Theme.of(context).customBackgroundColor2,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: passwordController,
                            validator: (val) =>
                            val == "" ? "Please enter password" : null,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Password'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 1
                            ),
                            color: isValidatePW ? Theme.of(context).customBackgroundColor1 : Theme.of(context).customBackgroundColor2,
                            borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: reEnterPasswordController,
                            validator: (val) =>
                            val == "" ? "Please enter password" : null,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Re Enter Password'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(formKey.currentState!.validate() || !isValidatePW){
                            verifyPassword();
                          }
                          if(isValidatePW){
                            changePassword();
                          }
                        },
                        child: Container(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).customIconHighlightedColor3,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                isValidatePW ? changedPW ? 'Changed!' : 'Change Password' : 'Verify Current Password',
                                style: TextStyle(
                                    color: Theme.of(context).customIconColor1,
                                    fontSize: fontSize3,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
