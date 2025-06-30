import 'package:flutter/material.dart';

class Notice {
  final String title;
  final String content;
  final DateTime date;

  Notice({required this.title, required this.content, required this.date});
}

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  // 샘플 공지사항 데이터 (실제 앱에서는 API 호출 등으로 대체)
  List<Notice> getNotices() {
    return [
      Notice(
        title: '서버 점검 안내',
        content: '6월 20일 오전 2시부터 4시까지 서버 점검이 진행됩니다.',
        date: DateTime(2025, 6, 18),
      ),
      Notice(
        title: '신규 기능 출시',
        content: '이제 다크모드가 지원됩니다. 설정에서 변경해보세요!',
        date: DateTime(2025, 6, 17),
      ),
      Notice(
        title: '이벤트 안내',
        content: '회원가입 이벤트가 시작되었습니다. 자세한 내용은 이벤트 페이지를 확인하세요.',
        date: DateTime(2025, 6, 15),
      ),
    ]..sort((a, b) => b.date.compareTo(a.date)); // 최신순 정렬
  }

  @override
  Widget build(BuildContext context) {
    final notices = getNotices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          final notice = notices[index];
          final isLatest = index == 0;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              child: ExpansionTile(
                title: Text(
                  notice.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${notice.date.year}.${notice.date.month.toString().padLeft(2, '0')}.${notice.date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12),
                ),
                initiallyExpanded: isLatest,
                shape: const Border(),
                collapsedShape: const Border(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(notice.content),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
