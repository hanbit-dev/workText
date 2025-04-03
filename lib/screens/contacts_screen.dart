import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/components/contact/contacts_add_view.dart';
import 'package:worktext/components/contact/contacts_detail_view.dart';
import 'package:worktext/services/friend_service.dart';
import '../models/friend.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Friend? _selectedFriend;
  var selectedContacts = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<FriendsProvider>().fetch(),
    );
  }

  List<Map<String, dynamic>> contacts = [
    {"name": "조미란", "tags": ["교회", "1청"]},
    {"name": "김선재", "tags": ["교회", "1청"]},
    {"name": "권희연", "tags": ["교회", "2청"]},
    {"name": "윤태양", "tags": ["교회", "1청", "회사"]},
    {"name": "아무개", "tags": ["회사"]},
  ];

  List<Map<String, dynamic>> groups = [
    {"name": "교회", "color": "0xFFFFC1C1"},
    {"name": "1청", "color": "0xFFCCE0FF"},
    {"name": "회사", "color": "0xFFBDBDBD"},
    {"name": "2청", "color": "0xFFFFC1C1"},
    {"name": "게임", "color": "0xFFBDBDBD"},
    {"name": "커뮤니티", "color": "0xFFFFC1C1"},
  ];

  // 그룹에 + 버튼 클릭 시 아래에 새로운 화면 띄우기
  void _showGroupDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // BottomSheet 크기 조정 가능
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "검색어를 입력해 주세요",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded( //그룹 리스트 영역
                  child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (value) {},
                            checkColor: Colors.white,
                            activeColor: Colors.indigoAccent.withOpacity(0.8),
                          ),
                          Chip(
                              label: Text(group["name"]),
                              backgroundColor: Color(int.parse(group["color"]))
                          )
                        ],
                      );
                    },
                  ),
              ),
              Row( //버튼 영역
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                    checkColor: Colors.white,
                    activeColor: Colors.indigoAccent.withOpacity(0.8),
                  ),
                  Text("전체 선택", style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // 그룹에 관련된 추가 작업 수행
                      Navigator.pop(context); // BottomSheet 닫기
                    },
                    child: Text("선택"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
                            selectedContacts.forEach((contact) {
                              context.read<FriendsProvider>().delete(
                                  contact.id);
                            });
                            selectedContacts = [];
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

  Widget contactView(friends) {
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
                value: "전체",
                items: ["전체", "교회", "회사"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
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
                  if (selectedContacts.isNotEmpty) {
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
            child: friends != null && friends.length > 0 ? ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return Card(
                  color: Colors.grey[50],
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading:
                    IconButton(
                      icon: Icon(
                        selectedContacts.contains(friend) ? Icons.check_box : Icons.check_box_outline_blank,
                        color: selectedContacts.contains(friend) ? Colors.indigoAccent.withOpacity(0.8) : Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          if (selectedContacts.contains(friend)) {
                            selectedContacts.remove(friend);
                          } else {
                            selectedContacts.add(friend);
                          }
                        });
                      },
                    ),
                    title:
                        Row(
                          children: [
                            Text(friend.friendNm, style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            ...friend.grpNmColor.split(',').map<Widget>((grp) {
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
                    // subtitle: Row(
                      // children: friend["tags"].map<Widget>((tag) {
                      //   return Padding(
                      //     padding: const EdgeInsets.only(right: 4.0),
                      //     child: Chip(
                      //       label: Text(tag, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      //       backgroundColor: tag == "교회"
                      //           ? Colors.red[100]
                      //           : tag == "1청"
                      //           ? Colors.blue[100]
                      //           : Colors.grey[400],
                      //     ),
                      //   );
                      // }).toList(),
                    // ),
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
                    (selectedContacts.length == (friends?.length ?? 0)) ? Icons.check_box : Icons.check_box_outline_blank,
                    color: selectedContacts.length == (friends?.length ?? 0) ? Colors.indigoAccent.withOpacity(0.8) : Colors.grey[500],
                  ),
                  onPressed: () {
                    setState(() {
                      if (selectedContacts.length == (friends?.length ?? 0)) {
                        selectedContacts = [];
                      } else {
                        selectedContacts = [...(friends ?? [])];
                      }
                    });
                  },
                ),
                Text("전체 선택", style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () {},
                ),
                Text("1", style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {},
                ),
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
          child: contactView(friends)
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
