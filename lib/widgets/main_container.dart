import 'dart:convert';

import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import 'circular_profile.dart';
import 'tweet_container.dart';
import '../theme/colors.dart';
import 'floating_button.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  var formKey = GlobalKey<FormState>();
  var tweetContentController = TextEditingController();

  void _incrementCounter() {
      print('hello');
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
            'media_url' : "https://static.animecorner.me/2021/01/Yuru-Camp-1-6-1024x576.jpg",
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
    return Container(
      width: 603,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          _buildMainUploadSection(context),
          _buildSolidLine(1.0),
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
                children: [CircularProfile(onPressed: (){}, strokeRadius: 0, radius: 25, userInfo: currentUserInfo,),
                  const SizedBox(width: 13),
                  Form(
                    key: formKey,
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
