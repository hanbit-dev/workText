import 'package:flutter/material.dart';
import 'package:worktext/services/user_service.dart';

import '../layouts/sidebar_layout.dart';
import './app_routes.dart';

class AppStateManager extends ChangeNotifier {
  bool _isInitialized = false;
  AppRoute _currentFirstSideBar = AppRoute.home;
  AppRoute _currentRoute = AppRoute.splash;
  List<AppRoute> _secondSidebarRoutes = [AppRoute.home];
  bool _isOpenSecondSideBar = true;

  bool get isInitialized => _isInitialized;
  AppRoute get currentFirstSideBar => _currentFirstSideBar;
  AppRoute get currentRoute => _currentRoute;
  List<AppRoute> get secondSidebarRoutes => _secondSidebarRoutes;
  bool get isOpenSecondSideBar => _isOpenSecondSideBar;

  void initializeApp() {
    _isInitialized = true;
    notifyListeners();
  }

  void setCurrentFirstSideBar(AppRoute route) {
    _currentFirstSideBar = route;
    notifyListeners();
  }

  void setCurrentRoute(AppRoute route) {
    _currentRoute = route;
    notifyListeners();
  }

  void setSecondSideBar(AppRoute route) {
    switch (route) {
      case AppRoute.home:
        _secondSidebarRoutes = [AppRoute.home];
      case AppRoute.messages:
        _secondSidebarRoutes = [
          AppRoute.sendMessage,
          AppRoute.messageHistory,
        ];
      case AppRoute.contacts:
        _secondSidebarRoutes = [
          AppRoute.contactList,
          AppRoute.groups,
        ];
      case AppRoute.settings:
        _secondSidebarRoutes = [
          AppRoute.withdrawal,
        ];
      case AppRoute.notice:
        _secondSidebarRoutes = [
          AppRoute.noticeBoard,
        ];
      default:
        break;
    }
    notifyListeners();
  }

  void openSecondSideBar() {
    _isOpenSecondSideBar = true;
    notifyListeners();
  }

  void closeSecondSideBar() {
    _isOpenSecondSideBar = false;
    notifyListeners();
  }
}

class AppRouter extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final UserService userService;

  AppRouter({
    required this.appStateManager,
    required this.userService,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    userService.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (!appStateManager.isInitialized)
          MaterialPage(child: AppRoute.splash.screen),
        if (appStateManager.isInitialized && !userService.isLoggedIn)
          MaterialPage(child: AppRoute.kakaoLogin.screen),
        if (appStateManager.isInitialized && userService.isLoggedIn)
          if (appStateManager.isOpenSecondSideBar)
            MaterialPage(
              child: SidebarLayout(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: appStateManager.currentRoute.screen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteSettings configuration) async {
    final route = AppRoute.values.firstWhere(
      (r) => r.path == configuration.name,
      orElse: () => AppRoute.home,
    );
    appStateManager.setCurrentRoute(route);
  }
}

class AppRouteInformationParser extends RouteInformationParser<RouteSettings> {
  @override
  Future<RouteSettings> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    final pathSegments = uri.pathSegments;

    if (pathSegments.isEmpty) {
      return RouteSettings(name: AppRoute.home.path);
    }

    final path = '/${pathSegments.join('/')}';
    final route = AppRoute.values.firstWhere(
      (r) => r.path == path,
      orElse: () => AppRoute.home,
    );

    return RouteSettings(name: route.path);
  }

  @override
  RouteInformation? restoreRouteInformation(RouteSettings configuration) {
    return RouteInformation(uri: Uri.parse(configuration.name ?? '/'));
  }
}
