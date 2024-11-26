import 'dart:ui';
import 'package:contact1313/authentication/login.dart';
import 'package:contact1313/main_screen.dart';
import 'package:contact1313/user/user_pref.dart';
import 'package:contact1313/widgets/bookmark_container.dart';
import 'package:contact1313/widgets/main_container.dart';
import 'package:contact1313/widgets/profile_container.dart';
import 'package:go_router/go_router.dart';

import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'bookmark_page.dart';
import 'home_page.dart';
import 'model/user.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);



  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode currentMode, Widget? child) {

        return MaterialApp.router(
          scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
          theme: darkTheme, // dark Mode 테마 (X 특성상 다크 모드가 default)
          darkTheme: lightTheme, // light Mode 테마
          themeMode: currentMode, // 현재 테마 모드
          routerConfig: _router,
        );
      },
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: "/home",
  routes: [
    ShellRoute(
        builder: (context, state, child){
          return MainScreen(child: child);
        },
        routes: [
        GoRoute(
          path: "/home",
          pageBuilder: (context, state) => const NoTransitionPage(child: MainContainer()),
        ),
          GoRoute(
            path: "/bookmark",
            pageBuilder: (context, state) => const NoTransitionPage(child: BookmarkContainer()),
          ),
          GoRoute(
            path: "/profile",
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfileContainer()),
          ),
          GoRoute(
            path: "/login",
            pageBuilder: (context, state) => const NoTransitionPage(child: LoginPage()),
          ),
    ]
    )
  ]
);

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}