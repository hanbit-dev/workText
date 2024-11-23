import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/repositories/auth_repository.dart';
import 'package:worktext/routes/app_router.dart';
import 'package:worktext/routes/app_routes.dart';

class KakaoLoginScreen extends StatelessWidget {
  const KakaoLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _doLogin(BuildContext context) async {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    try {
      await authRepository.loginWithKakao();
      appStateManager.setCurrentRoute(AppRoute.home);
    } catch (error) {
      print('로그인 실패 $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FloatingActionButton.extended(
          icon: Image.asset(
            'assets/images/kakao_logo.png',
            height: 24,
            width: 24,
          ),
          onPressed: () => _doLogin(context),
          label: const Text('카카오톡으로 로그인',
              style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFFFEE500),
          foregroundColor: Colors.black87,
        ),
      ),
    );
  }
}
