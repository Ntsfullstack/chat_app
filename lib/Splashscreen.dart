import 'dart:io';
import 'package:chat_app/loginWithGoogle.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat_app/service/isar_service.dart';
import 'package:chat_app/Homescreen.dart';
import 'package:chat_app/phoneInput.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
    _initialPage();
  }

  void _initialPage() async {
    await Future.delayed(const Duration(seconds: 2));
    final isarService = IsarService();
    final phones = await isarService.getAllPhoneNumbers();
    if (phones.isNotEmpty) {
      if (context != null && context!.mounted) {
        Navigator.of(context!).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } else {
      if (context != null && context!.mounted) {
        Navigator.of(context!).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  InputPhoneNumber(),
          ),
        );
      }
    }
  }

  Future<void> _initApp() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.requestPermission();
      } else {
        await Permission.notification.isDenied.then((value) {
          if (value) {
            Permission.notification.request();
          }
        });
      }

      final deviceToken = await FirebaseMessaging.instance.getToken();
      // Do something with deviceToken

      // Uncomment the following line if you need to perform some action after getting the token.
       _onTokenRefresh(deviceToken);
    });
  }

  // Uncomment the following function if you need to perform some action after getting the token.
   void _onTokenRefresh(String? token) {
  //   // Perform your action with the token
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 135,
                    bottom: 42,
                  ),
                  child: Image.asset(
                    'assets/images/img_background.png',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 48,
                  ),
                  child: Text(
                    'Connect easily with your family and friends over countries',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Terms & Privacy Policy',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context)=>  LoginScreen(),
                  )
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                top: 18,
                bottom: 20,
                left: 24,
                right: 24,
              ),
              height: 52,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF002ED3),
              ),
              child: const Center(
                child: Text(
                  "Start Messaging",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
