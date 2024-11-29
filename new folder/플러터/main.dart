import 'package:flutter/material.dart';
import 'api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookmark Manager',
      home: BookmarkPage(),
    );
  }
}

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final ApiService apiService = ApiService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  List<dynamic> bookmarks = [];
  String csrfToken = '';

  @override
  void initState() {
    super.initState();
    fetchCsrfTokenAndBookmarks();
  }

  // CSRF 토큰과 북마크 목록 가져오기
  void fetchCsrfTokenAndBookmarks() async {
    try {
      final token = await apiService.fetchCsrfToken();
      setState(() {
        csrfToken = token;
      });
      fetchBookmarks();
    } catch (e) {
      print('Error: $e');
    }
  }

  // 북마크 목록 가져오기
  void fetchBookmarks() async {
    try {
      final data = await apiService.getBookmarks(csrfToken);
      setState(() {
        bookmarks = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // 북마크 저장
  void saveBookmark() async {
    try {
      final response = await apiService.saveBookmark(
        titleController.text,
        urlController.text,
        csrfToken,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
      fetchBookmarks();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Bookmark Title'),
            ),
            TextField(
              controller: urlController,
              decoration: InputDecoration(labelText: 'Bookmark URL'),
            ),
            ElevatedButton(
              onPressed: saveBookmark,
              child: Text('Save Bookmark'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = bookmarks[index];
                  return ListTile(
                    title: Text(bookmark['bookmark_title']),
                    subtitle: Text(bookmark['bookmark_url']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
