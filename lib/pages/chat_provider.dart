import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  Map<String, List<ChatMessage>> _messages = {};

  List<ChatMessage> getMessages(String userName) {
    return _messages[userName] ?? [];
  }

  void sendMessage(String userName, String text, bool isUser) {
    final message = ChatMessage(
      text: text,
      isUser: isUser,
      dateTime: DateTime.now().toIso8601String(),
    );

    if (_messages[userName] == null) {
      _messages[userName] = [];
    }

    _messages[userName]!.add(message);
    notifyListeners();
  }

  ChatMessage? getLastMessage(String userName) {
    if (_messages[userName] == null || _messages[userName]!.isEmpty) {
      return null;
    }
    return _messages[userName]!.last;
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String dateTime;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.dateTime,
  });
}
