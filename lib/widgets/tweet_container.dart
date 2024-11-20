import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'async/async_img.dart';
import 'floating_button.dart';

class tweetContainer extends StatefulWidget {
  const tweetContainer({super.key});

  @override
  State<tweetContainer> createState() => _tweetContainerState();
}

class _tweetContainerState extends State<tweetContainer> {

  void _incrementCounter() {
      print('hello');
  }

  @override
  Widget build(BuildContext context) {return InkWell(
    onTap: () {
      print('hello');
    },
    splashColor: Colors.transparent, // 물결 효과 제거
    highlightColor: Colors.transparent, // 강조 효과 제거
    onHover: (isHovering) {
      print(isHovering ? 'Hovering' : 'Not Hovering'); // 디버깅용 출력
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

  Widget _buildMainTweetSection(BuildContext context) {
    return  Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top:9, bottom: 4, left: 4, right: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              child:
                  const InkWell(
                    child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage("https://static.animecorner.me/2021/01/Yuru-Camp-1-3.jpg")
                    ),
                  ),
            ),
            const SizedBox(height : 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  children: [
                    Row(
                        children: [
                          Text('Rin Shima', style: TextStyle(color: Theme.of(context).customTextColor1, fontSize: fontSize4)),
                          SizedBox(width: 8),
                          Text('@Shima_Ring', style: TextStyle(color: Theme.of(context).customTextColor2, fontSize: fontSize4)),
                          Expanded(child: SizedBox()),
                          Text('16, Nov', style: TextStyle(color: Theme.of(context).customTextColor2, fontSize: fontSize4)),
                        ]
                    ),
                    SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).customBackgroundColor2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('What a great View !! #camping', style: TextStyle(color: Theme.of(context).customTextColor2, fontSize: fontSize2),),
                            SizedBox(height: 8),
                            const AsyncDynamicHeightContainer(
                              key: ValueKey('unique_key'),
                              imgUrl: "https://static.animecorner.me/2021/01/Yuru-Camp-1-6-1024x576.jpg"
                            ),

                          ],
                        ),

                      ),

                  ],
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
