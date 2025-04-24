import 'package:flutter/material.dart';

class MsgInputBar extends StatefulWidget {
  final TextEditingController? textController;
  final VoidCallback? onSendMessage;

  const MsgInputBar({
    super.key,
    this.textController,
    this.onSendMessage,
  });

  @override
  _MsgInputBarState createState() => _MsgInputBarState();
}

class _MsgInputBarState extends State<MsgInputBar> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = widget.textController ?? TextEditingController();
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
                controller: _textController,
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
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.indigoAccent.withOpacity(0.8),
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                    onPressed: widget.onSendMessage,
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
