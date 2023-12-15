import 'package:flutter/material.dart';

class ChatBubbleProvider extends ChangeNotifier {
  bool _isChatBubbleVisible = false;

  bool get isChatBubbleVisible => _isChatBubbleVisible;

  void showChatBubble() {
    _isChatBubbleVisible = true;
    notifyListeners();
  }

  void hideChatBubble() {
    _isChatBubbleVisible = false;
    notifyListeners();
  }
}
