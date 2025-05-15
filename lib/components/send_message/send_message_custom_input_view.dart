import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/models/friend.dart';
import 'package:worktext/services/message_service.dart';

class SendMessageCustomInputView extends StatefulWidget {
  final Friend selectedFriend;

  const SendMessageCustomInputView({
    super.key,
    required this.selectedFriend,
  });

  @override
  State<SendMessageCustomInputView> createState() =>
      _SendMessageCustomInputViewState();
}

class _SendMessageCustomInputViewState
    extends State<SendMessageCustomInputView> {
  @override
  Widget build(BuildContext context) {
    final messageService = Provider.of<MessageService>(context, listen: true);
    final message = messageService.messageMap[widget.selectedFriend.friendNm];

    return Container(
      child: Column(
        children: [
          Text(message?.content ?? ''),
        ],
      ),
    );
  }
}
