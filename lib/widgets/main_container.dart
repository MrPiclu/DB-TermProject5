import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';

import 'tweet_container.dart';
import '../theme/colors.dart';
import 'floating_button.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {

  void _incrementCounter() {
      print('hello');
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
          tweetContainer(),
          tweetContainer(),
          tweetContainer(),
          tweetContainer(),
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
                children: [
                  CircleAvatar(
                      radius: 25,
                      //Rin : https://i.pinimg.com/736x/ab/75/af/ab75af0e6429d3b58af76f9333564c93.jpg
                      //Nadeshiko : https://preview.redd.it/despite-the-art-style-changed-nadeshiko-is-mega-cute-v0-ryv8wimm0avc1.jpeg?width=1080&crop=smart&auto=webp&s=84ab0d027219b4e73f47cbe76c80362c01eb65b4
                      backgroundImage: NetworkImage("https://preview.redd.it/despite-the-art-style-changed-nadeshiko-is-mega-cute-v0-ryv8wimm0avc1.jpeg?width=1080&crop=smart&auto=webp&s=84ab0d027219b4e73f47cbe76c80362c01eb65b4")
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      'What\'s Happening?',
                      style: TextStyle(
                        color: Theme.of(context).customTextColor2,
                        fontSize: fontSize2,
                        fontFamily: 'ABeeZee',
                      ),
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
                        onPressed:_incrementCounter, colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'Upload Tweet',
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
