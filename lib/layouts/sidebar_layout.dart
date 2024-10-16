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
      AppRoute.messages,
      AppRoute.contacts,
      AppRoute.settings,
      AppRoute.notice,
      AppRoute.logout,
    ];

    final currentRoute = sidebarRoutes.firstWhere(
      (route) => route.path == appStateManager.currentRoute.path,
      orElse: () => AppRoute.home,
    );

    final currentFirstSideBar = sidebarRoutes.firstWhere(
          (route) => route.path == appStateManager.currentFirstSideBar.path,
      orElse: () => AppRoute.home,
    );

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Column(
                children: [
                  Expanded(
                    child: NavigationDrawer(
                      backgroundColor: Color.fromRGBO(48, 48, 48, 1.0),
                      selectedIndex: sidebarRoutes.indexOf(currentFirstSideBar),
                      onDestinationSelected: (index) {
                        final selectedRoute = sidebarRoutes[index];
                        if (selectedRoute == AppRoute.logout) {
                          _showLogoutDialog(context);
                        } else {
                          appStateManager.openSecondSideBar();
                          appStateManager.setCurrentRoute(selectedRoute);
                          appStateManager.setCurrentFirstSideBar(selectedRoute);
                          appStateManager.setSecondSideBar(selectedRoute);
                        }
                      },
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(40, 16, 16, 10),
                        ),
                        ...sidebarRoutes.map((route) => NavigationDrawerDestination(
                              icon: Icon(
                                route.icon,
                                color: Color.fromRGBO(210, 210, 210, 1.0),
                              ),
                              selectedIcon: Icon(route.selectedIcon),
                              label: SizedBox.shrink(),
                        )),
                        // if (sidebarRoutes.last != AppRoute.logout)
                        //   const Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        //     child: Divider(),
                        //   ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      alignment: Alignment.bottomCenter, // 하단 중앙 정렬
                      child: ElevatedButton(
                        onPressed: appStateManager.isOpenSecondSideBar ? appStateManager.closeSecondSideBar : appStateManager.openSecondSideBar,
                        child: appStateManager.isOpenSecondSideBar ? const Icon(Icons.keyboard_double_arrow_left) : const Icon(Icons.keyboard_double_arrow_right),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //const VerticalDivider(thickness: 1, width: 1),
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
