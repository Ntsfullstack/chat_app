
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/more_widget/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MoreLight extends StatefulWidget {
  final ChatUser user;

   MoreLight({Key? key, required this.user}) : super(key: key);

  @override
  _MoreLightState createState() => _MoreLightState();
}


class _MoreLightState extends State<MoreLight> {
  Widget buildSettingRow(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F1828),
            fontSize: 14,
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w600,
            height: 0.12,
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF277AC7),
          size: 16,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top section with user details
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (_) => ProfileScreen(user: APIs.me))
                );
                // Handle user details tap
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User details
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFECECEC),
                          ),
                          child: Center(
                            child: widget.user.image != null
                                ? CachedNetworkImage(
                              width: 60,
                              height: 60,
                              imageUrl: widget.user.image ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                    backgroundImage: imageProvider,
                                  ),
                              placeholder: (context, url) =>
                              const CircleAvatar(
                                child: Icon(CupertinoIcons.person),
                              ),
                              errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                child: Icon(CupertinoIcons.person),
                              ),
                            )
                                : const CircleAvatar(
                              child: Icon(CupertinoIcons.person),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.name ?? 'User name',
                              style: const TextStyle(
                                color: Color(0xFF0F1828),
                                fontSize: 20,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              widget.user.email ?? '+62 1309 - 1710 - 1920',
                              style: const TextStyle(
                                color: Color(0xFFADB5BD),
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.user.about ?? '+62 1309 - 1710 - 1920',
                              style: const TextStyle(
                                color: Color(0xFF9399A1),
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Logout button
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Middle section with various settings
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buildSettingRow('Account', Icons.account_circle),
                    const SizedBox(height: 30),
                    buildSettingRow('Chats', Icons.chat),
                    const SizedBox(height: 30),
                    buildSettingRow('Appearance', Icons.color_lens),
                    const SizedBox(height: 30),
                    buildSettingRow('Notification', Icons.notifications),
                    const SizedBox(height: 30),
                    buildSettingRow('Privacy', Icons.privacy_tip),
                    const SizedBox(height: 30),
                    buildSettingRow('Data Usage', Icons.data_usage),
                    const SizedBox(height: 30),
                    buildSettingRow('Help', Icons.help),
                    const SizedBox(height: 30),
                    buildSettingRow('Invite Your Friends', Icons.person_add),
                  ],
                ),
              ),
            ),
            // Bottom section with progress indicator
          ],
        ),
      ),

    );
  }
}
