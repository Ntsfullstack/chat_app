import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Homescreen.dart';
import 'package:chat_app/Splashscreen.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/more_widget/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MoreLight extends StatefulWidget {
  @override
  _MoreLightState createState() => _MoreLightState();
}

class _MoreLightState extends State<MoreLight> {
  List<ChatUser> list = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      await user.reload();
      user = auth.currentUser;

      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      // Clear user information from local cache
      setState(() {
        _user = null;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

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
                            child: _user != null
                                ? CachedNetworkImage(
                              width: 60,
                              height: 60,
                              imageUrl: _user!.photoURL ?? '',
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
                              _user?.displayName ?? 'User name',
                              style: const TextStyle(
                                color: Color(0xFF0F1828),
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                height: 2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _user?.email ?? '+62 1309 - 1710 - 1920',
                              style: const TextStyle(
                                color: Color(0xFFADB5BD),
                                fontSize: 12,
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            // Show progress dialog

            // Update active status


            // Sign out from app
            await APIs.auth.signOut().then((value) async {
              // Sign out from Google
              await GoogleSignIn().signOut().then((value) {
                // Hide progress dialog
                Navigator.pop(context);

                // Move to home screen
                Navigator.pop(context);

                // Replace home screen with login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                );
              });
            });
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ),
    );
  }
}
