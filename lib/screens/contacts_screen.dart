import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Map<String, dynamic>> contacts = [
    {"name": "조미란", "tags": ["교회", "1청"]},
    {"name": "김선재", "tags": ["교회", "1청"]},
    {"name": "권희연", "tags": ["교회", "2청"]},
    {"name": "윤태양", "tags": ["교회", "1청", "회사"]},
    {"name": "아무개", "tags": ["회사"]},
  ];

  void _addContact(Map<String, dynamic> contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  void _removeContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void _showContactDetails(BuildContext context, Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: const Text(
            "연락처 상세",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Text("이름", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15,),
                    Text("나이", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15,),
                    Text("그룹", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15,),
                    Text("존댓말", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15,),
                    Text("직책", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 50,),
                  ],
                ),
                const SizedBox(width: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Text(contact["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                    const SizedBox(height: 10,),
                    Text("31", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                    const SizedBox(height: 10,),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: contact["tags"].map<Widget>((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: tag == "교회"
                              ? Colors.red[100]
                              : tag == "1청"
                              ? Colors.blue[100]
                              : Colors.grey[400],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10,),
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      checkColor: Colors.white,
                      activeColor: Colors.indigoAccent.withOpacity(0.8),
                    ),
                    const SizedBox(height: 10,),
                    Text("대리", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                    const SizedBox(height: 50,),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text("수정"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Column(
              children: [
                Text("연락처", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
              ],
            ),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("추가", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("수정", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("삭제", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Card(
                  color: Colors.grey[50],
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: true,
                      onChanged: (value) {},
                      checkColor: Colors.white,
                      activeColor: Colors.indigoAccent.withOpacity(0.8),
                    ),
                    title: Text(contact["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: contact["tags"].map<Widget>((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Chip(
                            label: Text(tag, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            backgroundColor: tag == "교회"
                                ? Colors.red[100]
                                : tag == "1청"
                                ? Colors.blue[100]
                                : Colors.grey[400],
                          ),
                        );
                      }).toList(),
                    ),
                    onTap: () => _showContactDetails(context, contact), // 항목 클릭 시 팝업 호출
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey[600]),
                      onPressed: () => _removeContact(index),
                    ),
                  ),
                );
              },
            ),
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
