import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/home_screen.dart';
import 'package:chat_app/contact_screen/contact_screen.dart';
import 'package:chat_app/more_widget/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  late PageController controller;

  final pages = [
    const CntactsPage(),
    const HomePage(),
    const MoreLight(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      controller.jumpToPage(index);
      _selectedIndex = index;
    });
  }

  //Get user data and current user if user has logged in
  @override
  void initState() {
    controller = PageController();
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/ic_user_group.svg'),
            label: '',
            activeIcon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Contacts"),
                Stack(
                  children: [
                    Positioned(
                        child: Text(
                      '.',
                      style: TextStyle(fontSize: 40, height: .3),
                    ))
                  ],
                )
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/ic_chat.svg'),
            label: '',
            activeIcon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Chats"),
                Stack(
                  children: [
                    Positioned(
                        child: Text(
                      '.',
                      style: TextStyle(fontSize: 40, height: .3),
                    ))
                  ],
                )
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/ic_more_horizontal.svg'),
            label: '',
            activeIcon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("More"),
                Stack(
                  children: [
                    Positioned(
                        child: Text(
                      '.',
                      style: TextStyle(fontSize: 40, height: .3),
                    ))
                  ],
                )
              ],
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        elevation: 5,
        selectedFontSize: 0,
      ),
    );
  }
}
