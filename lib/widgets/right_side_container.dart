import 'package:contact1313/my_app.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home_page.dart';
import '../theme/colors.dart';
import 'floating_button.dart';
import 'search_bar.dart';

class RightSideContainer extends StatefulWidget {
  const RightSideContainer({super.key});

  @override
  State<RightSideContainer> createState() => _RightSideContainerState();
}

class _RightSideContainerState extends State<RightSideContainer> {
  bool _isLightMode = false;

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
              CircleAvatar(
                  radius: 25,
                  //Rin : https://i.pinimg.com/736x/ab/75/af/ab75af0e6429d3b58af76f9333564c93.jpg
                  //Nadeshiko : https://preview.redd.it/despite-the-art-style-changed-nadeshiko-is-mega-cute-v0-ryv8wimm0avc1.jpeg?width=1080&crop=smart&auto=webp&s=84ab0d027219b4e73f47cbe76c80362c01eb65b4
                  backgroundImage: NetworkImage("https://preview.redd.it/despite-the-art-style-changed-nadeshiko-is-mega-cute-v0-ryv8wimm0avc1.jpeg?width=1080&crop=smart&auto=webp&s=84ab0d027219b4e73f47cbe76c80362c01eb65b4")
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nadeshiko',
                    style: TextStyle(
                      color: Theme.of(context).customTextColor2,
                      fontSize: fontSize2,
                      fontFamily: 'ABeeZee',
                    ),
                  ),Text(
                    '@Nada_Nade',
                    style: TextStyle(
                      color: Theme.of(context).customTextColor2,
                      fontSize: fontSize2,
                      fontFamily: 'ABeeZee',
                    ),
                  ),
                ],

              ),
              const SizedBox(width: 18),
              CustomTextButton(onPressed: _changeLightNightMode, colorVal: Theme.of(context).customIconColor2,width: 96, height: 24,text: "Change", fontSize: 13)

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
