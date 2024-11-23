import 'package:contact1313/bookmark_page.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color colorVal;
  final double fontSize;
  final double width;
  final double height;
  final String text;

  const CustomTextButton({super.key, required this.onPressed, required this.colorVal, required this.width, required this.height, required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
          BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).customBackgroundColor2,
          ),
        height: height,
        child: TextButton(
          onPressed: () => onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: Theme.of(context).customTextColor2,
            ),
          ),
        )
    );
  }
}
