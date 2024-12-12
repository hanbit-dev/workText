import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final groupsService = Provider.of<GroupsProvider>(context, listen: true);
    final groups = groupsService.groups;
    print(groups);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: () => {
                  //TODO: 그룹 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("그룹 추가", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => {
                  //TODO: 그룹 수정
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("그룹 수정", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 300,
            child: groups != null && groups.length > 0
                ? ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return Card(
                          color: Colors.grey[50],
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Checkbox(
                              value: true,
                              onChanged: (value) {},
                              checkColor: Colors.white,
                              activeColor: Colors.indigoAccent.withOpacity(0.8),
                            ),
                            title: Row(
                              children: [
                                Text(group.groupName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 8), // 텍스트와 컬러박스 사이 간격
                                Container(
                                  width: 16, // 컬러박스 너비
                                  height: 16, // 컬러박스 높이
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(group
                                        .groupColor)), // 문자열 컬러코드를 Color로 변환
                                    borderRadius: BorderRadius.circular(
                                        4), // 선택사항: 모서리 둥글게
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.grey[600]),
                              onPressed: () => {},
                            ),
                          ));
                    },
                  )
                : Text("저장된 연락처가 없습니다. 연락처를 추가해주세요!"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }
}
