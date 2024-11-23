import 'package:contact1313/theme/colors.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/widgets/main_container.dart';
import 'package:contact1313/widgets/right_side_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'my_app.dart';
import 'widgets/bookmark_container.dart';
import 'widgets/custom_container.dart';
import 'widgets/floating_button.dart';


class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              widget.child,
              Container(width: 1,height: double.infinity, color: Theme.of(context).dividerColor),
              const RightSideContainer(),
            ],
          ),
        ),
      ),
    );
}
}