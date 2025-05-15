import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/components/color_chip.dart';
import 'package:worktext/models/friend.dart';
import 'package:worktext/services/message_service.dart';

class SendMessageCustomSelectView extends StatefulWidget {
  final Function(List<Friend>)? onFriendsSelected;

  const SendMessageCustomSelectView({
    super.key,
    this.onFriendsSelected,
  });

  @override
  State<SendMessageCustomSelectView> createState() =>
      _SendMessageCustomSelectViewState();
}

class _SendMessageCustomSelectViewState
    extends State<SendMessageCustomSelectView> {
  @override
  Widget build(BuildContext context) {
    final messageService = Provider.of<MessageService>(context, listen: true);
    final friends = messageService.friends;

    void setSelectedFriend(Friend friend) {
      messageService.setSelectedFriend(friend);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text("연락처",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
          const SizedBox(height: 20),
          Expanded(
            flex: 1,
            child: friends.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            final friend = friends[index];

                            return Card(
                              color: Colors.grey[50],
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Tooltip(
                                        message: friend.friendNm,
                                        child: Text(
                                          friend.friendNm,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Wrap(
                                        spacing: 4,
                                        children:
                                            (friend.grpNmColor?.split(',') ??
                                                    [])
                                                .map<Widget>((grp) {
                                          final groupName =
                                              grp.split('/').first.trim();
                                          final colorValue =
                                              grp.split('/').last.trim();
                                          return ColorChip(
                                            text: groupName,
                                            backgroundColor:
                                                Color(int.parse(colorValue)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => setSelectedFriend(friend),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text("저장된 연락처가 없습니다. 연락처를 추가해주세요!"),
                  ),
          ),
        ],
      ),
    );
  }
}
