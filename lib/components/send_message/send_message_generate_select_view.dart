import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/components/color_chip.dart';
import 'package:worktext/models/friend.dart';
import 'package:worktext/services/friend_service.dart';

class SendMessageGenerateSelectView extends StatefulWidget {
  final Function(List<Friend>)? onFriendsSelected;

  const SendMessageGenerateSelectView({
    super.key,
    this.onFriendsSelected,
  });

  @override
  State<SendMessageGenerateSelectView> createState() =>
      _SendMessageGenerateSelectViewState();
}

class _SendMessageGenerateSelectViewState
    extends State<SendMessageGenerateSelectView> {
  List<Friend> selectedContactsToAdd = [];
  List<Friend> selectedContactsToRemove = [];
  List<Friend> addedFriends = [];

  List<Friend> getSelectedFriends() {
    return List<Friend>.from(addedFriends);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<FriendsProvider>().fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friendsService = Provider.of<FriendsProvider>(context, listen: true);
    final friends = friendsService.friends;
    void selectAllContacts() {
      setState(() {
        if (selectedContactsToAdd.length == (friends?.length ?? 0)) {
          selectedContactsToAdd = [];
        } else {
          selectedContactsToAdd = [...(friends ?? [])];
        }
      });
    }

    void addFriends() {
      setState(() {
        addedFriends = [
          ...{...addedFriends, ...selectedContactsToAdd}
        ];
        if (widget.onFriendsSelected != null) {
          widget.onFriendsSelected!(addedFriends);
        }
      });
    }

    void removeFriends() {
      setState(() {
        addedFriends = addedFriends
            .where((friend) => !selectedContactsToRemove.contains(friend))
            .toList();
        if (widget.onFriendsSelected != null) {
          widget.onFriendsSelected!(addedFriends);
        }
      });
    }

    void selectAllContactsToRemove() {
      setState(() {
        if (selectedContactsToRemove.length == addedFriends.length) {
          selectedContactsToRemove = [];
        } else {
          selectedContactsToRemove = [...addedFriends];
        }
      });
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
            child: friends != null && friends.isNotEmpty
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
                                leading: IconButton(
                                  icon: Icon(
                                    selectedContactsToAdd.contains(friend)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: selectedContactsToAdd
                                            .contains(friend)
                                        ? Colors.indigoAccent.withOpacity(0.8)
                                        : Colors.grey[500],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (selectedContactsToAdd
                                          .contains(friend)) {
                                        selectedContactsToAdd.remove(friend);
                                      } else {
                                        selectedContactsToAdd.add(friend);
                                      }
                                    });
                                  },
                                ),
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
                                onTap: () {
                                  setState(() {
                                    if (selectedContactsToAdd
                                        .contains(friend)) {
                                      selectedContactsToAdd.remove(friend);
                                    } else {
                                      selectedContactsToAdd.add(friend);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: selectAllContacts,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.indigoAccent.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              '전체선택',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor:
                                Colors.indigoAccent.withOpacity(0.8),
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_downward,
                                  color: Colors.white),
                              onPressed: addFriends,
                              iconSize: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : const Center(
                    child: Text("저장된 연락처가 없습니다. 연락처를 추가해주세요!"),
                  ),
          ),
          const SizedBox(height: 25),
          Expanded(
            flex: 1,
            child: addedFriends.isNotEmpty
                ? Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: selectAllContactsToRemove,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.indigoAccent.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              '전체선택',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                          const Text('메세지 전송 리스트',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor:
                                Colors.indigoAccent.withOpacity(0.8),
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_upward,
                                  color: Colors.white),
                              onPressed: removeFriends,
                              iconSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: addedFriends.length,
                          itemBuilder: (context, index) {
                            final friend = addedFriends[index];
                            return Card(
                              color: Colors.grey[50],
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: IconButton(
                                  icon: Icon(
                                    selectedContactsToRemove.contains(friend)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: selectedContactsToRemove
                                            .contains(friend)
                                        ? Colors.indigoAccent.withOpacity(0.8)
                                        : Colors.grey[500],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (selectedContactsToRemove
                                          .contains(friend)) {
                                        selectedContactsToRemove.remove(friend);
                                      } else {
                                        selectedContactsToRemove.add(friend);
                                      }
                                    });
                                  },
                                ),
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
                                onTap: () {
                                  setState(() {
                                    if (selectedContactsToRemove
                                        .contains(friend)) {
                                      selectedContactsToRemove.remove(friend);
                                    } else {
                                      selectedContactsToRemove.add(friend);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text("메시지를 생성할 연락처를 선택해주세요!"),
                  ),
          ),
        ],
      ),
    );
  }
}
