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
      child: Scaffold(
        // backgroundColor: Color.fromRGBO(238, 238, 238, 1.0),
        backgroundColor: Colors.indigo.withOpacity(0.1),
        body: Center(
          child: Consumer<UserService>(
            builder: (context, userService, child) {
              final nickname = userService.user?['user_nm'] ?? '사용자';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '환영합니다, $nickname님!',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: const Text('로그아웃'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
