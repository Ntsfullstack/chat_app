import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/chat_user.dart';

import '../main.dart';
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}
class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: (){},
        child:  ListTile(
          //leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height *  3),
            child: CachedNetworkImage(
              width: mq.height *  .075,
              height:mq.height *  .075,
              imageUrl: widget.user.image,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          title: Text(widget.user.name),
          //last message
          subtitle: Text(widget.user.about, maxLines: 1),
          trailing: Container (
            width:20 ,
            height: 20,
            decoration: BoxDecoration (
              color:  Colors.greenAccent.shade400, borderRadius: BorderRadius.circular(10)
            ),
          ),
          //trailing: const Text('12.00 PM', style: TextStyle(color: Colors.black54),),
        ),
      ),
    );
  }
}