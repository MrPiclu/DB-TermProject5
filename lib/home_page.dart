import 'package:contact1313/theme/colors.dart';
import 'package:contact1313/widgets/main_container.dart';
import 'package:flutter/material.dart';
import 'widgets/custom_container.dart';
import 'widgets/floating_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      print('hello');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround1,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CustomContainer(),
            Container(width: 1,height: double.infinity, color: lineColor1),
            const MainContainer(),
            Container(width: 1,height: double.infinity, color: lineColor1),
          ],
        ),
      ),
    );
  }
}
