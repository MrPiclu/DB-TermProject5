import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../authentication/login.dart';
import '../model/media.dart';
import '../model/tweet.dart'; // Tweet 모델을 사용하기 위해 import
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
            _buildTweetActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTweetContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircularProfileImage(userInfo: userInfo),
          const SizedBox(width: kSmallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTweetHeader(context),
                const SizedBox(height: kSmallPadding),
                Text(
                  widget.tweet.body,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: kSmallPadding),
                if (mediaUrl != null) ...[
                  AsyncImg(mediaUrl: mediaUrl!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTweetHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          userInfo?.username ?? '',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(width: kSmallPadding),
        Text(
          DateFormat('hh:mm a, dd/MM/yyyy').format(parsedDate ?? DateTime.now()),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }

  Widget _buildTweetActions(BuildContext context) {
    return Row(
      children: [
        ReactionButton(
          icon: Icons.favorite,
          count: favCount,
          isSelected: isFavorited,
          onPressed: () => _updateFavoriteStatus(!isFavorited),
        ),
      ],
    );
  }
}
