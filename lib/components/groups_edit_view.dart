import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:worktext/models/group.dart';
import 'package:worktext/services/group_service.dart';

class GroupsEditView extends StatefulWidget {
  final Group selectedGroup;
  const GroupsEditView({super.key, required this.selectedGroup});

  @override
  _GroupsEditViewState createState() => _GroupsEditViewState();
}

class _GroupsEditViewState extends State<GroupsEditView> {
  Color pickerColor = Colors.blue;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // 디버깅을 위한 print 추가
    print('Selected Group Name: ${widget.selectedGroup.groupName}');

    // 그룹 색상 초기화
    pickerColor = Color(int.parse(widget.selectedGroup.groupColor));
    // 그룹 이름 초기화
    _nameController =
        TextEditingController(text: widget.selectedGroup.groupName);

    // 초기화 후 컨트롤러 값 확인
    print('Controller Text: ${_nameController.text}');
  }

  void changeColor(Color color) => setState(() => pickerColor = color);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupsService = Provider.of<GroupsProvider>(context, listen: true);
    final group = widget.selectedGroup;

    return Container(
      width: 700,
      height: MediaQuery.of(context).size.height * 0.7,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "그룹 수정",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("그룹이름",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: "텍스트를 입력하세요",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await groupsService.updateGroup(
                      group.id, // 그룹 ID
                      '0x${pickerColor.value.toRadixString(16)}', // 색상
                      _nameController.text // 이름
                      );
                  Navigator.pop(context);
                },
                child: const Text("수정"),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("닫기"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
