import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:worktext/routes/app_router.dart';
import 'package:worktext/routes/app_routes.dart';
import 'package:worktext/services/auth_service.dart';
import 'package:worktext/services/user_service.dart';

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
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공');

      await authService.saveToken(token.accessToken);

      try {
        User user = await UserApi.instance.me();
        print('사용자 정보 요청 성공'
            '\n회원번호: ${user.id}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n이메일: ${user.kakaoAccount?.email}');

        // 카카오에서 받은 기본 사용자 정보 저장
        await userService.saveUserInfo({
          'id': user.id,
          'nickname': user.kakaoAccount?.profile?.nickname,
          'email': user.kakaoAccount?.email,
        });

        appStateManager.login();

        // 추가 사용자 정보 확인
        bool hasAdditionalInfo = await userService.hasAdditionalUserInfo();
        if (!hasAdditionalInfo) {
          appStateManager.setCurrentRoute(AppRoute.userInfo);
        } else {
          appStateManager.setUserInfo();
          appStateManager.setCurrentRoute(AppRoute.home);
        }
      } catch (error) {
        print('사용자 정보 요청 실패 $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용자 정보 요청에 실패했습니다.')),
        );
      }
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
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
