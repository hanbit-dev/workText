import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/friend.dart';
import '../../services/friend_service.dart';
import '../../services/group_service.dart';

class ContactsGroupView extends StatefulWidget {
  final Friend selectedFriend;
  const ContactsGroupView({super.key, required this.selectedFriend});

  @override
  _ContactsGroupViewState createState() => _ContactsGroupViewState();
}

class _ContactsGroupViewState extends State<ContactsGroupView> {
  List<dynamic> _selectedGroups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    if (!mounted) return;
    Future.microtask(() async {
      final groupProvider = context.read<GroupsProvider>();
      final friendsProvider = context.read<FriendsProvider>();
      await groupProvider.fetch();

      if (!mounted) return;
      setState(() {
        _selectedGroups = (groupProvider.groups ?? [])
            .where((group) => friendsProvider.friendDetails?.grpNm != null &&
            group.groupName == friendsProvider.friendDetails!.grpNm?.split('/').first.trim())
            .toList();
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final friendsService = Provider.of<FriendsProvider>(context, listen: true);
    final friends = friendsService.friends;
    final groupsService = Provider.of<GroupsProvider>(context, listen: true);
    final groups = groupsService.groups;
    final isUpdating = groupsService.isUpdatingGroupUsers;

    return Column(
      children: [
        const Text("소속 그룹 수정",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) {
            setState(() {
              // searchQuery = value;
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
          enabled: true//!isLoadingList,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: groups != null && groups.isNotEmpty ? ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return Card(
                color: Colors.grey[50],
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: _selectedGroups.contains(group),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedGroups.add(group);
                          } else {
                            _selectedGroups.remove(group);
                          }
                        });
                      },
                      activeColor: Colors.indigoAccent.withOpacity(0.8),
                    ),
                    title: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Color(int.parse(group.groupColor)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(group.groupName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        if (_selectedGroups.contains(group)) {
                          _selectedGroups.remove(group);
                        } else {
                          _selectedGroups.add(group);
                        }
                      });
                    },
                  )
              );
            },
          )
          : const Center(child: Text("저장된 그룹이 없습니다. 그룹을 추가해주세요!")),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (groups != null)
                  Checkbox(
                    value: groups.isNotEmpty && _selectedGroups.length == groups.length,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedGroups = List.from(groups);
                        } else {
                          _selectedGroups.clear();
                        }
                      });
                    },
                    activeColor: Colors.indigoAccent.withOpacity(0.8),
                  ),
                  const Text('전체 선택'),
                ],
              ),
              ElevatedButton(
                onPressed: (isUpdating) ? null : () {
                  final userGrps = _selectedGroups
                      .map((group) => group['id'])
                      .join(',');

                  // groupsService.updateGroupUser(
                  //   widget.selectedGroup.id,
                  //   widget.selectedGroup.groupName,
                  //   grpUsers,
                  // );
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