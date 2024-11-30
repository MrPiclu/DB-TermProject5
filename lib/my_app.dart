import 'dart:ui';
import 'package:contact1313/authentication/login.dart';
import 'package:contact1313/main_screen.dart';
import 'package:contact1313/widgets/bookmark_container.dart';
import 'package:contact1313/widgets/favorite_feed_container.dart';
import 'package:contact1313/widgets/follower_info_container.dart';
import 'package:contact1313/widgets/following_info_container.dart';
import 'package:contact1313/widgets/following_feed_container.dart';
import 'package:contact1313/widgets/profile_container.dart';
import 'package:contact1313/widgets/recommend_feed_container.dart';
import 'package:contact1313/widgets/reset_password_container.dart';
import 'package:go_router/go_router.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';


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
    GoRoute(
      path: "/login",
      pageBuilder: (context, state) => const NoTransitionPage(child: MyApp()),
    ),
    ShellRoute(
        builder: (context, state, child){
          return MainScreen(child: child);
        },
        routes: [
        GoRoute(
          path: "/home",
          pageBuilder: (context, state) => const NoTransitionPage(child: RecommendFeedContainer()),
        ),
          GoRoute(
            path: "/bookmark",
            pageBuilder: (context, state) => const NoTransitionPage(child: BookmarkContainer()),
          ),
          GoRoute(
            path: "/:userId/profile", // 동적 매개변수 userId를 앞에 배치
            pageBuilder: (context, state) {
              final userId = state.pathParameters['userId']; // userId 추출
              return NoTransitionPage(child: ProfileContainer(userUid: int.parse(userId!)));
            },
          ),
          GoRoute(
            path: "/:userId/following", // 동적 매개변수 userId를 앞에 배치
            pageBuilder: (context, state) {
              final userId = state.pathParameters['userId']; // userId 추출
              return NoTransitionPage(child: FollowingInfoContainer(userUid: int.parse(userId!)));
            },
          ),
          GoRoute(
            path: "/followingFeed", // 동적 매개변수 userId를 앞에 배치
            pageBuilder: (context, state) {
              return NoTransitionPage(child: FollowingFeedContainer());
            },
          ),
          GoRoute(
            path: "/favoriteFeed", // 동적 매개변수 userId를 앞에 배치
            pageBuilder: (context, state) {
              return NoTransitionPage(child: FavoriteFeedContainer());
            },
          ),
          GoRoute(
            path: "/resetPassword", // 동적 매개변수 userId를 앞에 배치
            pageBuilder: (context, state) {
              return NoTransitionPage(child: ResetPasswordContainer());
            },
          ),
          GoRoute(
            path: "/:userId/followers", // 동적 매개변수 userId를 앞에 배치
            pageBuilder: (context, state) {
              final userId = state.pathParameters['userId']; // userId 추출
              return NoTransitionPage(child: FollowerInfoContainer(userUid: int.parse(userId!)));
            },
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