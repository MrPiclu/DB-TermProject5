import 'theme/colors.dart'; // 커스텀 색상 테마
import 'package:flutter/material.dart'; // 플러터 기본 위젯 및 기능
import 'widgets/custom_container.dart'; // 커스텀 컨테이너 위젯
import 'widgets/floating_button.dart'; // 플로팅 버튼 위젯

// 홈 화면 위젯 정의
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title; // 화면의 제목 (외부에서 전달됨)

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0; // 카운터 변수 초기화

  // 카운터 증가 함수
  void _incrementCounter() {
    setState(() {
      _counter++; // 카운터 값 증가
      print('Counter incremented: $_counter'); // 디버그 로그 출력
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround1, // 배경색 설정
      appBar: AppBar(
        title: Text(widget.title), // 제목 표시
        backgroundColor: Colors.blueAccent, // 앱바 색상
      ),
      body: Center(
        // 화면 중앙에 배치
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로축 가운데 정렬
          children: <Widget>[
            // 커스텀 컨테이너 위젯 표시
            const CustomContainer(),
            const SizedBox(height: 20), // 컨테이너 아래 여백
            Text(
              'Button pressed $_counter times', // 카운터 상태 표시
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // 버튼 클릭 시 카운터 증가
        tooltip: 'Increment', // 툴팁 텍스트
        child: const Icon(Icons.add), // 플러스 아이콘
      ),
    );
  }
}
