import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/components/msg_input_bar.dart';
import 'package:worktext/components/send_message/send_message_custom_input_view.dart';
import 'package:worktext/components/send_message/send_message_custom_select_view.dart';
import 'package:worktext/components/send_message/send_message_generate_select_view.dart';
import 'package:worktext/models/friend.dart';
import 'package:worktext/models/message.dart';
import 'package:worktext/services/message_service.dart';

class SendMessageScreen extends StatefulWidget {
  const SendMessageScreen({super.key});

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Friend> selectedFriends = [];

  void _sendMessage() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메시지 내용을 입력해주세요')),
      );
      return;
    }

    if (selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메시지를 보낼 연락처를 선택해주세요')),
      );
      return;
    }

    List<String> friendIds =
        selectedFriends.map((friend) => friend.id.toString()).toList();

    try {
      await Provider.of<MessageService>(context, listen: false)
          .generateMessage(_messageController.text, friendIds);

      await Provider.of<MessageService>(context, listen: false)
          .setFriends(selectedFriends);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메시지가 생성되었습니다')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메시지 생성 중 오류가 발생했습니다: $e')),
      );
    }
  }

  Widget createMessageView() {
    final selectedFriend =
        Provider.of<MessageService>(context, listen: true).selectedFriend;

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
            child: Row(
              children: [
                const Text(
                  '받는 사람',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedFriends.map((friend) => friend.friendNm).join(', '),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${selectedFriends.length}명 선택됨',
                  style: TextStyle(
                    color: Colors.indigoAccent.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: MsgInputBar(
              textController: _messageController,
              onSendMessage: _sendMessage,
            ),
          ),
          selectedFriend != null
              ? const SizedBox(height: 20)
              : const SizedBox.shrink(),
          selectedFriend != null
              ? Expanded(
                  child: SendMessageCustomInputView(
                    selectedFriend: selectedFriend,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Message> generatedMessages =
        Provider.of<MessageService>(context, listen: true).messages;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: createMessageView(),
        ),
        Expanded(
          flex: 1,
          child: generatedMessages.isEmpty
              ? SendMessageGenerateSelectView(
                  onFriendsSelected: (friends) {
                    setState(() {
                      selectedFriends = friends;
                    });
                  },
                )
              : const SendMessageCustomSelectView(),
        ),
      ],
    );
  }
}
