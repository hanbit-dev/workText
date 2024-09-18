import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/routes/app_routes.dart';

import '../routes/app_router.dart';
import '../services/auth_service.dart';

class SidebarLayout extends StatelessWidget {
  final Widget child;

  const SidebarLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    final sidebarRoutes = [
      AppRoute.home,
      AppRoute.contacts,
      AppRoute.groups,
      AppRoute.messages,
      AppRoute.sendMessage,
      AppRoute.messageHistory,
      AppRoute.logout,
    ];

    final currentRoute = sidebarRoutes.firstWhere(
      (route) => route.path == appStateManager.currentRoute.path,
      orElse: () => AppRoute.home,
    );

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationDrawer(
              selectedIndex: sidebarRoutes.indexOf(currentRoute),
              onDestinationSelected: (index) {
                final selectedRoute = sidebarRoutes[index];
                if (selectedRoute == AppRoute.logout) {
                  _showLogoutDialog(context);
                } else {
                  appStateManager.setCurrentRoute(selectedRoute);
                }
              },
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                  child: Text(
                    currentRoute.path,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...sidebarRoutes.map((route) => NavigationDrawerDestination(
                      icon: Icon(route.icon),
                      label: Text(route.label),
                    )),
                if (sidebarRoutes.last != AppRoute.logout)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    child: Divider(),
                  ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말로 로그아웃하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    await authService.logout();
    appStateManager.logout();
  }
}
