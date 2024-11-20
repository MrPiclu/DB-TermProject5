import 'package:contact1313/theme/size.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'floating_button.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({super.key});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {

  void _incrementCounter() {
    setState(() {
      print('hello');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGround1,
      width: 210,
      height: 1200,
      padding: const EdgeInsets.only(
        top: 12,
        left: 8,
        right: 28,
        bottom: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSearchBar(context),
          const SizedBox(height: 8),
          _buildIconRow(),
          const SizedBox(height: 8),
          _buildListSection(),
          const SizedBox(height: 8),
          _buildSolidLine(1.0),
          const SizedBox(height: 8),
          _buildTextButton(Icons.add,'New DM', textColor2, iconSize3),
          const SizedBox(height: 8),
          _buildTextButton(Icons.mail_outline, 'hong_gildong13', textColor1, iconSize3),
          const SizedBox(height: 8),
          _buildTextButton(Icons.mail_outline, 'hun_i22', textColor1, iconSize3),
          const SizedBox(height: 8),
          _buildTextButton(Icons.mail_outline, 'Shima_Ring', textColor1, iconSize3),
          _buildIconRowForDarkMode(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return InkWell(
      onTap: (){print('hello');},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 10,
          left: 14,
          right: 6,
          bottom: 10,
        ),
        decoration: ShapeDecoration(
          color: backGround2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, size: iconSize2, color: iconColor1,),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                'Search',
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
    );
  }

  Widget _buildIconRow() {
    return Row(
        children: [
          FloatingButton(
              onPressed:_incrementCounter, colorVal: iconBackgroundColor1, toolTip :'DM',
              icon: Icons.send_rounded, iconSize: iconSize2, height: 48, width: 52,iconColor: iconColor1,
          ),
          const SizedBox(width: 8),
          FloatingButton(
              onPressed:_incrementCounter, colorVal: iconBackgroundColor1, toolTip :'BookMark',
              icon: Icons.bookmark, iconSize: iconSize2, height: 48, width: 52,iconColor: iconColor1,
          ),
          const SizedBox(width: 8),
          FloatingButton(
              onPressed:_incrementCounter, colorVal: iconBackgroundColor1, toolTip :'Setting',
              icon: Icons.more_horiz, iconSize: iconSize2, height: 48, width: 52,iconColor: iconColor1,
          ),
        ]
    );
  }

  Widget _buildIconRowForDarkMode() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingButton(
                onPressed:_incrementCounter, colorVal: iconBackgroundColor1, toolTip :'Dark Mode',
                icon: Icons.wb_sunny_outlined, iconSize: iconSize1, height: 24, width: 24, iconColor: iconColor1,
            ),
            const SizedBox(width: 4),
            FloatingButton(
                onPressed:_incrementCounter, colorVal: iconBackgroundColor1, toolTip :'Light Mode',
                icon: Icons.nightlight_round, iconSize: iconSize1, height: 24, width: 24, iconColor: iconColor1,
            ),
          ]
      ),
    );
  }

  Widget _buildListSection() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 6,
              left: 8,
              right: 12,
              bottom: 2,
            ),
            child:
              Text(
                'Home',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: fontSize2,
                  fontFamily: 'ABeeZee',
                ),
              ),
          ),
          const SizedBox(height: 2),
          _buildTextButton(Icons.recommend,'Recommend', textColor1, iconSize2),
          const SizedBox(height: 2),
          _buildTextButton(Icons.people,'Following', textColor1, iconSize2),
          const SizedBox(height: 2),
          _buildFavoriteSection(),
        ],
      ),
    );
  }

  Widget _buildFavoriteSection() {
    return Column(
      children: [
        _buildTextButton(Icons.favorite,'Favorite', textColor1, iconSize2),
        _buildSubListItem('Gachon'),
        _buildSubListItem('Foods'),
      ],
    );
  }

  Widget _buildSubListItem(String text) {
    return Container(
      width: double.infinity,
      height: 24,
      padding: const EdgeInsets.only(top: 0, left: 28, right: 8, bottom: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildSideTextButton(Icons.favorite, text, textColor1, iconSize1),
          ),
        ],
      ),
    );
  }

  Widget _buildSolidLine(double radius){
    return Container(
      width: double.infinity,
      height: radius,
      color: Colors.white38,
    );
  }

  Widget _buildTextButton(IconData icon,String text, Color colorVal, double iconSize){
    return Container(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            // 버튼 동작
          },
          icon: Icon(icon, size: iconSize, color: colorVal), // "+" 버튼
          label: Text(
            text,
            style: TextStyle(
              fontSize: fontSize3,
              color: colorVal,
            ),
          ),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
            padding: const EdgeInsets.symmetric(horizontal: 8), // 패딩 조절
          ),
        )
    );
  }

  Widget _buildSideTextButton(IconData icon,String text, Color colorVal, double iconSize){
    return Container(
        width: double.infinity,
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () {
                // 버튼 동작
              },
              label: Text(
                '@ ' + text,
                style: TextStyle(
                  fontSize: fontSize1,
                  color: colorVal,
                  fontFamily: 'ABeeZee',
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
                padding: const EdgeInsets.symmetric(horizontal: 8), // 패딩 조절
              ),
            ),
          ],
        )
    );
  }

}
