import 'package:flutter/material.dart';

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
      backgroundColor: Color.fromRGBO(238, 238, 238, 1.0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // 전체 패딩 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              const Text(
                '메세지 생성하기',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // 텍스트와 TextField 사이 간격
              TextField(
                controller: _controller,
                maxLines: 10, // 줄 수 제한
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '내용을 입력해주세요',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20), // TextField와 버튼 사이 간격
              Row(
                children: [
                  const Text('존댓말'),
                  Checkbox(
                    value: _isChecked,
                    onChanged: _toggleCheckbox, // 상태 변경 함수
                    activeColor: Colors.grey, // 선택 시 체크박스 배경 색상
                    checkColor: Colors.white, // 선택 시 체크 표시 색상
                  ),
                  const Spacer(), // 버튼을 오른쪽으로 밀어내기 위한 Spacer
                  ElevatedButton(
                    onPressed: _saveText,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white54,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('입력'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(_textValue), //테스트용 텍스트 출력 컴포넌트
            ],
          ),
        ),
      ),
    );
  }
}
