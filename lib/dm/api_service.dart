import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지
import 'dart:convert'; // JSON 변환을 위한 패키지

class ApiService {
  static const String baseUrl = "http://your-server-address"; // 서버 주소

  // 메시지 가져오기
  static Future<List<dynamic>> getMessages(String receiverId) async {
    final response = await http.get(Uri.parse('$baseUrl/get_messages.php?receiver_id=$receiverId'));
    if (response.statusCode == 200) {
      return json.decode(response.body); // JSON 응답을 파싱
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

  // 읽음 상태 업데이트 (선택적으로 추가 가능)
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
