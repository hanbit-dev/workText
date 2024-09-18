import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  void _goToUserInfoScreen() {
    // Navigator.of(context).pushNamed('/user-info');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '환영합니다!!',//'환영합니다, $_username님!',
            style:
            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: 업무 문자 생성 기능 구현
              print('업무 문자 생성 버튼 클릭');
            },
            child: const Text('업무 문자 생성하기'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _goToUserInfoScreen,
            child: const Text('내 정보 수정'),
          ),
        ],
      ),
    );
  }
}