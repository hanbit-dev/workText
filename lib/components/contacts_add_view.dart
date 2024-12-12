import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/services/friend_service.dart';

class ContactsAddView extends StatefulWidget {
  const ContactsAddView({super.key});

  @override
  _ContactsAddViewState createState() => _ContactsAddViewState();
}

class _ContactsAddViewState extends State<ContactsAddView> {

  @override
  Widget build(BuildContext context) {
    final friendsService = Provider.of<FriendsProvider>(context, listen: true);

    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
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
                            "연락처 추가",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("이름", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 20,),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
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
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("그룹", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 20,),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
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
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("직책", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 20,),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
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
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("존댓말", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Checkbox(
                                  value: true,
                                  onChanged: (value) {},
                                  checkColor: Colors.white,
                                  activeColor: Colors.indigoAccent.withOpacity(0.8),
                                ),
                              ],
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
                onPressed: () => {
                  //TODO: 연락처 정보 서버 전송
                  friendsService.add("권희연이")
                },
                child: const Text("추가"),
              ),
              const SizedBox(width: 10,),
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
