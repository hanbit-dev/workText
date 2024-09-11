import 'package:flutter/material.dart';
import 'package:worktext/services/auth_service.dart';
import 'package:worktext/services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final hasToken = await authService.hasToken();

    if (hasToken) {
      // 토큰이 있는 경우, 추가 사용자 정보 확인
      bool hasAdditionalInfo = await userService.hasAdditionalUserInfo();
      if (!hasAdditionalInfo) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/user-info', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/kakao-login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
