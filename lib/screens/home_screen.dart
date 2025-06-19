import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/services/user_service.dart';
import 'package:worktext/components/user/user_edit_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.logout();
  }

  void _showProfileEditDialog(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: UserEditView(selectedUser: userService.user),
        );
      },
    );
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
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _showProfileEditDialog(context),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              '프로필 수정하기',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
