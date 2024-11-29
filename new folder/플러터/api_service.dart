import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://your-server-url/new%20folder"; // PHP 서버 주소

  // CSRF 토큰 가져오기
  Future<String> fetchCsrfToken() async {
    final response = await http.get(Uri.parse('$baseUrl/get_csrf_token.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['csrf_token']; // 서버에서 반환된 CSRF 토큰 값
    } else {
      throw Exception('Failed to fetch CSRF token');
    }
  }

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
      return response.body;
    } else {
      throw Exception('Failed to save bookmark');
    }
  }
}
