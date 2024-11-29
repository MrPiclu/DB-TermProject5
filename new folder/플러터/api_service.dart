import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://your-server-url/new%20folder"; // PHP API 경로

  // 북마크 목록 가져오기
  Future<List<dynamic>> getBookmarks(String csrfToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_bookmarks.php'),
      headers: {'X-CSRF-Token': csrfToken},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load bookmarks');
    }
  }

  // 북마크 저장
  Future<String> saveBookmark(String title, String url, String csrfToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save_bookmark.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'url': url, 'csrf_token': csrfToken}),
    );
    if (response.statusCode == 200) {
      return response.body; // 성공 메시지
    } else {
      throw Exception('Failed to save bookmark');
    }
  }
}
