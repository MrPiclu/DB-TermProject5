import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color colorVal;
  final String toolTip;
  final IconData icon;
  final double iconSize;
  final double width;
  final double height;
  final Color iconColor;

  const FloatingButton({super.key, required this.onPressed, required this.colorVal, required this.toolTip, required this.icon, required this.iconSize, required this.width, required this.height, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: FloatingActionButton(
          elevation: 0.0,
          onPressed: onPressed,
          backgroundColor: colorVal,
          child: Icon(icon, size: iconSize, color: iconColor,),
        ),
      );
  }
}
