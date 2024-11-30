import 'package:flutter/material.dart';
import 'api_service.dart';

class NewDMPage extends StatefulWidget {
  @override
  _NewDMPageState createState() => _NewDMPageState();
}

class _NewDMPageState extends State<NewDMPage> {
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    final receiverId = _receiverController.text;
    final content = _messageController.text;

    if (receiverId.isNotEmpty && content.isNotEmpty) {
      try {
        await ApiService.sendMessage('1', receiverId, content); // '1'은 현재 로그인된 사용자 ID
        Navigator.pop(context); // 메시지 전송 후 이전 화면으로 돌아감
      } catch (error) {
        print('Error sending message: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New DM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _receiverController,
              decoration: InputDecoration(labelText: 'Receiver ID'),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
