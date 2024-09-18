import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '문자보내기 화면',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}