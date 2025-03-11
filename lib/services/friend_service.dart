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

  Friend? _friendDetails;
  Friend? get friendDetails => _friendDetails;

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

  // Example response:
  // {
  //   "friend_id": 18,
  //   "friend_nm": "test",
  //   "grp_nm": null,
  //   "honorifics_yn": null,
  //   "friend_position": null
  // }
  Future<void> fetchDetail(int friendId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService
          .post('/friend/detail-select', body: {'id': friendId});
      print("step1");
      print(response['data']);
      _friendDetails = Friend.fromJson(response['data']);
      print(_friendDetails);
      // return friend;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(String name, String honor, String position) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.put('/friend/insert',
          body: {'friend_nm': name, 'honorifics_yn': honor, 'friend_position': position});
      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> delete(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.post('/friend/friend-delete', body: {'id': id});
      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }
}
