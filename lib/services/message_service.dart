import 'package:flutter/material.dart';
import 'package:worktext/services/api_service.dart';

class MessageService extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<void> generateMessage(String message, List<String> friendIds) async {
    final response = await _apiService.post('/message/generate-message', body: {
      'message': message,
      'friendIds': friendIds,
    });

    print(response);
  }
}
