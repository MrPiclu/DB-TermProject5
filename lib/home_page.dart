import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/widgets/profile_container.dart';
import 'package:flutter/material.dart';
import 'authentication/login.dart';
import 'widgets/custom_container.dart';


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
                ProfileContainer(userUid: currentUserInfo.user_uid!),
                Container(width: 1,height: double.infinity, color: Theme.of(context).dividerColor),
              ],
            ),
      ),
        ),
      );
  }
}
