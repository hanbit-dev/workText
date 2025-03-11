import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:worktext/models/group.dart';
import 'package:worktext/services/api_service.dart';

class GroupsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Group>? _groups;
  bool _isLoading = false;
  String? _error;
  List<dynamic> _groupUsers = [];
  List<dynamic> _groupUsersForSelect = [];

  List<Group>? get groups => _groups;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get groupUsers => _groupUsers;
  List<dynamic> get groupUsersForSelect => _groupUsersForSelect;

  Future<void> fetch() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post('/group/list-select');
      _groups = (response['data'] as List)
          .map((json) => Group.fromJson(json))
          .toList();

      print('그룹 목록: $_groups');
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGroup(String color, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.put('/group/insert', body: {
        'grp_nm': name,
        'grp_color': color,
      });

      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateGroup(int id, String color, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.put('/group/update', body: {
        'id': id,
        'grp_nm': name,
        'grp_color': color,
      });

      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGroup(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.post('/group/group-delete', body: {
        'id': id,
      });

      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getGroupUsersForSelect(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post('/group/user-list-select', body: {
        'id': id,
      });

      _groupUsersForSelect = response['data'];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getGroupUsers(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post('/group/detail-select', body: {
        'id': id,
      });

      _groupUsers = response['data']['grp_users'] != null 
          ? response['data']['grp_users'].toString().split(',')
          : [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateGroupUser(int id, String grpNm, String grpUsers) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.put('/group/user-update', body: {
        'id': id,
        'grp_nm': grpNm,
        'grp_users': grpUsers,
      });

      await getGroupUsers(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
