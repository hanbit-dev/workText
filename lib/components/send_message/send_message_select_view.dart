import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/models/friend.dart';
import 'package:worktext/services/friend_service.dart';

class SendMessageSelectView extends StatefulWidget {
  const SendMessageSelectView({super.key});

  @override
  _SendMessageSelectViewState createState() => _SendMessageSelectViewState();
}

class _SendMessageSelectViewState extends State<SendMessageSelectView> {
  List<Friend> selectedContactsToAdd = [];
  List<Friend> selectedContactsToRemove = [];

  Friend? _selectedFriend;
  List<Friend> addedFriends = [];

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
      });
    }

    void removeFriends() {
      setState(() {
        addedFriends = addedFriends
            .where((friend) => !selectedContactsToRemove.contains(friend))
            .toList();
      });
    }

    void selectAllContactsToRemove() {
      setState(() {
        if (selectedContactsToRemove.length == (addedFriends?.length ?? 0)) {
          selectedContactsToRemove = [];
        } else {
          selectedContactsToRemove = [...(addedFriends ?? [])];
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
            child: friends != null && friends.length > 0
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
                              margin: EdgeInsets.symmetric(vertical: 4),
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
                                title: Text(friend.friendNm,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onTap: () {
                                  setState(() {
                                    _selectedFriend = friend;
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
                            child: Text(
                              '전체선택',
                              style: const TextStyle(color: Colors.white),
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
                : Center(
                    child: Text("저장된 연락처가 없습니다. 연락처를 추가해주세요!"),
                  ),
          ),
          const SizedBox(height: 25),
          Expanded(
            flex: 1,
            child: addedFriends != null && addedFriends.length > 0
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
                            child: Text(
                              '전체선택',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
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
                              margin: EdgeInsets.symmetric(vertical: 4),
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
                                title: Text(friend.friendNm,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onTap: () {
                                  setState(() {
                                    _selectedFriend = friend;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text("메시지를 생성할 연락처를 선택해주세요!"),
                  ),
          ),
        ],
      ),
    );
  }
}
