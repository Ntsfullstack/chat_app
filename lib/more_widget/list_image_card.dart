import 'package:chat_app/more_widget/view_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/home_screen.dart';
import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import '../main.dart';

class list_image_card extends StatefulWidget {
  final ChatUser user;

  const list_image_card({Key? key, required this.user}) : super(key: key);

  @override
  State<list_image_card> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<list_image_card> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      elevation: 0.2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              leading: Stack(
                children: [
                  // User profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  // Positioned widget for the online indicator
                  if (list.isNotEmpty && list[0].isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                list.isNotEmpty
                    ? list[0].isOnline
                        ? 'Online'
                        : MyDateUtil.getLastActiveTime(
                            context: context, lastActive: list[0].lastActive)
                    : MyDateUtil.getLastActiveTime(
                        context: context, lastActive: widget.user.lastActive),
              ),
            );
          },
        ),
      ),
    );
  }
}
