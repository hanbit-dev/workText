import 'package:flutter/material.dart';
import 'package:worktext/screens/notice_screen.dart';
import 'package:worktext/screens/settings_screen.dart';

import '../screens/contacts_screen.dart';
import '../screens/groups_screen.dart';
import '../screens/home_screen.dart';
import '../screens/kakao_login_screen.dart';
import '../screens/message_history_screen.dart';
import '../screens/send_message_screen.dart';
import '../screens/splash_screen.dart';

enum AppRoute {
  splash,
  kakaoLogin,
  home,
  contacts,
  contactList,
  groups,
  messages,
  sendMessage,
  messageHistory,
  settings,
  withdrawal,
  notice,
  noticeBoard,
  logout
}

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/splash';
      case AppRoute.kakaoLogin:
        return '/kakao-login';
      case AppRoute.home:
        return '/home';
      case AppRoute.contacts:
        return '/contacts';
      case AppRoute.contactList:
        return '/contactList';
      case AppRoute.groups:
        return '/groups';
      case AppRoute.messages:
        return '/send-message';
      case AppRoute.sendMessage:
        return '/send-message';
      case AppRoute.messageHistory:
        return '/message-history';
      case AppRoute.settings:
        return '/settings';
      case AppRoute.withdrawal:
        return '/withdrawal';
      case AppRoute.notice:
        return '/notice';
      case AppRoute.noticeBoard:
        return '/noticeBoard';
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
      case AppRoute.home:
        return const HomeScreen();
      case AppRoute.contacts:
        return const ContactsScreen();
      case AppRoute.contactList:
        return const ContactsScreen();
      case AppRoute.groups:
        return const GroupsScreen();
      case AppRoute.messages:
        return const SendMessageScreen();
      case AppRoute.sendMessage:
        return const SendMessageScreen();
      case AppRoute.messageHistory:
        return const MessageHistoryScreen();
      case AppRoute.settings:
        return const SettingsScreen();
      case AppRoute.withdrawal:
        return const SettingsScreen();
      case AppRoute.notice:
        return const NoticeScreen();
      case AppRoute.noticeBoard:
        return const NoticeScreen();
      case AppRoute.logout:
        throw UnimplementedError('Logout does not have a screen');
    }
  }

  IconData get icon {
    switch (this) {
      case AppRoute.home:
        return Icons.home_outlined;
      case AppRoute.contacts:
        return Icons.person;
      case AppRoute.groups:
        return Icons.group_outlined;
      case AppRoute.messages:
        return Icons.message_outlined;
      case AppRoute.sendMessage:
        return Icons.send_outlined;
      case AppRoute.messageHistory:
        return Icons.history_outlined;
      case AppRoute.settings:
        return Icons.settings_outlined;
      case AppRoute.notice:
        return Icons.campaign_outlined;
      case AppRoute.logout:
        return Icons.logout;
      default:
        return Icons.error_outline;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case AppRoute.home:
        return Icons.home;
      case AppRoute.contacts:
        return Icons.person;
      case AppRoute.groups:
        return Icons.group;
      case AppRoute.messages:
        return Icons.message;
      case AppRoute.sendMessage:
        return Icons.send;
      case AppRoute.messageHistory:
        return Icons.history;
      case AppRoute.settings:
        return Icons.settings;
      case AppRoute.notice:
        return Icons.campaign;
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
      case AppRoute.contactList:
        return '연락처';
      case AppRoute.groups:
        return '그룹관리';
      case AppRoute.messages:
        return '메세지';
      case AppRoute.sendMessage:
        return '메세지 생성';
      case AppRoute.messageHistory:
        return '메세지 내역';
      case AppRoute.settings:
        return '설정';
      case AppRoute.withdrawal:
        return '회원탈퇴';
      case AppRoute.notice:
        return '공지사항';
      case AppRoute.noticeBoard:
        return '공지사항';
      case AppRoute.logout:
        return '로그아웃';
      default:
        return '알 수 없음';
    }
  }
}
