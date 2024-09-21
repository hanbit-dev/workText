import 'package:flutter/material.dart';

import '../screens/contacts_screen.dart';
import '../screens/groups_screen.dart';
import '../screens/home_screen.dart';
import '../screens/kakao_login_screen.dart';
import '../screens/message_history_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/send_message_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/user_info_screen.dart';

enum AppRoute {
  splash,
  kakaoLogin,
  userInfo,
  home,
  contacts,
  groups,
  messages,
  sendMessage,
  messageHistory,
  logout
}

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/splash';
      case AppRoute.kakaoLogin:
        return '/kakao-login';
      case AppRoute.userInfo:
        return '/user-info';
      case AppRoute.home:
        return '/home';
      case AppRoute.contacts:
        return '/contacts';
      case AppRoute.groups:
        return '/groups';
      case AppRoute.messages:
        return '/messages';
      case AppRoute.sendMessage:
        return '/send-message';
      case AppRoute.messageHistory:
        return '/message-history';
      case AppRoute.logout:
        return '/logout';
    }
  }

  Widget get screen {
    switch (this) {
      case AppRoute.splash:
        return const SplashScreen();
      case AppRoute.kakaoLogin:
        return const KakaoLoginScreen();
      case AppRoute.userInfo:
        return const UserInfoScreen();
      case AppRoute.home:
        return const HomeScreen();
      case AppRoute.contacts:
        return const ContactsScreen();
      case AppRoute.groups:
        return const GroupsScreen();
      case AppRoute.messages:
        return const MessagesScreen();
      case AppRoute.sendMessage:
        return const SendMessageScreen();
      case AppRoute.messageHistory:
        return const MessageHistoryScreen();
      case AppRoute.logout:
        throw UnimplementedError('Logout does not have a screen');
    }
  }

  IconData get icon {
    switch (this) {
      case AppRoute.home:
        return Icons.home_outlined;
      case AppRoute.contacts:
        return Icons.contacts_outlined;
      case AppRoute.groups:
        return Icons.group_outlined;
      case AppRoute.messages:
        return Icons.message_outlined;
      case AppRoute.sendMessage:
        return Icons.send_outlined;
      case AppRoute.messageHistory:
        return Icons.history_outlined;
      case AppRoute.logout:
        return Icons.logout;
      default:
        return Icons.error_outline;
    }
  }

  String get label {
    switch (this) {
      case AppRoute.home:
        return '홈';
      case AppRoute.contacts:
        return '연락처';
      case AppRoute.groups:
        return '그룹관리';
      case AppRoute.messages:
        return '문자';
      case AppRoute.sendMessage:
        return '문자 보내기';
      case AppRoute.messageHistory:
        return '문자 내역';
      case AppRoute.logout:
        return '로그아웃';
      default:
        return '알 수 없음';
    }
  }
}
