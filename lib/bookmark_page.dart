import 'package:contact1313/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'widgets/bookmark_container.dart';
import 'widgets/custom_container.dart';


class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});


  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {


  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).customBackgroundColor1,
          body: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CustomContainer(),
                Container(width: 1,height: double.infinity, color: Theme.of(context).dividerColor),
                const BookmarkContainer(),
                Container(width: 1,height: double.infinity, color: Theme.of(context).dividerColor),
              ],
            ),
      ),
        ),
      );
  }
}
