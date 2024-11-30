import 'dart:convert';

import 'package:contact1313/theme/colors.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:contact1313/authentication/signup.dart';

import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../my_app.dart';
import '../model/user.dart';
import '../theme/size.dart';
import '../user/user_pref.dart';
import '../widgets/floating_button.dart';

User currentUserInfo = RememberUser.getRememberUserInfo() as User; // 전역 변수 선언

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  bool _isLightMode = false;

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<User?> _loadCurrentUserInfo() async{
    User? savedUserInfo = await RememberUser.getRememberUserInfo();
    // 유저 정보 불러오기
    if (savedUserInfo != null) {
      setState(() {
        currentUserInfo = savedUserInfo;
      });
    } else {
      print("저장된 유저 정보가 없습니다.");
    }
    return null;
  }

  userLogin() async{
      try{
        print("3");
        var res = await http.post(
            Uri.parse(API.login),
            body: {
              'user_email' : emailController.text.trim(),
              'user_password' : passwordController.text.trim(),
            });


        print(res.statusCode);
        print(res.body);

        if(res.statusCode == 200){
          print('yes');
          var resLogin = jsonDecode(res.body);
          print('yes');
          if(resLogin['success'] == true){
            print('yes');
            // Fluttertoast.showToast(msg: 'Signup successfully');
            print(resLogin['userData']);
            User userInfo = User.fromJson(resLogin['userData']);
            print('yes');

            print("login success");

            await RememberUser.saveRememberUserInfo(userInfo); //로그인된 유저 정보를 로컬 저장소에 저장

            print("stored success");

            Get.to(const MyApp());
            print("stored success");

            setState(() {
              emailController.clear();
              passwordController.clear();
              _loadCurrentUserInfo();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).customBackgroundColor2,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(child: Container()),
            Container(
              color: Theme.of(context).customBackgroundColor1,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello,',
                      style: TextStyle(fontSize: fontSize8, color: textColor2),
                    ),
                    Text(
                      'Welcome back',
                      style: TextStyle(fontSize: fontSize6, color: textColor2),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 210
                      ),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextFormField(
                                  controller: emailController,
                                  validator: (val) =>
                                  val == "" ? "Please enter email" : null,
                                  decoration: InputDecoration(
                                      border: InputBorder.none, hintText: 'Email'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
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
                            GestureDetector(
                              onTap: (){
                                if(formKey.currentState!.validate()){
                                  userLogin();
                                  print("triggered");
                                }
                              },
                              child: Container(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).customIconBackgroundColor1,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Text(
                                      'Sign in',
                                      style: TextStyle(
                                          color: Theme.of(context).customIconColor1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Not a member?',
                                  style: TextStyle(
                                    color: Theme.of(context).customTextColor1,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(() => SignupPage()),
                                  child: Text(
                                    ' Register Now!',
                                    style: TextStyle(
                                        color: Colors.blue, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
