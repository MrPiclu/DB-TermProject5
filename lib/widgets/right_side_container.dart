import 'package:contact1313/my_app.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../authentication/login.dart';
import '../theme/colors.dart';
import 'circular_profile.dart';

class RightSideContainer extends StatefulWidget {
  const RightSideContainer({super.key});

  @override
  State<RightSideContainer> createState() => _RightSideContainerState();

}

class _RightSideContainerState extends State<RightSideContainer> {
  bool _isLightMode = false;

  @override
  void initState(){
    super.initState();
  }

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
          width: 300,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileBar(context),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                child: _buildSolidLine(1.0),
              )
            ],
          ),
        ),

    );
  }

  Widget buildProfileBar(BuildContext context) {
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
        padding: const EdgeInsets.all(6),
        child: Container(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              CircularProfile(
                onPressed: (){_redirectPage("/${currentUserInfo.user_uid}/profile");},
                radius: 25,
                userInfo: currentUserInfo,
                strokeRadius: 0,
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUserInfo?.user_name ?? "Guest",
                    style: TextStyle(
                      color: Theme.of(context).customTextColor2,
                      fontSize: fontSize2,
                      fontFamily: 'ABeeZee',
                    ),
                  ),Text(
                    '@${currentUserInfo?.user_id ?? "guest1"}',
                    style: TextStyle(
                      color: Theme.of(context).customTextColor2,
                      fontSize: fontSize2,
                      fontFamily: 'ABeeZee',
                    ),
                  ),
                ],

              ),
              const Expanded(
                child: SizedBox(),
              ),
              CustomTextButton(
                  onPressed: (){_redirectPage("/6/profile");},
                  colorVal: Theme.of(context).customIconBackgroundColor1,
                  width: 96,
                  height: 24,
                  text: "Change",
                  fontSize: 13)

            ],
          ),
        ),
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
