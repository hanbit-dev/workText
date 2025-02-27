import 'package:flutter/material.dart';
import 'package:worktext/models/group.dart';
import 'package:provider/provider.dart';
import 'package:worktext/services/friend_service.dart';

class GroupsUserView extends StatefulWidget {
  final Group selectedGroup;
  const GroupsUserView({super.key, required this.selectedGroup});

  @override
  _GroupsUserViewState createState() => _GroupsUserViewState();
}

class _GroupsUserViewState extends State<GroupsUserView> {
  String searchQuery = '';
  List<dynamic> selectedFriends = [];

  List<dynamic> getFilteredFriends(List<dynamic>? friends) {
    if (friends == null) return [];
    if (searchQuery.isEmpty) return friends;
    return friends
        .where((friend) =>
            friend.friendNm.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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
    final filteredFriends = getFilteredFriends(friends);

    return Column(
      children: [
        const Text("그룹 명단 수정",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: "검색어를 입력해 주세요",
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: filteredFriends.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    final friend = filteredFriends[index];
                    return Card(
                      color: Colors.grey[50],
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: selectedFriends.contains(friend),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedFriends.add(friend);
                              } else {
                                selectedFriends.remove(friend);
                              }
                            });
                          },
                          activeColor: Colors.indigoAccent.withOpacity(0.8),
                        ),
                        title: Text(friend.friendNm,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("검색 결과가 없습니다."),
                ),
        ),
      ],
    );
  }
}
