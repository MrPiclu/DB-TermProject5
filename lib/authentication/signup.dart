import 'dart:convert';

import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../api/api.dart';
import '../model/user.dart';
import '../theme/colors.dart';
import '../theme/size.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var formKey = GlobalKey<FormState>();

  var userIdController = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool _validateEmail = true;
  checkUserEmail() async{
    try{
      var response = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'user_email' : emailController.text.trim()
        }
      );

      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
        var responseBody = jsonDecode(response.body);

        if(responseBody['existEmail'] == true){
          // Fluttertoast.showToast(msg: "Email is already in use.");
          print("Email is using");
          setState(() {
            _validateEmail = false;
          });
        }else{
          print("Email is not using now");
          setState(() {
            _validateEmail = true;
          });

          // Fluttertoast.showToast(msg: "Email is good.");
          saveInfo();
          print("save info suc");
        }
      }
    }catch(e){
      print('checkUser Catched');
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

    }
  }

  saveInfo() async{
    print("1");
    User userModel = User(
      user_uid: null,
      user_id: userIdController.text.trim(),
      user_name: userNameController.text.trim(),
      profile_image_url: "https://figurefactories.com/cdn/shop/products/Guest_3-155115.jpg?v=1710251432",
      user_email: emailController.text.trim(),
      user_password: passwordController.text.trim()
    );
    print("2");

    try{
      print("3");
      var res = await http.post(
          Uri.parse(API.signup),
          body: userModel.toJson()
      );
      print("4");

      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200){
        var resSignup = jsonDecode(res.body);
        if(resSignup['success'] == true){
          // Fluttertoast.showToast(msg: 'Signup successfully');
          print("signup success");
          setState(() {
            userIdController.clear();
            userNameController.clear();
            emailController.clear();
            passwordController.clear();
          });

        }else{
          // Fluttertoast.showToast(msg: 'Error occurred.');
          print("Erorr ");

        }
      }
      print("5");
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
                    'Sign Up',
                    style: TextStyle(fontSize: fontSize8, color: textColor2),
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
                                  controller: userIdController,
                                  validator: (val) =>
                                  val == "" ? "Please enter userID " : null,
                                  decoration: InputDecoration(
                                      border: InputBorder.none, hintText: 'UserID'),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: userNameController,
                                validator: (val) =>
                                val == "" ? "Please enter username " : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'UserName'),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: passwordController,
                                validator: (val) =>
                                val == "" ? "Please enter password" : null,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if(formKey.currentState!.validate()){
                                checkUserEmail();
                                print("triggered");
                              }

                            },
                            child: Container(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Text(
                                    _validateEmail ? 'Sign Up' : 'Email is already in use.',
                                    style: TextStyle(
                                        color: Colors.white,
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
                              Text('Already registered?'),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Text(
                                  ' Go back Login page!',
                                  style: TextStyle(
                                      color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )
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
