import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'tweet_container.dart';
import '../theme/colors.dart';
import 'floating_button.dart';

class BookmarkContainer extends StatefulWidget {
  const BookmarkContainer({super.key});

  @override
  State<BookmarkContainer> createState() => _BookmarkContainerState();
}

class _BookmarkContainerState extends State<BookmarkContainer> {

  void _redirectPage(String location) {
    context.go(location);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 603,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          _buildMainUploadSection(context),
          _buildSolidLine(1.0),
          tweetContainer(),
        ],
      ),
    );
  }

  Widget _buildMainUploadSection(BuildContext context) {
    return  Container(
        width: double.infinity,
        height: 119,
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingButton(
                        onPressed:() => _redirectPage("/home"), colorVal: Theme.of(context).customTransparentColor, toolTip :'',
                        icon: Icons.arrow_back, iconSize: iconSize2, height: 24, width: 24,iconColor: Theme.of(context).customIconColor2, //글을 적으면 iconColor1으로 변경됨
                      ),
                      const SizedBox(width: 13),
                      Text(
                        'Bookmarks',
                        style: TextStyle(
                          color: Theme.of(context).customTextColor2,
                          fontSize: fontSize5,
                          fontFamily: 'ABeeZee',
                          height: 1.0, // vertical center
                        ),
                      )
                    ]
                ),
              ),
            ),
            const SizedBox(height: 8),
            const searchBarContainer(edgeInsets: EdgeInsets.symmetric(horizontal: 14, vertical: 10), round: 16,),
            const SizedBox(height : 8),
          ],
        ),
      );

  }

  Widget _buildSolidLine(double radius){
    return Container(
      width: double.infinity,
      height: radius,
      color: Theme.of(context).dividerColor,
    );
  }

}
