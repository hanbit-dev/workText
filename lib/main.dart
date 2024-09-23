import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:provider/provider.dart';

import 'routes/app_router.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    javaScriptAppKey: 'f2f424a49d8de1e55032caa0248db0f6',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateManager()),
        Provider(create: (context) => AuthService()),
        Provider(create: (context) => UserService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '업무 문자 해줘요',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: 'Pretendard Variable',
        scaffoldBackgroundColor: Color.fromRGBO(48, 48, 48, 1.0),
      ),
      routerDelegate:
          AppRouter(appStateManager: context.read<AppStateManager>()),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}
