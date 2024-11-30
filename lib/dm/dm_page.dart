import 'package:flutter/material.dart';
import 'api_service.dart';
import 'new_dm_page.dart'; // 새로운 DM 화면 추가

class DmPage extends StatefulWidget {
  @override
  _DmPageState createState() => _DmPageState();
}

class _DmPageState extends State<DmPage> {
  List<dynamic> messages = [];
  String receiverId = "1"; // 테스트용 수신자 ID

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  void fetchMessages() async {
    try {
      final data = await ApiService.getMessages(receiverId);
      setState(() {
        messages = data;
      });
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DM Page'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            title: Text(message['content']),
            subtitle: Text('Sender: ${message['sender_id']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewDMPage()), // 새로운 DM 페이지로 이동
          );
        },
        tooltip: 'New DM',
        child: const Icon(Icons.add),
      ),
    );
  }
}
