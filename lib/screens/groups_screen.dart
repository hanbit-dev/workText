import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/components/groups_add_view.dart';
import 'package:worktext/services/group_service.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupsScreen> {
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<GroupsProvider>().fetch(),
    );
  }

  // 그룹 추가 다이얼로그
  void _addGroups(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // 외부 클릭으로 닫기
      barrierLabel: "Add Contacts",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: GroupsAddView(),
          ),
        );
      },
    );
  }

  void _deleteGroups(BuildContext context, int id) {
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
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("정말 삭제하시겠습니까?"),
                    SizedBox(height: 16),
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
                          child: Text("삭제"),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("취소"),
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

  @override
  Widget build(BuildContext context) {
    final groupsService = Provider.of<GroupsProvider>(context, listen: true);
    final groups = groupsService.groups;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 50 - 32,
              child: Column(
                children: [
                  const Center(
                    child: Column(
                      children: [
                        Text("그룹관리",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                        onPressed: () => {_addGroups(context)},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("그룹 추가",
                            style: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      child: groups != null && groups.length > 0
                          ? ListView.builder(
                              itemCount: groups.length,
                              itemBuilder: (context, index) {
                                final group = groups[index];
                                print('${group.id} + ${group.groupName}');

                                return Card(
                                    color: Colors.grey[50],
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: true,
                                        onChanged: (value) {},
                                        checkColor: Colors.white,
                                        activeColor: Colors.indigoAccent
                                            .withOpacity(0.8),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(group.groupName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(width: 8), // 텍스트와 컬러박스 사이 간격
                                          Container(
                                            width: 16, // 컬러박스 너비
                                            height: 16, // 컬러박스 높이
                                            decoration: BoxDecoration(
                                              color: Color(int.parse(group
                                                  .groupColor)), // 문자열 컬러코드를 Color로 변환
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      4), // 선택사항: 모서리 둥글게
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.grey[600]),
                                        onPressed: () {
                                          _deleteGroups(context, group.id);
                                        },
                                      ),
                                    ));
                              },
                            )
                          : Text("저장된 연락처가 없습니다. 연락처를 추가해주세요!"),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              child: Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                    checkColor: Colors.white,
                    activeColor: Colors.indigoAccent.withOpacity(0.8),
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
      ),
    );
  }
}
