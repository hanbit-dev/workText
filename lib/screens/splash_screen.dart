import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/app_router.dart';
import '../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForAuthState();
    });
  }

  Future<void> _waitForAuthState() async {
    final userService = context.read<UserService>();
    final appStateManager = context.read<AppStateManager>();

    try {
      await userService.waitForInitialization();
      appStateManager.initializeApp();
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
