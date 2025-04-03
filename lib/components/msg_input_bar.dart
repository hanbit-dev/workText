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
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: "내용을 입력해주세요",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _toggleLanguageMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _isFormal ? '존댓말 사용' : '반말 사용',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.indigoAccent.withOpacity(0.8),
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                    onPressed: () {
                      // 전송 버튼 클릭 시 동작
                    },
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
