import 'package:flutter/material.dart';
import 'package:worktext/components/msg_input_bar.dart';
import 'package:worktext/components/send_message/send_message_select_view.dart';

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
        _controller.text = _controller.text + '요';
      } else {
        _controller.text = _controller.text.replaceAll('요', '');
      }
    });
  }

  Widget createMessageView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Center(
            child: Text(
              '메세지 생성하기',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Row(
              children: [
                Text('받는 사람'),
                Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: MsgInputBar(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: createMessageView(),
        ),
        Expanded(
          flex: 1,
          child: SendMessageSelectView(),
        ),
      ],
    );
  }
}
