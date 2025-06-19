import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:worktext/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginWithKakao() async {
    try {
      // 1. 카카오 로그인
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();

      // 2. 백엔드에서 커스텀 토큰 받아오기
      final response = await _apiService.post('/auth/login-with-kakao', body: {
        'accessToken': token.accessToken,
      });

      final customToken = response['customToken'];

      // 3. Firebase Auth에 커스텀 토큰으로 로그인
      if (customToken != null) {
        await _firebaseAuth.signInWithCustomToken(customToken);
      } else {
        throw Exception('커스텀 토큰이 없습니다.');
      }
    } catch (e) {
      print('로그인 실패: $e');
      throw Exception('로그인 실패: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserInfo() async {
    try {
      // 현재 Firebase 사용자의 ID 토큰 가져오기
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('인증된 사용자가 없습니다.');
      }

      final response = await _apiService.get(
        '/user/me',
      );

      return response['user'];
    } catch (e) {
      print('사용자 정보 가져오기 실패: $e');
      throw Exception('사용자 정보 가져오기 실패: $e');
    }
  }

  Future<void> updateUserInfo(Map<String, dynamic> userInfo) async {
    try {
      await _apiService.put('/user/update', body: userInfo);
    } catch (e) {
      print('사용자 정보 업데이트 실패: $e');
      throw Exception('사용자 정보 업데이트 실패: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
