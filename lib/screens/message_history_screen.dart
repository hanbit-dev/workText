import 'package:flutter/material.dart';

class MessageHistoryScreen extends StatelessWidget {
  const MessageHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {
        'id': 11,
        'content': '새해복 많이 받으세요',
        'sender': '윤태양, 아무개',
        'groups': ['교회', '1청', '회사'],
        'date': '2024.01.01',
      },
      {
        'id': 10,
        'content': '안녕하세요, 1청 회장입니다. 이번주 금요일은 성탄절로 오전에 예배가...',
        'sender': '조미란, 김선재, 권...',
        'groups': ['교회', '1청'],
        'date': '2023.12.21',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('문자 내역')),
      body: Column(
        children: [
          _buildHeaderFilter(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageRow(
                  context,
                  id: msg['id'].toString(),
                  content: msg['content'] as String,
                  sender: msg['sender'] as String,
                  groups: List<String>.from(msg['groups'] as List),
                  date: msg['date'] as String,
                );
              },
            ),
          ),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildHeaderFilter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          DropdownButton<String>(
            value: '전체',
            items: ['전체', '교회', '1청', '회사']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {},
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색어를 입력해 주세요',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 함수 정의 수정
  Widget _buildMessageRow (
    BuildContext context, {
      required String id,
      required String content,
      required String sender,
      required List<String> groups,
      required String date,
    }) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('메시지 상세보기'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('번호: $id'),
                SizedBox(height: 8),
                Text('보낸 사람: $sender'),
                SizedBox(height: 8),
                Text('날짜: $date'),
                SizedBox(height: 12),
                Text('내용:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(content),
                SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: groups.map((g) => _buildGroupTag(g)).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('닫기'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            SizedBox(width: 30, child: Text(id, style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(width: 12),
            Expanded(child: Text(content, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 12),
            SizedBox(width: 150, child: Text(sender, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 12),
            Row(
              children: groups.map((g) => _buildGroupTag(g)).toList(),
            ),
            const Spacer(),
            Text(date),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTag(String group) {
    final colors = {
      '교회': Colors.red,
      '1청': Colors.blue,
      '2청': Colors.orange,
      '회사': Colors.grey,
    };

    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[group] ?? Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        group,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return TextButton(
            onPressed: () {},
            child: Text('${index + 1}'),
          );
        }),
      ),
    );
  }
}
