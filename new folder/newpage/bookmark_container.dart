import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:contact1313/home_page.dart';
import 'package:contact1313/theme/size.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/widgets/search_bar.dart';
import 'tweet_container.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).customBackgroundColor1,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildBookmarksList(context),
          ),
        ],
      ),
    );
  }

  // 헤더 위젯
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingButton(
                onPressed: () => _redirectPage("/home"),
                colorVal: Theme.of(context).customTransparentColor,
                toolTip: '',
                icon: Icons.arrow_back,
                iconSize: iconSize2,
                height: 36,
                width: 36,
                iconColor: Theme.of(context).customIconColor2,
              ),
              const SizedBox(width: 16),
              Text(
                'Bookmarks',
                style: TextStyle(
                  color: Theme.of(context).customTextColor2,
                  fontSize: fontSize5,
                  fontFamily: 'ABeeZee',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const SearchBarContainer(
            edgeInsets: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            round: 16,
          ),
          const SizedBox(height: 8),
          _buildDivider(1.0),
        ],
      ),
    );
  }

  // 즐겨찾기 목록
  Widget _buildBookmarksList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 10, // Example count; replace with actual data
      itemBuilder: (context, index) {
        return TweetContainer(
          tweet: _mockTweet(index), // Replace with your data source
        );
      },
    );
  }

  // 구분선
  Widget _buildDivider(double thickness) {
    return Divider(
      color: Theme.of(context).dividerColor,
      thickness: thickness,
      height: thickness,
    );
  }

  // 더미 데이터 생성 (실제 데이터로 교체 필요)
  Tweet _mockTweet(int index) {
    return Tweet(
      id: index,
      user_uid: 123,
      created_at: DateTime.now().toIso8601String(),
      body: 'This is a sample bookmarked tweet #$index',
      fav_count: index * 10,
      chat_count: index * 5,
    );
  }
}
