import 'package:contact1313/bookmark_page.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  Color? colorVal;
  final double fontSize;
  double? width;
  double? height;
  final String text;
  BoxDecoration? boxDecoration;

  CustomTextButton({super.key, required this.onPressed, this.colorVal, this.width, this.height, required this.text, required this.fontSize, this.boxDecoration});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            boxDecoration ?? BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorVal ?? Theme.of(context).customBackgroundColor2,
          ),
        width: width,
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
