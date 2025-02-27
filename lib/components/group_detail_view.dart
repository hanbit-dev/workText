import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/components/groups_edit_view.dart';
import 'package:worktext/models/group.dart';
import 'package:worktext/services/group_service.dart';

class GroupDetailView extends StatefulWidget {
  final Group selectedGroup;
  const GroupDetailView({super.key, required this.selectedGroup});

  @override
  _GroupDetailViewState createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends State<GroupDetailView> {
  Color pickerColor = Colors.blue;
  final TextEditingController _nameController = TextEditingController();
  void changeColor(Color color) => setState(() => pickerColor = color);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GroupsProvider>().getGroupUsers(widget.selectedGroup.id);
    });
  }

  @override
  void didUpdateWidget(GroupDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGroup.id != widget.selectedGroup.id) {
      Future.microtask(() {
        context.read<GroupsProvider>().getGroupUsers(widget.selectedGroup.id);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupsService = Provider.of<GroupsProvider>(context, listen: true);
    final group = widget.selectedGroup;
    final groupUsers = groupsService.groupUsers;

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 32,
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Text("그룹상세",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24)),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text("그룹이름",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))),
                                Text(
                                  group.groupName,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text("색깔",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))),
                                Container(
                                  width: 32,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(group.groupColor)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text("그룹명단",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))),
                                Text(groupUsers.isNotEmpty
                                    ? groupUsers
                                        .map((user) =>
                                            user['friend_nm'].toString())
                                        .join(', ')
                                    : "로딩중..."),
                                const Spacer(),
                                Icon(Icons.add_circle_outline,
                                    color: Colors.grey[900])
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel: "그룹 수정",
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return Center(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: GroupsEditView(
                                                selectedGroup: group),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("수정"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
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
