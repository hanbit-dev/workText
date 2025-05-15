import 'package:flutter/material.dart';
import 'package:worktext/models/message.dart';
import 'package:worktext/models/friend.dart';
import 'package:worktext/services/api_service.dart';

class MessageService extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  List<Friend> _friends = [];
  List<Friend> get friends => _friends;

  Friend? _selectedFriend;
  Friend? get selectedFriend => _selectedFriend;

  void setSelectedFriend(Friend friend) {
    _selectedFriend = friend;
    notifyListeners();
  }

  Map<String, Message> _messageMap = {};
  Map<String, Message> get messageMap => _messageMap;

  Future<void> setFriends(List<Friend> friends) async {
    _friends = friends;
    notifyListeners();
  }

  Future<void> generateMessage(String message, List<String> friendIds) async {
    final response = await _apiService.post('/message/generate-message', body: {
      'message': message,
      'friendIds': friendIds,
    });

    _messages = response['messages']
        .map<Message>((message) => Message.fromJson(message))
        .toList();

    _messageMap = _messages.fold<Map<String, Message>>({}, (map, message) {
      map[message.receiver] = message;
      return map;
    });

    notifyListeners();
  }
}
