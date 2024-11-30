import 'package:contact1313/theme/size.dart';
import 'package:flutter/material.dart';
import 'colors.dart'; // 위 색상 파일을 import

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: wbackGround1, // 메인 색상
  scaffoldBackgroundColor: wbackGround2, // 배경 색상
  dividerColor: lwineColor1, // 선 색상
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: backGround1, // 메인 색상
  scaffoldBackgroundColor: backGround2, // 배경 색상
  dividerColor: lineColor1, // 선 색상
);

// extension 정의
extension CustomTheme on ThemeData {
  Color get customIconColor1 => brightness == Brightness.dark
      ? iconColor1// 다크 모드 색상
      : wiconColor1;  // 라이트 모드 색상
  Color get customIconColor2 => brightness == Brightness.dark
      ? iconColor2// 다크 모드 색상
      : wiconColor2;  // 라이트 모드 색상

  Color get customIconHighlightedColor3 => Colors.redAccent; // 다크 모드 색상

  Color get customIconInvertColor1 => brightness == Brightness.dark
      ? wiconColor1// 다크 모드 색상
      : iconColor1;  // 라이트 모드 색상

  Color get customTextColor1 => brightness == Brightness.dark
      ? textColor1// 다크 모드 색상
      : wtextColor1;  // 라이트 모드 색상
  Color get customTextColor2 => brightness == Brightness.dark
      ? textColor2// 다크 모드 색상
      : wtextColor2;  // 라이트 모드 색상

  Color get customIconBackgroundColor1 => brightness == Brightness.dark
      ? iconBackgroundColor1// 다크 모드 색상
      : wiconBackgroundColor1;  // 라이트 모드 색상

  Color get customBackgroundColor1 => brightness == Brightness.dark
      ? backGround1// 다크 모드 색상
      : wbackGround1;  // 라이트 모드 색상
  Color get customBackgroundColor2 => brightness == Brightness.dark
      ? backGround2// 다크 모드 색상
      : wbackGround2;  // 라이트 모드 색상
  Color get customBackgroundInvertColor1 => brightness == Brightness.dark
      ? wbackGround2// 다크 모드 색상
      : backGround2;  // 라이트 모드 색상

  Color get customTransparentColor => transparentColor;

}
