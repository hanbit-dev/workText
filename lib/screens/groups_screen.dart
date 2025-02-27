import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/components/groups_detail_view.dart';
import 'package:worktext/components/groups_add_view.dart';
import 'package:worktext/models/group.dart';
import 'package:worktext/services/group_service.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<GroupsProvider>().fetch(),
    );
  }

  Group? _selectedGroup;

  // 그룹 추가 다이얼로그
  void _addGroups(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // 외부 클릭으로 닫기
      barrierLabel: "Add Contacts",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Center(
          child: Material(
            color: Colors.transparent,
            child: GroupsAddView(),
          ),
        );
      },
    );
  }

  void _deleteGroup(BuildContext context, int id) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // 외부 클릭으로 닫기
      barrierLabel: "Delete Contacts",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("정말 삭제하시겠습니까?"),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<GroupsProvider>().deleteGroup(id);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("삭제"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("취소"),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget groupView(groups) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text("그룹관리",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
          ),
          const SizedBox(height: 20),
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
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "검색어를 입력해 주세요",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => {_addGroups(context)},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "그룹 추가",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: groups != null && groups.isNotEmpty
                ? ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      print('${group.id} + ${group.groupName}');

                      return Card(
                          color: Colors.grey[50],
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Checkbox(
                              value: group.isSelected ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  group.isSelected = value;
                                });
                              },
                              checkColor: Colors.white,
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
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.grey[600]),
                              onPressed: () {
                                _deleteGroup(context, group.id);
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _selectedGroup = group;
                              });
                            },
                          ));
                    },
                  )
                : const Center(child: Text("저장된 연락처가 없습니다. 연락처를 추가해주세요!")),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: groups != null &&
                      groups.isNotEmpty &&
                      groups.every((group) => group.isSelected == true),
                  onChanged: (bool? value) {
                    setState(() {
                      if (groups != null && groups.isNotEmpty) {
                        for (var group in groups) {
                          group.isSelected = value;
                        }
                      }
                    });
                  },
                  checkColor: Colors.white,
                  activeColor: Colors.indigoAccent.withOpacity(0.8),
                ),
                const Text(
                  "전체 선택",
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () {},
                ),
                const Text("1", style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
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
    final groupsService = Provider.of<GroupsProvider>(context, listen: true);
    final groups = groupsService.groups;

    // selectedGroup 업데이트
    if (_selectedGroup != null && groups != null) {
      _selectedGroup = groups.firstWhere(
        (group) => group.id == _selectedGroup!.id,
        orElse: () => _selectedGroup!,
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: groupView(groups),
        ),
        Expanded(
          flex: 1,
          child: _selectedGroup != null
              ? GroupDetailView(selectedGroup: _selectedGroup!)
              : Container(),
        ),
      ],
    );
  }
}
