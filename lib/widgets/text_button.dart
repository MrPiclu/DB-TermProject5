import 'package:contact1313/bookmark_page.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  Color? colorVal;
  final double fontSize;
  double? width;
  double? height;
  final String text;
  BoxDecoration? boxDecoration;

  CustomTextButton({super.key, required this.onPressed, this.colorVal, this.width, this.height, required this.text, required this.fontSize, this.boxDecoration});

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            widget.boxDecoration ?? BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.colorVal ?? Theme.of(context).customBackgroundColor2,
          ),
        width: widget.width,
        height: widget.height,
        child: TextButton(
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: Theme.of(context).customTextColor2,
            ),
          ),
        )
    );
  }
}
