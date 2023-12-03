import 'dart:convert';
import 'dart:math';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/home_page/chat_detail_screen.dart';
import 'package:chat_app/home_page/chat_user_card.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/more_widget/more_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChatUser> list = [];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }
  // Added for tracking the current tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottomOpacity: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 1),
          child: Text(
            'Chats',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'Mulish',
               height: 1,
            ),

          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: SvgPicture.asset('assets/vectors/ic_new_message.svg'),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: CupertinoTextField(
              placeholder: 'Search',
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.search, color: Color.fromARGB(66, 0, 0, 0)),
              ),
              placeholderStyle:
              const TextStyle(color: Color.fromARGB(66, 0, 0, 0)),
              decoration: BoxDecoration(
                border: Border.all(
                  style: BorderStyle.none,
                ),
                color: const Color.fromARGB(255, 235, 234, 234),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                    if (list.isNotEmpty) {
                      return ListView.builder(
                        itemCount: list.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(user: list[index]);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No connection found!',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // You can add logic to navigate to different screens based on the index
          switch (index) {
            case 0:
            // Navigate to the first screen (Chats)
              break;
            case 1:
            // Navigate to the second screen (New Message)
              break;
            case 2:
            // Navigate to the third screen (More)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoreLight()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'New Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more),
            label: 'More',
          ),
        ],
      ),
    );
  }
}






