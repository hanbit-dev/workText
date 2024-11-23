import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:worktext/models/friend.dart';
import 'package:worktext/services/api_service.dart';

class FriendsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Friend>? _friends;
  bool _isLoading = false;
  String? _error;

  List<Friend>? get friends => _friends;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetch() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post('/friend/list-select');
      _friends = (response['data'] as List)
          .map((json) => Friend.fromJson(json))
          .toList();

      print('친구 목록: $_friends');
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.put('/friend/insert', body: {'friend_nm': name});
      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }
}
