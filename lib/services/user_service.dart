import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:worktext/repositories/auth_repository.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository;

  User? _firebaseUser;
  Map<String, dynamic>? _user;
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

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    _user = userInfo;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> waitForInitialization() => _initializedCompleter.future;
}
