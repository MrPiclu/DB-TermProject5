import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://your-server-address"; // 서버 주소

  // 메시지 가져오기
  static Future<List<dynamic>> getMessages(String receiverId) async {
    final response = await http.get(Uri.parse('$baseUrl/get_messages.php?receiver_id=$receiverId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  // 메시지 전송
  static Future<void> sendMessage(String senderId, String receiverId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send_message.php'),
      body: {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  // 읽음 상태 업데이트
  static Future<void> updateReadStatus(String messageId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_read_status.php'),
      body: {
        'message_id': messageId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update read status');
    }
  }
}
