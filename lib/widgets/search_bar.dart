import 'package:contact1313/my_app.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import '../theme/colors.dart';
import 'floating_button.dart';

class searchBarContainer extends StatefulWidget {
  final EdgeInsets edgeInsets;
  final double round;
  const searchBarContainer({super.key, required this.edgeInsets, required this.round});

  @override
  State<searchBarContainer> createState() => _searchBarContainerState();
}

class _searchBarContainerState extends State<searchBarContainer> {

  get edgeInsets => widget.edgeInsets;
  get round => widget.round;

  @override
  Widget build(BuildContext context) {
    return searchBarContainer(context);
  }

  Widget searchBarContainer(BuildContext context) {
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
          padding: edgeInsets,
          decoration: ShapeDecoration(
            color: Theme.of(context).customIconBackgroundColor1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(round),
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


}
