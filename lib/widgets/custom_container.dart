import 'package:contact1313/my_app.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home_page.dart';
import '../theme/colors.dart';
import 'floating_button.dart';
import 'search_bar.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({super.key});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool _isLightMode = false;

  bool _isRecommend = true;
  bool _isFollowing = false;
  bool _isFavorite = false;

  void _redirectPage(String location) {
    context.go(location);
  }

  void _changeLightNightMode(){
      _isLightMode = !_isLightMode; // 현재 모드 반전
      MyApp.themeNotifier.value =
      _isLightMode ? ThemeMode.dark
          : ThemeMode.light;
    }


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
          width: 210,
          height: MediaQuery.of(context).size.height,
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
              const searchBarContainer(
                edgeInsets: EdgeInsets.only(
                  top: 10,
                  left: 14,
                  right: 6,
                  bottom: 10
                ),
                round: 10,
              ),
              const SizedBox(height: 8),
              _buildIconRow(),
              const SizedBox(height: 8),
              _buildListSection(),
              const SizedBox(height: 8),
              _buildSolidLine(1.0),
              const SizedBox(height: 8),
              _buildTextButton(Icons.add,'New DM', Theme.of(context).customTextColor2, iconSize3, Theme.of(context).customIconColor2, "/home"),
              const SizedBox(height: 8),
              _buildTextButton(Icons.mail_outline, 'hong_gildong13', Theme.of(context).customTextColor1, iconSize3, Theme.of(context).customIconColor1, "/home"),
              const SizedBox(height: 8),
              _buildTextButton(Icons.mail_outline, 'hun_i22', Theme.of(context).customTextColor1, iconSize3, Theme.of(context).customIconColor1, "/home"),
              const SizedBox(height: 8),
              _buildTextButton(Icons.mail_outline, 'Shima_Ring', Theme.of(context).customTextColor1, iconSize3, Theme.of(context).customIconColor1, "/home"),
              _buildIconRowForDarkMode(),
            ],
          ),
        ),

    );
  }

  Widget buildSearchBar(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent, // 물결 효과 제거
      highlightColor: Colors.transparent, // 강조 효과
      onHover: (isHovering) {
        print(isHovering ? 'Hovering' : 'Not Hovering'); // 디버깅용 출력
      },
      hoverColor: Colors.transparent, // 호버 시 색상 변경
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
          color: Theme.of(context).customIconBackgroundColor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: iconSize2, color: Theme.of(context).customIconColor1,),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Search',
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
    );
  }

  Widget _buildIconRow() {
    return Row(
        children: [
          FloatingButton(
              onPressed:() => _redirectPage("/home"), colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'DM',
              icon: Icons.send_rounded, iconSize: iconSize2, height: 48, width: 52,iconColor: Theme.of(context).customIconColor1,
          ),
          const SizedBox(width: 8),
          FloatingButton(
              onPressed:() => _redirectPage("/bookmark"), colorVal: Theme.of(context).customIconBackgroundColor1, toolTip :'BookMark',
              icon: Icons.bookmark, iconSize: iconSize2, height: 48, width: 52,iconColor: Theme.of(context).customIconColor1,
          ),
          const SizedBox(width: 8),
          FloatingButton(
              onPressed:() => _redirectPage("/profile"), colorVal: Theme.of(context).customBackgroundInvertColor1, toolTip :'Setting',
              icon: Icons.more_horiz, iconSize: iconSize2, height: 48, width: 52,iconColor: Theme.of(context).customIconInvertColor1,
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
                onPressed:_changeLightNightMode, colorVal: Theme.of(context).customIconBackgroundColor1, toolTip : _isLightMode ? 'Dark Mode' : 'Light Mode',
                icon: _isLightMode ? Icons.wb_sunny_outlined : Icons.nightlight, iconSize: iconSize1, height: 24, width: 24, iconColor: Theme.of(context).customIconColor1,
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
                  color: Theme.of(context).customTextColor2,
                  fontSize: fontSize2,
                  fontFamily: 'ABeeZee',
                ),
              ),
          ),
          const SizedBox(height: 2),
          _buildTextButton(
              Icons.recommend,'Recommend',
              _isRecommend ? Theme.of(context).customTextColor1
                  : Theme.of(context).customTextColor2, iconSize2,
              Theme.of(context).customIconColor1, "/home"),
          const SizedBox(height: 2),
          _buildTextButton(
              Icons.people,'Following',
              _isFollowing ? Theme.of(context).customTextColor1
              : Theme.of(context).customTextColor2, iconSize2,
              Theme.of(context).customIconColor1, "/followingFeed"),
          const SizedBox(height: 2),
          _buildTextButton(
              _isFavorite ? Icons.favorite: Icons.favorite_border_outlined,'Favorite',
              _isFavorite ? Theme.of(context).customTextColor1
                  : Theme.of(context).customTextColor2, iconSize2,
              Theme.of(context).customIconColor1, "/favoriteFeed"),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  //
  // Widget _buildSubListItem(String text) {
  //   return Container(
  //     width: double.infinity,
  //     height: 24,
  //     padding: const EdgeInsets.only(top: 0, left: 28, right: 8, bottom: 0),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: _buildSideTextButton(Icons.favorite, text, Theme.of(context).customTextColor1, iconSize1),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSolidLine(double radius){
    return Container(
      width: double.infinity,
      height: radius,
      color: lineColor1,
    );
  }

  Widget _buildTextButton(IconData icon,String text, Color colorVal, double iconSize, Color iconColor, String directPage){
    return SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            _redirectPage(directPage);
            setState(() {
              if(directPage == "/home"){
                _isRecommend = true;
                _isFollowing = false;
                _isFavorite = false;
              }else if(directPage == "/followingFeed"){
                _isFollowing = true;
                _isRecommend = false;
                _isFavorite = false;
              }else if(directPage == "/favoriteFeed"){
                _isFavorite = true;
                _isFollowing = false;
                _isRecommend = false;
              }
            });
          },
          icon: Icon(icon, size: iconSize, color: iconColor), // "+" 버튼
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
