import 'package:contact1313/my_app.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../authentication/login.dart';
import '../model/notification.dart';
import '../notify/noti_pref.dart';
import '../theme/colors.dart';
import 'circular_profile.dart';
import 'floating_button.dart';

List<Notify> notifications = [];

class RightSideContainer extends StatefulWidget {
  const RightSideContainer({super.key});

  @override
  State<RightSideContainer> createState() => _RightSideContainerState();

}

class _RightSideContainerState extends State<RightSideContainer> {
  bool _isLoading = true;

  String getNotifyMessage(String type) {
    switch (type) {
      case 'follow':
        return "Followed you";
      case 'mention':
        return "Mentioned you";
      case 'like':
        return "Liked your tweet";
      case 'retweet':
        return "Retweeted your tweet";
      case 'comment':
        return "Commented on your tweet";
      default:
        return "You have a new notification";
    }
  }

  @override
  void initState(){
    super.initState();
    fetchNotifications();
  }

  void _redirectPage(String location) {
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              buildProfileBar(context),
              Container(
                padding: const EdgeInsets.all(8),
                child: _buildSolidLine(2.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        "Notification",
                        style: TextStyle(
                          color: Theme.of(context).customTextColor2,
                          fontSize: fontSize3,
                          fontFamily: 'ABeeZee',
                        ),
                      ),
                    ),
                    const Expanded(
                        child: SizedBox()
                    ),
                    FloatingButton(
                      height: 12,
                      width: 12,
                      onPressed: (){
                        setState(() {
                          fetchNotifications();
                        });
                        print("fetching NOtificiations");
                      },
                      icon: Icons.refresh,
                      iconColor: Theme.of(context).customIconColor2,
                      toolTip: "igonan",
                      colorVal: Theme.of(context).customTransparentColor,
                      iconSize: 12,
                    ),
                  ],
                ),
              ),
              _buildNotifyContainer(context),
            ],
          ),
        ),

    );
  }

  Widget buildProfileBar(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent, // 물결 효과 제거
      highlightColor: Colors.transparent, // 강조 효과
      onHover: (isHovering) {
        print(isHovering ? 'Hovering' : 'Not Hovering'); // 디버깅용 출력
      },
      hoverColor: Colors.transparent, // 호버 시 색상 변경
      onTap: (){_redirectPage("/${currentUserInfo.user_uid}/profile");},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        child: Container(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              CircularProfile(
                onPressed: (){_redirectPage("/${currentUserInfo.user_uid}/profile");},
                radius: 25,
                userInfo: currentUserInfo,
                strokeRadius: 0,
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUserInfo.user_name ?? "Guest",
                    style: TextStyle(
                      color: Theme.of(context).customTextColor2,
                      fontSize: fontSize2,
                      fontFamily: 'ABeeZee',
                    ),
                  ),Text(
                    '@${currentUserInfo.user_id ?? "guest1"}',
                    style: TextStyle(
                      color: Theme.of(context).customTextColor2,
                      fontSize: fontSize2,
                      fontFamily: 'ABeeZee',
                    ),
                  ),
                ],

              ),
              const Expanded(
                child: SizedBox(),
              ),
              // CustomTextButton(
              //     onPressed: (){_redirectPage("/login");},
              //     colorVal: Theme.of(context).customIconBackgroundColor1,
              //     width: 96,
              //     height: 24,
              //     text: "Change",
              //     boxDecoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       color: Theme.of(context).customIconBackgroundColor1,
              //     ),
              //     fontSize: 13),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchNotifications() async {
    try {
      print("enter right side fetch notifications");
      List<Notify> fetchedNotifies = await LoadNotifications.loadNotifications(currentUserInfo.user_uid ?? 0);
      print("1");
      setState(() {
        print("1");
        notifications = fetchedNotifies; // 가져온 데이터를 상태에 저장
        print("1");
        _isLoading = false;
      });
      print("1");
    } catch (e) {
      print('Error fetching tweets: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildNotifyCard(Notify notification) {
    return InkWell(
      splashColor: Colors.transparent, // 물결 효과 제거
      highlightColor: Colors.transparent, // 강조 효과
      onHover: (isHovering) {
        print(isHovering ? 'Hovering' : 'Not Hovering'); // 디버깅용 출력
      },
      hoverColor: Colors.transparent, // 호버 시 색상 변경
      onTap: (){_redirectPage("/${currentUserInfo.user_uid}/profile");},
      child: Container(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(6),
          child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${notification.user_name ?? "guest1"}',
                    style: TextStyle(
                      color: Theme.of(context).customTextColor2,
                      fontSize: fontSize2,
                      fontFamily: 'ABeeZee',
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    getNotifyMessage(notification.type),
                    style: TextStyle(
                      color: Theme.of(context).customTextColor2,
                      fontSize: fontSize2,
                      fontFamily: 'ABeeZee',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    color: lineColor1,
                  )
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildNotifyContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      height: 264,
      child: ListView.builder(
          itemCount: notifications.length, //프로필과 실선(경계선) + 트윗 수
          itemBuilder: (BuildContext ctx, int idx){
            return _isLoading
                ? const Center(
              child: SizedBox(
                  width: 603,
                  child: CircularProgressIndicator()
              ),
            )
                : _buildNotifyCard(notifications[idx]);
          }
      )
    );
  }

  Widget _buildSolidLine(double radius){
    return Container(
      width: double.infinity,
      height: radius,
      color: lineColor1,
    );
  }

}
