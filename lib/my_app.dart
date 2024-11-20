import 'dart:ui';

import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode currentMode, Widget? child) {

        return MaterialApp(
          scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
          theme: darkTheme, // dark Mode 테마 (X 특성상 다크 모드가 default)
          darkTheme: lightTheme, // light Mode 테마
          themeMode: currentMode, // 현재 테마 모드
          home: MyHomePage(),
        );
      },
    );
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}