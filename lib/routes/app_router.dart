import 'package:flutter/material.dart';
import 'package:worktext/layouts/second_sidebar_layout.dart';

import '../layouts/sidebar_layout.dart';
import './app_routes.dart';

class AppStateManager extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isLoggedIn = false;
  bool _hasUserInfo = false;
  AppRoute _currentFirstSideBar = AppRoute.home;
  AppRoute _currentRoute = AppRoute.splash;
  List<AppRoute> _secondSidebarRoutes = [
    AppRoute.home,
  ];
  bool _isOpenSecondSideBar = true;

  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasUserInfo => _hasUserInfo;
  AppRoute get currentFirstSideBar => _currentFirstSideBar;
  AppRoute get currentRoute => _currentRoute;
  List<AppRoute> get secondSidebarRoutes => _secondSidebarRoutes;
  bool get isOpenSecondSideBar => _isOpenSecondSideBar;

  void initializeApp() {
    _isInitialized = true;
    // 여기서 _currentRoute를 설정하지 않습니다.
    // 대신, 현재 상태에 따라 적절한 라우트를 유지합니다.
    if (!_isLoggedIn) {
      _currentRoute = AppRoute.kakaoLogin;
    } else if (!_hasUserInfo) {
      _currentRoute = AppRoute.userInfo;
    } else {
      _currentRoute = AppRoute.home;
    }
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    _currentRoute = AppRoute.userInfo; // 여기를 수정
    notifyListeners();
  }

  void setUserInfo() {
    _hasUserInfo = true;
    _currentRoute = AppRoute.home; // 이 부분이 중요합니다
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _hasUserInfo = false;
    _currentRoute = AppRoute.kakaoLogin;
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
        _secondSidebarRoutes = [ AppRoute.home ];
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
    };
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

  void clearUserInfo() {
    _hasUserInfo = false;
    notifyListeners();
  }
}

class AppRouter extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppStateManager appStateManager;

  AppRouter({required this.appStateManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // if (!appStateManager.isInitialized)
        //   MaterialPage(child: AppRoute.splash.screen),
        // if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
        //   MaterialPage(child: AppRoute.kakaoLogin.screen),
        // if (appStateManager.isLoggedIn && !appStateManager.hasUserInfo)
        //   MaterialPage(child: AppRoute.userInfo.screen),
        // if (appStateManager.isLoggedIn && appStateManager.hasUserInfo)
        if (appStateManager.isOpenSecondSideBar)
          MaterialPage(
            child: SidebarLayout(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: SecondSidebarLayout(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: appStateManager.currentRoute.screen,
                  ),
                ),
              ),
            ),
          ),
        if (!appStateManager.isOpenSecondSideBar)
          MaterialPage(
            child: SidebarLayout(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: appStateManager.currentRoute.screen,
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
