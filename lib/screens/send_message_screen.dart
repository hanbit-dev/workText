import 'package:flutter/material.dart';
import 'package:worktext/components/msg_input_bar.dart';

class SendMessageScreen extends StatefulWidget {
  const SendMessageScreen({super.key});

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  String _textValue = ''; // 입력된 값을 저장할 변수
  bool _isChecked = false; // 체크박스 상태를 저장할 변수

  void _saveText() {
    setState(() {
      _textValue = _controller.text; // 입력 값을 변수에 저장
    });
    print("입력한 값: $_textValue"); // 저장된 값 확인
  }

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false; // null이 아닌 경우로 처리
      if (_isChecked && _controller.text.isNotEmpty) {
        _controller.text =  _controller.text + '요';
      } else {
        _controller.text = _controller.text.replaceAll('요', '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(238, 238, 238, 1.0),
      backgroundColor: Colors.indigo.withOpacity(0.1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // 전체 패딩 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              const Text(
                '메세지 생성하기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // 텍스트와 TextField 사이 간격
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                decoration: BoxDecoration(
                    color: Colors.indigoAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: const Row(
                  children: [
                    Text('받는 사람'),
                    Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MsgInputBar(), // 하단에 ChatInputBar 추가
              const SizedBox(height: 20), // TextField와 버튼 사이 간격
            ],
          ),
        ),
      ),
    );
  }
}
