import 'package:contact1313/theme/colors.dart';
import 'package:contact1313/theme/size.dart';
import 'package:flutter/material.dart';

class ReactionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color colorVal;
  final String toolTip;
  final IconData icon;
  final double iconSize;
  final double width;
  final double height;
  final Color iconColor;
  final String? count;

  const ReactionButton({super.key, required this.onPressed, required this.colorVal, required this.toolTip, required this.icon, required this.iconSize, required this.width, required this.height, required this.iconColor, this.count});

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: FloatingActionButton(
          elevation: 0.0,
          onPressed: widget.onPressed,
          backgroundColor: widget.colorVal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: widget.iconSize, color: widget.iconColor,),
              const SizedBox(width: 5),
              Text(widget.count ?? '', style: const TextStyle(color: textColor2, fontSize: fontSize3),),
            ],
          )
        ),
      );
  }
}
