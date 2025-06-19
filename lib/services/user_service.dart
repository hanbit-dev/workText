import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:worktext/repositories/auth_repository.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository;

  User? _firebaseUser;
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;
  final _initializedCompleter = Completer<void>();

  UserService(this._authRepository) {
    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;

      if (user != null && _user == null) {
        try {
          _user = await _authRepository.fetchUserInfo();
        } catch (e) {
          print('DB 사용자 정보 가져오기 실패: $e');
        }
      } else if (user == null) {
        _user = null;
      }

      // 초기화 완료
      if (!_initializedCompleter.isCompleted) {
        _initializedCompleter.complete();
      }

      notifyListeners();
    });
  }

  bool get isLoggedIn => _firebaseUser != null;
  User? get firebaseUser => _firebaseUser;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    _user = userInfo;
    notifyListeners();
  }

  // 사용자 정보 업데이트 메서드 (추상화)
  Future<void> updateUserInfo(String birthDay, String gender) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authRepository.updateUserInfo({
        'birth_day': birthDay,
        'gender': gender,
      });

      // 임시로 로컬 데이터 업데이트
      if (_user != null) {
        _user!['birth_day'] = birthDay;
        _user!['gender'] = gender;
      }

      print('사용자 정보 업데이트 완료:');
      print('생년월일: $birthDay');
      print('성별: $gender');
    } catch (e) {
      _error = e.toString();
      print('사용자 정보 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> waitForInitialization() => _initializedCompleter.future;
}
