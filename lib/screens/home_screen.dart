import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/services/user_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.logout();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    final nickname = userService.user?['user_nm'] ?? '사용자';

    return PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 200,
            color: Colors.indigoAccent.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              '환영합니다, ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$nickname',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent),
            ),
            const Text(
              '님!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ]),
        ],
      ),
    );
  }
}
