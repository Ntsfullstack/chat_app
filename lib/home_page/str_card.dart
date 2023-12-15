import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chat_app/models/chat_user.dart';

class StoryCard extends StatefulWidget {
  final ChatUser user;

  const StoryCard({Key? key, required this.user}) : super(key: key);

  @override
  State<StoryCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<StoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // User profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          // Adjust the spacing between online indicator and text
          // User name
          SizedBox(height: 5),
          Text(
            widget.user.name,
            style: TextStyle(
              fontSize: 12, // Adjust the font size as needed
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
