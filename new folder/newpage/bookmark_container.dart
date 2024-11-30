import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'floating_button.dart';
import 'tweet_container.dart';
import 'package:contact1313/widgets/search_bar.dart';
import 'package:contact1313/theme/theme_data.dart';
import 'package:contact1313/theme/size.dart';
import '../model/tweet.dart';

class BookmarkContainer extends StatefulWidget {
  const BookmarkContainer({super.key});

  @override
  State<BookmarkContainer> createState() => _BookmarkContainerState();
}

class _BookmarkContainerState extends State<BookmarkContainer> {
  List<Tweet> bookmarks = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    try {
      final tweets = await _fetchBookmarks();
      setState(() {
        bookmarks = tweets;
        isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load bookmarks: $e');
      setState(() => isLoading = false);
    }
  }

  Future<List<Tweet>> _fetchBookmarks() async {
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT/bookmarks'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Tweet.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch bookmarks');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _redirectPage(String location) {
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookmarks = bookmarks.where((tweet) {
      return tweet.body.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).customBackgroundColor1,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildBookmarksList(filteredBookmarks),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kSmallPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingButton(
                onPressed: () => _redirectPage("/home"),
                colorVal: Theme.of(context).customTransparentColor,
                toolTip: '',
                icon: Icons.arrow_back,
                iconSize: kIconSize,
                height: 36,
                width: 36,
                iconColor: Theme.of(context).customIconColor2,
              ),
              const SizedBox(width: kDefaultPadding),
              Text(
                'Bookmarks',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          const SizedBox(height: kSmallPadding),
          SearchBarContainer(
            edgeInsets: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            round: 16,
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: kSmallPadding),
          _buildDivider(1.0),
        ],
      ),
    );
  }

  Widget _buildBookmarksList(List<Tweet> filteredBookmarks) {
    if (filteredBookmarks.isEmpty) {
      return Center(
        child: Text(
          'No bookmarks available',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredBookmarks.length,
      itemBuilder: (context, index) {
        return TweetContainer(tweet: filteredBookmarks[index]);
      },
    );
  }

  Widget _buildDivider(double thickness) {
    return Divider(
      color: Theme.of(context).dividerColor,
      thickness: thickness,
      height: thickness,
    );
  }
}
