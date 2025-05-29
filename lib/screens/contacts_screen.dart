import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/components/contact/contacts_add_view.dart';
import 'package:worktext/components/contact/contacts_detail_view.dart';
import 'package:worktext/services/friend_service.dart';
import 'package:worktext/services/group_service.dart';
import '../models/friend.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Friend? _selectedFriend;
  String? _selectedGroupName = "전체";
  List<String>? _groupNames = [];
  var _selectedContacts = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<Friend>? _filteredFriends;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    Future.microtask(() async {
      final friendProvider = context.read<FriendsProvider>();
      final groupProvider = context.read<GroupsProvider>();
      await friendProvider.fetch();
      await groupProvider.fetch();

      if (!mounted) return;
      setState(() {
        _groupNames = ['전체', ...?groupProvider.groups?.map((group) => group.groupName ?? '').toList()];
        _selectedGroupName = '전체';
        _applyFilters(friendProvider.friends);
      });
    });
  }

  //연락처 추가 다이얼로그
  void _addContacts(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // 외부 클릭으로 닫기
      barrierLabel: "Add Contacts",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
            child: Material(
            color: Colors.transparent,
            child: ContactsAddView(),
          ),
        );
      },
    );
  }

  void _deleteContacts(BuildContext context, {int id = 0, bool allDelete = false}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      // 외부 클릭으로 닫기
      barrierLabel: "Delete Contacts",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.25,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "연락처 삭제",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Text("연락처를 삭제하시겠습니까?"),
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (allDelete) {
                            _selectedContacts.forEach((contact) {
                              context.read<FriendsProvider>().delete(
                                  contact.id);
                            });
                            _selectedContacts = [];
                          } else {
                            context.read<FriendsProvider>().delete(id);
                          }
                          context.read<FriendsProvider>().fetch();
                          Navigator.pop(context);
                        },
                        child: const Text("삭제"),
                      ),
                      const SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("취소"),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _applyFilters(List<Friend>? friends) {
    setState(() {
      _filteredFriends = (friends ?? []).where((friend) {
        final matchesName = friend.friendNm.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesGroup = _selectedGroupName == null || _selectedGroupName == '전체'
            ? true
            : (friend.grpNmColor ?? "").split(',').any((grp) =>
        _selectedGroupName == grp.split('/').first.trim());
        return matchesName && matchesGroup;
      }).toList();
    });
  }

  Widget contactView(List<Friend>? friends, groups) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text("연락처", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              DropdownButton<String>(
                value: _selectedGroupName,
                items: _groupNames == null ? [] : _groupNames?.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGroupName = value;
                    _applyFilters(friends);
                  });
                },
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _applyFilters(friends);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "검색어를 입력해 주세요",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => {
                  _addContacts(context) //연락처 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("추가", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => {
                  //연락처 삭제
                  if (_selectedContacts.isNotEmpty) {
                    _deleteContacts(context, allDelete: true)
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("삭제", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: _filteredFriends != null && _filteredFriends!.isNotEmpty ? ListView.builder(
              itemCount: _filteredFriends!.length,
              itemBuilder: (context, index) {
                final friend = _filteredFriends![index];
                return Card(
                  color: Colors.grey[50],
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading:
                    IconButton(
                      icon: Icon(
                        _selectedContacts.contains(friend) ? Icons.check_box : Icons.check_box_outline_blank,
                        color: _selectedContacts.contains(friend) ? Colors.indigoAccent.withOpacity(0.8) : Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          if (_selectedContacts.contains(friend)) {
                            _selectedContacts.remove(friend);
                          } else {
                            _selectedContacts.add(friend);
                          }
                        });
                      },
                    ),
                    title:
                        Row(
                          children: [
                            Text(friend.friendNm, style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            if (friend.grpNmColor != null)
                            ...?friend.grpNmColor?.split(',').map<Widget>((grp) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Chip(
                                  label: Text(grp.split('/').first.trim(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  backgroundColor: Color(int.parse(grp.split('/').last.trim())),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                    trailing:
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey[600]),
                            onPressed: () => _deleteContacts(context, id: friend.id)
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _selectedFriend = friend;
                      });
                    },
                  ),
                );
              },
            ) : Text("저장된 연락처가 없습니다. 연락처를 추가해주세요!"),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    (_selectedContacts.length == (friends?.length ?? 0)) ? Icons.check_box : Icons.check_box_outline_blank,
                    color: _selectedContacts.length == (friends?.length ?? 0) ? Colors.indigoAccent.withOpacity(0.8) : Colors.grey[500],
                  ),
                  onPressed: () {
                    setState(() {
                      if (_selectedContacts.length == (friends?.length ?? 0)) {
                        _selectedContacts = [];
                      } else {
                        _selectedContacts = [...(friends ?? [])];
                      }
                    });
                  },
                ),
                const Text("전체 선택", style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                // IconButton(
                //   icon: Icon(Icons.arrow_left),
                //   onPressed: () {},
                // ),
                // Text("1", style: TextStyle(fontWeight: FontWeight.bold)),
                // IconButton(
                //   icon: Icon(Icons.arrow_right),
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friendsService = Provider.of<FriendsProvider>(context, listen: true);
    final friends = friendsService.friends;
    final groupService = Provider.of<GroupsProvider>(context, listen: true);
    final groups = groupService.groups;

    // selectedContact 업데이트
    if (_selectedFriend != null && friends != null) {
      _selectedFriend = friends.firstWhere(
            (friend) => friend.id == _selectedFriend!.id,
        orElse: () => _selectedFriend!,
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: contactView(friends, groups)
        ),
        Expanded(
          flex: 3,
          child: _selectedFriend != null
              ? ContactsDetailView(selectedFriend: _selectedFriend!)
              : Container(),
        )
      ],
    );
  }
}
