import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0; // Index của tab được chọn

  // Danh sách các icon và text tương ứng
  final List<Widget> icons = [
    const Icon(Icons.group),
    const Icon(Icons.chat),
    const Icon(Icons.more_horiz),
  ];

  final List<Widget> labels = [
    const Text(
      'Contacts',

      style: TextStyle(
          fontSize: 20,
          fontFamily: 'Mulish',

      ), // Điều chỉnh kích thước chữ nếu cần thiết
    ),
    const Text(
      'Chats',
      style: TextStyle(fontSize: 20,
        fontFamily: 'Mulish',),

    ),
    const Text(
      'More',
      style: TextStyle(
          fontSize: 20,
        fontFamily: 'Mulish',

      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: List.generate(
        icons.length,
            (index) => BottomNavigationBarItem(
          icon: _selectedIndex == index ? labels[index] : icons[index],
          label: '',
        ),
      ),
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
