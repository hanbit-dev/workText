import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:worktext/models/group.dart';
import 'package:worktext/services/api_service.dart';

class GroupsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Group>? _groups;
  bool _isLoading = false;
  String? _error;

  List<Group>? get groups => _groups;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
}
