import 'dart:developer';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Homescreen.dart';
import 'package:chat_app/bottom_bar_screen/bottom_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'package:chat_app/Splashscreen.dart';

//splash screen
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        //navigate to home screen
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const BottomBarScreen()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SplashScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    return Scaffold(
      body: Stack(
        children: [
          //app logo
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 200, // Thay đổi kích thước theo ý muốn
                height: 200,
              ),
            ),
          ),
          // Thêm các phần khác vào đây nếu cần
        ],
      ),
    );

    ;
  }
}
