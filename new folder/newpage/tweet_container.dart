import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/media.dart';
import '../model/tweet.dart';
import '../model/user.dart';
import '../tweet/tweet_pref.dart';
import '../tweet/media_pref.dart';
import '../tweet/user_pref.dart';
import '../widgets/async/async_img.dart';
import '../widgets/circular_profile.dart';
import '../widgets/reaction_button.dart';
import '../theme/size.dart';
import '../theme/theme_data.dart';
import 'package:go_router/go_router.dart';

class TweetContainer extends StatefulWidget {
  final Tweet tweet;

  const TweetContainer({
    super.key,
    required this.tweet,
  });

  @override
  State<TweetContainer> createState() => _TweetContainerState();
}

class _TweetContainerState extends State<TweetContainer> {
  int favCount = 0;
  bool isFavorited = false;
  bool isLoading = true;
  String? mediaUrl;
  User? userInfo;
  DateTime? parsedDate;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final results = await Future.wait([
        _loadUserInfo(),
        _loadMedias(),
        _loadFavoriteInfo(),
      ]);

      setState(() {
        userInfo = results[0] as User?;
        mediaUrl = (results[1] as Media?)?.mediaUrl;
        final favoriteInfo = results[2] as Map<String, dynamic>;
        favCount = favoriteInfo['userCount'];
        isFavorited = favoriteInfo['isFavorited'];
        parsedDate = DateTime.parse(widget.tweet.created_at);
        isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar('Error loading data: $e');
      setState(() => isLoading = false);
    }
  }

  Future<User?> _loadUserInfo() async {
    try {
      return await LoadUserInfo.loadUserInfo(widget.tweet.user_uid ?? -1);
    } catch (e) {
      throw 'Failed to load user info';
    }
  }

  Future<Media?> _loadMedias() async {
    try {
      return await LoadTweetMedias.loadMedia(widget.tweet.id ?? -1);
    } catch (e) {
      throw 'Failed to load media';
    }
  }

  Future<Map<String, dynamic>> _loadFavoriteInfo() async {
    try {
      return await RememberTweet.loadFavoriteInfo(widget.tweet.id ?? 0);
    } catch (e) {
      throw 'Failed to load favorite info';
    }
  }

  Future<void> _updateFavoriteStatus(bool isAdding) async {
    final actionType = isAdding ? 'true' : 'false';
    try {
      await http.post(
        Uri.parse(API.updateFavTweet),
        body: {
          'user_uid': currentUserInfo.user_uid.toString(),
          'tweet_id': widget.tweet.id.toString(),
          'isFav': actionType,
        },
      );
      setState(() {
        isFavorited = isAdding;
        favCount += isAdding ? 1 : -1;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to update favorite status');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _redirectToProfile() {
    context.go('/${userInfo?.user_uid}/profile');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Theme.of(context).customBackgroundColor2,
      child: Ink(
        child: Column(
          children: [
            _buildTweetContent(context),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget _buildTweetContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: _redirectToProfile,
                child: CircularProfile(
                  onPressed: _redirectToProfile,
                  radius: 25,
                  userInfo: userInfo,
                  strokeRadius: 0,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTweetDetails(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildReactionRow(),
        ],
      ),
    );
  }

  Widget _buildTweetDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserInfoRow(context),
        const SizedBox(height: 10),
        _buildTweetBody(context),
      ],
    );
  }

  Widget _buildUserInfoRow(BuildContext context) {
    return Row(
      children: [
        Text(
          userInfo?.user_name ?? 'Guest',
          style: TextStyle(
            color: Theme.of(context).customTextColor1,
            fontSize: fontSize4,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '@${userInfo?.user_name ?? 'Guest'}',
          style: TextStyle(
            color: Theme.of(context).customTextColor2,
            fontSize: fontSize2,
          ),
        ),
        const Spacer(),
        Text(
          parsedDate != null ? DateFormat('dd MMM').format(parsedDate!) : '',
          style: TextStyle(
            color: Theme.of(context).customTextColor2,
            fontSize: fontSize4,
          ),
        ),
      ],
    );
  }

  Widget _buildTweetBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).customBackgroundColor2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.tweet.body,
            style: TextStyle(
              color: Theme.of(context).customTextColor2,
              fontSize: fontSize2,
            ),
          ),
          const SizedBox(height: 8),
          if (mediaUrl != null)
            AsyncDynamicHeightContainer(imgUrl: mediaUrl!),
        ],
      ),
    );
  }

  Widget _buildReactionRow() {
    return Row(
      children: [
        ReactionButton(
          onPressed: () => _updateFavoriteStatus(!isFavorited),
          colorVal: Theme.of(context).customTransparentColor,
          toolTip: 'Favorite',
          icon: Icons.favorite,
          iconSize: iconSize2,
          width: 48,
          height: 36,
          iconColor: isFavorited
              ? Theme.of(context).customIconHighlightedColor3
              : Theme.of(context).customIconColor1,
          count: favCount.toString(),
        ),
        const SizedBox(width: 8),
        ReactionButton(
          onPressed: () {},
          colorVal: Theme.of(context).customTransparentColor,
          toolTip: 'Comment',
          icon: Icons.chat_bubble,
          iconSize: iconSize2,
          width: 48,
          height: 36,
          iconColor: Theme.of(context).customIconColor1,
          count: widget.tweet.chat_count,
        ),
        const Spacer(),
        ReactionButton(
          onPressed: () {},
          colorVal: Theme.of(context).customTransparentColor,
          toolTip: 'Bookmark',
          icon: Icons.bookmark,
          iconSize: iconSize2,
          width: 48,
          height: 36,
          iconColor: Theme.of(context).customIconInvertColor1,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.0,
      color: Theme.of(context).dividerColor,
    );
  }
}
