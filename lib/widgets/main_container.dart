import 'package:contact1313/theme/size.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'floating_button.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {

  void _incrementCounter() {
    setState(() {
      print('hello');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 603,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
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
            onPressed:_incrementCounter, colorVal: iconBackgroundColor1, toolTip :'Upload Picture',
            icon: Icons.photo, iconSize: iconSize2, height: 24, width: 48,iconColor: iconColor1,
          ),
          const SizedBox(width: 8),
          FloatingButton(
            onPressed:_incrementCounter, colorVal: iconBackgroundColor1, toolTip :'Share Location',
            icon: Icons.location_on_sharp, iconSize: iconSize2, height: 24, width: 48,iconColor: iconColor1,
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
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage("https://static.animecorner.me/2021/01/Yuru-Camp-1-3.jpg")
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Text(
                      'What\'s Happening?',
                      style: TextStyle(
                        color: textColor2,
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
                        onPressed:_incrementCounter, colorVal: iconBackgroundColor1, toolTip :'Upload Tweet',
                        icon: Icons.upload, iconSize: iconSize2, height: 27, width: 96,iconColor: iconColor1,
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
      color: lineColor1,
    );
  }

}
