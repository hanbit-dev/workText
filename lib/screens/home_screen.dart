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
            Text(
              '환영합니다, ',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_username',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent),
            ),
            Text(
              '님!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ]),
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
    );
  }
}
