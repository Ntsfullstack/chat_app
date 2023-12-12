import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/more_widget/view_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile_dialog extends StatelessWidget {
  const Profile_dialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: 30,
        height: 300,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(115),
                child: CachedNetworkImage(
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  imageUrl: user.image ?? '',
                  // Ensure imageUrl is not null
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
            ),
            Positioned(
              left: 30,
              top: 10,
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
                top: 0,
                right: 10,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProfileScreen(user: user)));
                  },
                  minWidth: 0,
                  padding: EdgeInsets.all(0),
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.info,
                    color: Colors.blue,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
