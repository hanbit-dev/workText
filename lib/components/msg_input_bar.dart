import 'package:flutter/material.dart';

class MsgInputBar extends StatefulWidget {
  const MsgInputBar({super.key});

  @override
  _MsgInputBarState createState() => _MsgInputBarState();
}

class _MsgInputBarState extends State<MsgInputBar> {
  bool _isFormal = true; // 존댓말 모드 여부

  void _toggleLanguageMode() {
    setState(() {
      _isFormal = !_isFormal; // 존댓말 모드 전환
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          // color: Color(0xFF333333),
          color: Colors.indigoAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(color: Colors.black),
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "내용을 입력해주세요",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 8), // TextField와 아이콘들 사이의 간격
            Row(
              children: [
                ElevatedButton(
                  onPressed: _toggleLanguageMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent.withOpacity(0.8),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_isFormal ? '존댓말 사용' : '반말 사용'),
                ),
                // IconButton(
                //   icon: Icon(_isFormal ? Icons.people : Icons.person, color: Colors.indigoAccent),
                //   onPressed: _toggleLanguageMode,
                //   tooltip: _isFormal ? '존댓말 사용' : '반말 사용', // 툴팁 추가
                // ),
                Spacer(), // 아이콘들을 왼쪽 정렬하고 전송 버튼을 오른쪽에 배치
                CircleAvatar(
                  backgroundColor: Colors.indigoAccent.withOpacity(0.8),
                  radius: 18,
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward, color: Colors.white),
                    onPressed: () {
                      // 전송 버튼 클릭 시 동작
                    },
                    iconSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
