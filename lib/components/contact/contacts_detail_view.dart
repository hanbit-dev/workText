import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/services/friend_service.dart';
import '../../models/friend.dart';

class ContactsDetailView extends StatefulWidget {
  final Friend selectedFriend;
  const ContactsDetailView({super.key, required this.selectedFriend});

  @override
  _ContactsDetailViewState createState() => _ContactsDetailViewState();
}

class _ContactsDetailViewState extends State<ContactsDetailView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<FriendsProvider>().fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friendsService = Provider.of<FriendsProvider>(context, listen: true);
    final friend = widget.selectedFriend;
    final friendUsers = friendsService.friends;

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
                        const Text("연락처 상세",
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
                                Text(
                                  friend.friendNm,
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
                                    child: Text("나이",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ))),
                                Text(
                                  "나이",
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
                                Text(
                                  "그룹",
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
                                Text(
                                  "직책",
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
                                  value: true,
                                  onChanged: (value) {},
                                  checkColor: Colors.white,
                                  activeColor: Colors.indigoAccent.withOpacity(0.8),
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
                                  onPressed: () => {
                                  },
                                  child: const Text("수정"),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}