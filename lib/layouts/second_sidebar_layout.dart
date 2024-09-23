import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/routes/app_routes.dart';

import '../routes/app_router.dart';
import '../services/auth_service.dart';

class SecondSidebarLayout extends StatelessWidget {
  final Widget child;

  const SecondSidebarLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    final currentRoute = appStateManager.secondSidebarRoutes.firstWhere(
          (route) => route.path == appStateManager.currentRoute.path,
      orElse: () => appStateManager.secondSidebarRoutes.first,
    );

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: NavigationDrawer(
                backgroundColor: Color.fromRGBO(210, 210, 210, 1.0),
                selectedIndex: appStateManager.secondSidebarRoutes.indexOf(currentRoute),
                onDestinationSelected: (index) {
                  final selectedRoute = appStateManager.secondSidebarRoutes[index];
                  appStateManager.setCurrentRoute(selectedRoute);
                },
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  ...appStateManager.secondSidebarRoutes.map((route) => NavigationDrawerDestination(
                    icon: SizedBox.shrink(),
                    label: Text(route.label),
                  )),
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
}