import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 사용자 정보 저장
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await _storage.write(key: 'user_info', value: json.encode(userInfo));
  }

  // 사용자 정보 가져오기
  Future<Map<String, dynamic>?> getUserInfo() async {
    String? userInfoString = await _storage.read(key: 'user_info');
    if (userInfoString != null) {
      return json.decode(userInfoString);
    }
    return null;
  }

  // 사용자 닉네임 가져오기
  Future<String?> getUserNickname() async {
    Map<String, dynamic>? userInfo = await getUserInfo();
    return userInfo?['nickname'];
  }

  // 사용자 이름 가져오기
  Future<String?> getUserName() async {
    Map<String, dynamic>? userInfo = await getUserInfo();
    return userInfo?['name'];
  }

  // 사용자 정보 삭제
  Future<void> deleteUserInfo() async {
    await _storage.delete(key: 'user_info');
  }

  // 사용자 정보 존재 여부 확인
  Future<bool> hasUserInfo() async {
    Map<String, dynamic>? userInfo = await getUserInfo();
    return userInfo != null && userInfo.isNotEmpty;
  }

  // 추가 사용자 정보 존재 여부 확인
  Future<bool> hasAdditionalUserInfo() async {
    Map<String, dynamic>? userInfo = await getUserInfo();
    return userInfo != null &&
        userInfo.containsKey('name') &&
        userInfo.containsKey('gender') &&
        userInfo.containsKey('ageGroup');
  }

  // 추가 사용자 정보 저장 (이름, 성별, 연령대)
  Future<void> saveAdditionalUserInfo({
    required String name,
    required String gender,
    required String ageGroup,
  }) async {
    Map<String, dynamic>? currentInfo = await getUserInfo() ?? {};
    currentInfo['name'] = name;
    currentInfo['gender'] = gender;
    currentInfo['ageGroup'] = ageGroup;
    await saveUserInfo(currentInfo);
  }
}
