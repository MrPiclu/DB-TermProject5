import 'package:contact1313/theme/colors.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/widgets/main_container.dart';
import 'package:flutter/material.dart';
import 'my_app.dart';
import 'widgets/custom_container.dart';
import 'widgets/floating_button.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).customBackgroundColor1,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CustomContainer(),
                Container(width: 1,height: double.infinity, color: Theme.of(context).dividerColor),
                const MainContainer(),
                Container(width: 1,height: double.infinity, color: Theme.of(context).dividerColor),
              ],
            ),
      ),
        ),
      );
  }
}
