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
          _buildTextButton(Icons.add,'New DM', textColor2),
          const SizedBox(height: 8),
          _buildTextButton(Icons.add_task_sharp, 'hong_gildong13', textColor1),
          const SizedBox(height: 8),
          _buildTextButton(Icons.add_task_sharp, 'hun_i22', textColor1),
          const SizedBox(height: 8),
          _buildTextButton(Icons.add_task_sharp, 'Shima_Ring', textColor1),
          _buildIconRowForDarkMode(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
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
                fontSize: fontSize1,
                fontFamily: 'ABeeZee',
              ),
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
                  fontSize: fontSize1,
                  fontFamily: 'ABeeZee',
                ),
              ),
          ),
          const SizedBox(height: 2),
          _buildListItem('Recommend'),
          const SizedBox(height: 2),
          _buildListItem('Following'),
          const SizedBox(height: 2),
          _buildFavoriteSection(),
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Container(
      padding: const EdgeInsets.only(
        top: 3,
        left: 5,
        right: 5,
        bottom: 3,
      ),
      child: Row(
        children: [
          const FlutterLogo(size: iconSize2),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor1,
              fontSize: fontSize2,
              fontFamily: 'ABeeZee',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteSection() {
    return Column(
      children: [
        _buildListItem('Favorite'),
        const SizedBox(height: 2),
        _buildSubListItem('@Gachon'),
        _buildSubListItem('@Foods'),
      ],
    );
  }

  Widget _buildSubListItem(String text) {
    return Container(
      width: 174,
      height: 24,
      padding: const EdgeInsets.only(top: 8, left: 32, right: 8, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 20,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontFamily: 'ABeeZee',
                  fontWeight: FontWeight.w400,
                  height: 0.20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolidLine(double radius){
    return Container(
      width: 174,
      height: radius,
      color: Colors.white38,
    );
  }

  Widget _buildTextButton(IconData icon,String text, Color colorVal){
    return Container(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          // 버튼 동작
        },
        icon: Icon(icon, size: 22, color: colorVal), // "+" 버튼
        label: Text(
          text,
          style: TextStyle(
            fontSize: 15,
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
}
