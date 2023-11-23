import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController controller = PageController();

  void _setupFirebaseMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        await buildNotificationSnackBar(message);
      }
      debugPrint('RemoteMessage $message');
    });
  }

  Future<void> buildNotificationSnackBar(RemoteMessage? noti) async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: const <Widget>[
          //add các widget khác vào đây
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/vectors/ic_contact.svg",
            ),
            activeIcon: Column(
              children: [
                const Text(
                  "Contacts",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1828)),
                ),
                SizedBox(height: 8),
                Container(
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: const Color(0xFF0F1828),
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/vectors/ic_chat.svg",
            ),
            activeIcon: Column(
              children: [
                const Text(
                  "Chats",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1828),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: const Color(0xFF0F1828),
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/vectors/ic_more.svg",
            ),
            activeIcon: Column(
              children: [
                const Text(
                  "More",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1828)),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: const Color(0xFF0F1828),
                  ),
                ),
              ],
            ),
            label: '',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (index) {
          print("HiSmile $index");
          setState(() {
            _selectedIndex = index;
            controller.jumpToPage(index);
          });
        },
        elevation: 5,
      ),
    );
  }
}
