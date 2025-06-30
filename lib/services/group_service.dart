import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:worktext/models/group.dart';
import 'package:worktext/services/api_service.dart';

class GroupsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Group>? _groups;
  List<dynamic> _groupUsers = [];
  List<dynamic> _groupUsersForSelect = [];
  String? _error;

  // 각 작업별 로딩 상태
  bool _isLoadingGroups = false;
  bool _isLoadingGroupUsers = false;
  bool _isLoadingGroupUsersForSelect = false;
  bool _isUpdatingGroup = false;
  bool _isAddingGroup = false;
  bool _isDeletingGroup = false;
  bool _isUpdatingGroupUsers = false;

  // Getters
  List<Group>? get groups => _groups;
  List<dynamic> get groupUsers => _groupUsers;
  List<dynamic> get groupUsersForSelect => _groupUsersForSelect;
  String? get error => _error;

  bool get isLoadingGroups => _isLoadingGroups;
  bool get isLoadingGroupUsers => _isLoadingGroupUsers;
  bool get isLoadingGroupUsersForSelect => _isLoadingGroupUsersForSelect;
  bool get isUpdatingGroup => _isUpdatingGroup;
  bool get isAddingGroup => _isAddingGroup;
  bool get isDeletingGroup => _isDeletingGroup;
  bool get isUpdatingGroupUsers => _isUpdatingGroupUsers;

  Future<void> fetch() async {
    if (_isLoadingGroups) return;

    try {
      _isLoadingGroups = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post('group/list-select');
      _groups = (response['data'] as List)
          .map((json) => Group.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingGroups = false;
      notifyListeners();
    }
  }

  Future<void> addGroup(String color, String name) async {
    try {
      _isAddingGroup = true;
      _error = null;
      notifyListeners();

      await _apiService.put('group/insert', body: {
        'grp_nm': name,
        'grp_color': color,
      });

      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isAddingGroup = false;
      notifyListeners();
    }
  }

  Future<void> updateGroup(int id, String color, String name) async {
    try {
      _isUpdatingGroup = true;
      _error = null;
      notifyListeners();

      await _apiService.put('group/update', body: {
        'id': id,
        'grp_nm': name,
        'grp_color': color,
      });

      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isUpdatingGroup = false;
      notifyListeners();
    }
  }

  Future<void> deleteGroup(int id) async {
    try {
      _isDeletingGroup = true;
      _error = null;
      notifyListeners();

      await _apiService.post('group/group-delete', body: {
        'id': id,
      });

      await fetch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isDeletingGroup = false;
      notifyListeners();
    }
  }

  Future<void> getGroupUsersForSelect(int id) async {
    try {
      _isLoadingGroupUsersForSelect = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post('group/user-list-select', body: {
        'id': id,
      });

      _groupUsersForSelect = response['data'];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingGroupUsersForSelect = false;
      notifyListeners();
    }
  }

  Future<void> getGroupUsers(int id) async {
    try {
      _isLoadingGroupUsers = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post('group/detail-select', body: {
        'id': id,
      });

      _groupUsers = response['data']['grp_users'] != null
          ? response['data']['grp_users'].toString().split(',')
          : [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingGroupUsers = false;
      notifyListeners();
    }
  }

  Future<void> updateGroupUser(int id, String grpNm, String grpUsers) async {
    try {
      _isUpdatingGroupUsers = true;
      _error = null;
      notifyListeners();

      await _apiService.put('group/user-update', body: {
        'id': id,
        'grp_nm': grpNm,
        'grp_users': grpUsers,
      });

      await getGroupUsers(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isUpdatingGroupUsers = false;
      notifyListeners();
    }
  }
}
