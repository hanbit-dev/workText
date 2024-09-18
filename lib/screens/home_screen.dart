import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/routes/app_router.dart';
import 'package:worktext/routes/app_routes.dart';
import 'package:worktext/services/auth_service.dart';
import 'package:worktext/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    print("HomeScreen initState 시작");
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    print("_loadUserInfo 메서드 시작");
    final userService = Provider.of<UserService>(context, listen: false);
    String? username = await userService.getUserName();
    print("가져온 사용자 이름: $username");
    setState(() {
      _username = username ?? '사용자';
    });
    print("setState 완료, _username: $_username");
  }

  void _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    await authService.logout();
    appStateManager.logout();
    appStateManager.setCurrentRoute(AppRoute.kakaoLogin);
  }

  void _deleteUserInfo() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    await userService.deleteUserInfo();
    appStateManager.clearUserInfo();
    appStateManager.setCurrentRoute(AppRoute.userInfo);
  }

  void _goToUserInfoScreen() {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    appStateManager.setCurrentRoute(AppRoute.userInfo);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                onPressed: _goToUserInfoScreen,
                child: const Text('내 정보 수정'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteUserInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('내 정보 삭제'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
