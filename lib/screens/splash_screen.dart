import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/app_router.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    final hasToken = await authService.hasToken();

    if (hasToken) {
      appStateManager.login();
      print('After login - Current route: ${appStateManager.currentRoute}');

      bool hasAdditionalInfo = await userService.hasAdditionalUserInfo();
      if (hasAdditionalInfo) {
        appStateManager.setUserInfo();
        print(
            'After setUserInfo - Current route: ${appStateManager.currentRoute}');
      }
    } else {
      appStateManager.logout();
      print('No token - Current route: ${appStateManager.currentRoute}');
    }

    // initializeApp을 마지막에 호출
    appStateManager.initializeApp();

    print('Final state - Current route: ${appStateManager.currentRoute}');
    print('Is logged in: ${appStateManager.isLoggedIn}');
    print('Has user info: ${appStateManager.hasUserInfo}');
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
