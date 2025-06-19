import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/services/friend_service.dart';
import '../../models/friend.dart';

class ContactsEditView extends StatefulWidget {
  final Friend? selectedFriend;
  const ContactsEditView({super.key, required this.selectedFriend});

  @override
  _ContactsEditViewState createState() => _ContactsEditViewState();
}

class _ContactsEditViewState extends State<ContactsEditView> {
  bool _updateHonor = false;
  late TextEditingController _updateNameController;
  late TextEditingController _updatePositionController;

  @override
  void initState() {
    super.initState();

    _updateHonor = widget.selectedFriend?.friendHonor == "y";
    _updateNameController = TextEditingController(text: widget.selectedFriend?.friendNm ?? "-");
    _updatePositionController = TextEditingController(text: widget.selectedFriend?.friendPosition ?? "-");
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _updateNameController.dispose();
    _updatePositionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendsService = Provider.of<FriendsProvider>(context, listen: true);
    final isUpdating = friendsService.isLoading;

    return Container(
      width: 700,
      height: MediaQuery.of(context).size.height * 0.5,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const Text("연락처 수정",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                        )),
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
                                child: Text("이름",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ))),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _updateNameController,
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
                        Row(
                          children: [
                            const SizedBox(
                                width: 100,
                                child: Text("그룹",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ))),
                              Row(
                                children: [
                                  if (widget.selectedFriend?.grpNm == null)
                                    Text("소속 그룹 없음"),
                                  if (widget.selectedFriend?.grpNm != null)
                                  ...(widget.selectedFriend!.grpNm!.split(',')).map<Widget>((grp) {
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
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                                width: 100,
                                child: Text("직책",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ))),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _updatePositionController,
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
                        Row(
                          children: [
                            const SizedBox(
                                width: 100,
                                child: Text("존댓말",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ))),
                            Checkbox(
                              value: _updateHonor,
                              onChanged: (value) {
                                setState(() {
                                  _updateHonor = value ?? false;
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: Colors.indigoAccent.withOpacity(0.8),
                            ),
                            Text(
                                _updateHonor
                                    ? "존댓말 사용"
                                    : "존댓말 사용 안함"
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              onPressed: isUpdating
                                  ? null
                                  : () async {
                                await friendsService.update(
                                    widget.selectedFriend?.id ?? 0,
                                    _updateNameController.text,
                                    _updateHonor ? "y" : "n",
                                    _updatePositionController.text);
                                Navigator.pop(context);
                                await friendsService.fetchDetail(widget.selectedFriend?.id ?? 0);
                              },
                              child: isUpdating
                                ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text("수정"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: isUpdating
                                ? null : () => {
                                Navigator.pop(context)
                              },
                              child: isUpdating
                                ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ) : const Text("닫기"),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}