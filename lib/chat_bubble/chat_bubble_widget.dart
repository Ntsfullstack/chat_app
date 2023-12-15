import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'chat_bubble_provider.dart'; // Đảm bảo import đúng đường dẫn

class ChatBubbleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatBubbleProvider>(
      builder: (context, chatBubbleProvider, _) {
        if (!chatBubbleProvider.isChatBubbleVisible) {
          return SizedBox.shrink();
        }

        Overlay.of(context)?.insert(
          OverlayEntry(
            builder: (context) => Positioned(
              bottom: 16.0,
              right: 16.0,
              child: GestureDetector(
                onTap: () {
                  // Handle tap on the chat bubble
                  // You can navigate to the chat screen or show a dialog, etc.
                  chatBubbleProvider.hideChatBubble();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue, // You can customize the color
                  ),
                  child: Icon(
                    Icons.chat,
                    color: Colors.white, // You can customize the color
                  ),
                ),
              ),
            ),
          ),
        );

        // Return an empty widget or null
        return SizedBox.shrink();
      },
    );
  }
}
