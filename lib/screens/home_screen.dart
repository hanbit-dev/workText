import 'package:flutter/material.dart';
import 'package:worktext/services/auth_service.dart';
import 'package:worktext/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  String _username = '';

  @override
  void initState() {
    super.initState();
    print("HomeScreen initState 시작"); // 추가된 프린트 문
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    print("_loadUserInfo 메서드 시작"); // 추가된 프린트 문
    String? username = await _userService.getUsername();
    print("가져온 사용자 이름: $username"); // 추가된 프린트 문
    setState(() {
      _username = username ?? '사용자';
    });
    print("setState 완료, _username: $_username"); // 추가된 프린트 문
  }

  void _logout() async {
    await _authService.logout();
    await _userService.deleteUserInfo();
    Navigator.of(context).pushReplacementNamed('/kakao-login');
  }

  void _goToUserInfoScreen() {
    Navigator.of(context).pushNamed('/user-info');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('홈'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _logout,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '환영합니다, $_username님!',
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
        ),
      ),
    );
  }
}
