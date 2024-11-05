import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:provider/provider.dart';
import 'package:worktext/repositories/auth_repository.dart';

import 'firebase_options.dart';
import 'routes/app_router.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    javaScriptAppKey: 'b1001684bdd64f2d78d869fa512d7977',
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserService(context.read<AuthRepository>()),
        ),
        StreamProvider(
          create: (context) => context.read<UserService>().authStateChanges(),
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (_) => AppStateManager(),
        ),
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
        // scaffoldBackgroundColor: const Color.fromRGBO(48, 48, 48, 1.0),
      ),
      routerDelegate: AppRouter(
        appStateManager: context.read<AppStateManager>(),
        userService: context.read<UserService>(),
      ),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}
