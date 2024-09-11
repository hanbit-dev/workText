import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 토큰 저장
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // 토큰 가져오기
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // 토큰 삭제
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // 토큰 존재 여부 확인
  Future<bool> hasToken() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // 로그아웃 (토큰 삭제)
  Future<void> logout() async {
    await deleteToken();
  }
}
