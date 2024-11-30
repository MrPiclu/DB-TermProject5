import 'package:flutter/material.dart';
import 'dm/dm_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Home Page'), // HomePage 사용
        '/dm': (context) => DmPage(), // DM 페이지
      },
    );
  }
}
