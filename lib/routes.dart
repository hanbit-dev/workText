import 'package:flutter/material.dart';
import 'package:worktext/screens/home_screen.dart';
import 'package:worktext/screens/kakao_login_screen.dart';
import 'package:worktext/screens/splash_screen.dart';
import 'package:worktext/screens/user_info_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/home': (context) => const HomeScreen(),
  '/kakao-login': (context) => const KakaoLoginScreen(),
  '/user-info': (context) => const UserInfoScreen(),
};
