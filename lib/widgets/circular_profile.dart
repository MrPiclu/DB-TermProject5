import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';

class CircularProfile extends StatefulWidget {
  final VoidCallback onPressed;
  final double radius;
  final double strokeRadius;
  User? userInfo;

  CircularProfile({
    super.key,
    required this.onPressed,
    required this.radius,
    required this.strokeRadius,
    this.userInfo,
  });

  @override
  State<CircularProfile> createState() => _CircularProfileState();
}

class _CircularProfileState extends State<CircularProfile> {
  bool _isHovering = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed, // 클릭 이벤트 처리
      child: MouseRegion(
        onEnter: (_) => _onHover(true), // 마우스가 위로 올라갈 때
        onExit: (_) => _onHover(false), // 마우스가 떠날 때
        child: Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovering
                ? Theme.of(context).customBackgroundColor2 // 호버 시 색상
                : Theme.of(context).customBackgroundColor1, // 기본 색상
          ),
          child: Container(
            margin: EdgeInsets.all(widget.strokeRadius),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.userInfo?.profile_image_url ?? 'https://i1.sndcdn.com/artworks-RHyIa5AknpjuZXB4-yiy0NA-t500x500.jpg'),
                fit: BoxFit.cover,
                opacity: _isHovering ? 0.45 : 1
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering; // 상태 업데이트
    });
  }
}
