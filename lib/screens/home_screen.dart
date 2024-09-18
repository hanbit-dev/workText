import 'package:flutter/material.dart';
import 'package:worktext/screens/contact_screen.dart';
import 'package:worktext/screens/main_screen.dart';
import 'package:worktext/screens/message_screen.dart';
import 'package:worktext/screens/notice_screen.dart';
import 'package:worktext/screens/settings_screen.dart';
import 'package:worktext/services/auth_service.dart';
import 'package:worktext/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  String _username = '';
  int _selectedIndex = 0;
  Widget _mainContent = MainScreen();

  @override
  void initState() {
    super.initState();
    print("HomeScreen initState 시작"); // 추가된 프린트 문
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    print("_loadUserInfo 메서드 시작"); // 추가된 프린트 문
    String? username = await _userService.getUsername();
    print("가져온 사용자 이름: $username"); // 추가된 프린트 문
    setState(() {
      _username = username ?? '사용자';
    });
    print("setState 완료, _username: $_username"); // 추가된 프린트 문
  }

  void _logout() async {
    await _authService.logout();
    await _userService.deleteUserInfo();
    Navigator.of(context).pushReplacementNamed('/kakao-login');
  }

  void _goToUserInfoScreen() {
    Navigator.of(context).pushNamed('/user-info');
  }

  void _goHome() {
    Navigator.of(context).pushNamed('/home');
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0: //home
        _goHome(); //홈으로 새로 고침
        // _mainContent = MainScreen(); //그냥 화면만 전환
        break;
      case 1: //문자 보내기
        _mainContent = MessageScreen();
        break;
      case 2: //연락처
        _mainContent = ContactScreen();
        break;
      case 3: //설정
        _mainContent = SettingsScreen();
        break;
      case 4: //공지 사항
        _mainContent = NoticeScreen();
        break;
      case 5: //종료(로그 아웃)
        _logout();
        break;
      default:
        _goHome();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              backgroundColor: Color.fromRGBO(48, 48, 48, 1.0),
              selectedIndex: _selectedIndex,
              groupAlignment: -1.0,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.none,
              leading: const SizedBox(),
              trailing: const SizedBox(),
              selectedIconTheme: IconThemeData(color: Color.fromRGBO(48, 48, 48, 1.0)),
              unselectedIconTheme: IconThemeData(color: Color.fromRGBO(210, 210, 210, 1.0)),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.messenger_outline),
                  selectedIcon: Icon(Icons.messenger),
                  label: Text('message'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outlined),
                  selectedIcon: Icon(Icons.person),
                  label: Text('contact'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('settings'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.campaign_outlined),
                  selectedIcon: Icon(Icons.campaign),
                  label: Text('notice'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.power_settings_new_outlined),
                  selectedIcon: Icon(Icons.power_settings_new),
                  label: Text('close'),
                ),
              ],
            ),
            // This is the main content.
            Expanded(
              child: Container(
                color: Color.fromRGBO(48, 48, 48, 1.0),
                child: _mainContent,
              ),
            ),
          ],
        ),
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return PopScope(
//     canPop: false,
//     child: Scaffold(
//       appBar: AppBar(
//         title: const Text('홈'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               '환영합니다, $_username님!',
//               style:
//                   const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 print('업무 문자 생성 버튼 클릭');
//               },
//               child: const Text('업무 문자 생성하기'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _goToUserInfoScreen,
//               child: const Text('내 정보 수정'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}
