import 'dart:io';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/bottom_bar_screen/bottom_bar_screen.dart';
import 'package:chat_app/home_page/chat_user_card.dart';
import 'package:chat_app/home_page/storypage.dart';
import 'package:chat_app/home_page/str_card.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/more_widget/more_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  String? _image;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      print('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Padding(
          padding: EdgeInsets.only(left: 1),
          child: Text(
            'Chats',
            style: TextStyle(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 0.5,
            child: SizedBox(
              height: 89, // Adjust the height based on your design
              child: Center(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 80);
                            if (image != null) {
                              print(
                                  'image path : ${image.path} -- MimeType: ${image.mimeType}');
                              setState(() {
                                _image = image.path;
                              });
                              APIs.UpStory(File(_image!));
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFDADAE5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 12,
                                  top: 12,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Stack(
                                      children: [
                                        // Add your existing stack content here
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your Story',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: APIs.getAllUsers(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data
                                      ?.map((e) => ChatUser.fromJson(e.data()))
                                      .toList() ??
                                  [];
                              if (_list.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : _list.length,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return StoryCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _list[index],
                                    );
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
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 1),
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: CupertinoTextField(
              onTap: () {},
              placeholder: 'Name, Email,...',
              autofocus: false,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 0.5,
              ),
              onChanged: (val) {
                setState(() {
                  _isSearching = val.isNotEmpty;
                });
                _searchList.clear();
                for (var i in _list) {
                  if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                      i.email.toLowerCase().contains(val.toLowerCase())) {
                    _searchList.add(i);
                  }
                }
              },
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.search,
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.0),
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
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
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
    );
  }
}
