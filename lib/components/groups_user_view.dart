import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/models/group.dart';
import 'package:worktext/services/group_service.dart';

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
    _loadGroupUsers();
  }

  @override
  void didUpdateWidget(GroupsUserView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGroup.id != widget.selectedGroup.id) {
      _loadGroupUsers();
    }
  }

  void _loadGroupUsers() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<GroupsProvider>()
          .getGroupUsersForSelect(widget.selectedGroup.id);

      if (mounted) {
        setState(() {
          selectedFriends = context
              .read<GroupsProvider>()
              .groupUsersForSelect
              .where((friend) => friend['grp_user_id'] != null)
              .toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupsService = Provider.of<GroupsProvider>(context, listen: true);
    final friends = groupsService.groupUsersForSelect;
    final filteredFriends = getFilteredFriends(friends);
    final isLoadingList = groupsService.isLoadingGroupUsersForSelect;
    final isUpdating = groupsService.isUpdatingGroupUsers;

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
          enabled: !isLoadingList,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: isLoadingList
              ? const Center(child: CircularProgressIndicator())
              : filteredFriends.isNotEmpty
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
                              onChanged: isLoadingList
                                  ? null
                                  : (bool? value) {
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
                            title: Text(friend['friend_nm'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("검색 결과가 없습니다."),
                    ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: filteredFriends.isNotEmpty &&
                        selectedFriends.length == filteredFriends.length,
                    onChanged: isLoadingList
                        ? null
                        : (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedFriends = List.from(filteredFriends);
                              } else {
                                selectedFriends.clear();
                              }
                            });
                          },
                    activeColor: Colors.indigoAccent.withOpacity(0.8),
                  ),
                  const Text('전체 선택'),
                ],
              ),
              ElevatedButton(
                onPressed: (isLoadingList || isUpdating || selectedFriends.isEmpty)
                    ? null
                    : () {
                        final grpUsers = selectedFriends
                            .map((friend) => friend['friend_id'])
                            .join(',');

                        groupsService.updateGroupUser(
                          widget.selectedGroup.id,
                          widget.selectedGroup.groupName,
                          grpUsers,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        '수정하기',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
