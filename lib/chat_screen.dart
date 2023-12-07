import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/home_page/message_card.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
          actions: [
            IconButton(
              onPressed: () {
                // Handle search action
              },
              icon: const Icon(Icons.search, color: Colors.black54),
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert, // Replace with the icon you want to use
                color: Colors.black, // Set the color to black
              ),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    child: Text('Option 1'),
                  ),
                  const PopupMenuItem(
                    child: Text('Option 2'),
                  ),
                  const PopupMenuItem(
                    child: Text('Option 3'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];
                      _list.sort((a, b) => a.sent.compareTo(b.sent));
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: 20),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index]);
                            });
                      } else {
                        return const Center(
                          child: Text(
                            'Let start chat !',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput()
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: CachedNetworkImage(
              width: 45,
              height: 45,
              imageUrl: widget.user.image,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              const Text(
                'Last seen not available',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => {},
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.black54)),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Type Something',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 12),
                      border: InputBorder.none,
                    ),
                  )),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.image, color: Colors.black54),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.camera_alt_rounded,
                        color: Colors.black54),
                  ),
                  const SizedBox(width: 5)
                ],
              ),
            ),
          ),
          //send message button
          MaterialButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  APIs.sendMessage(widget.user, _textController.text);
                  _textController.text = '';
                }
              },
              minWidth: 0,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 5, left: 10),
              shape: const CircleBorder(),
              color: Colors.green,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 28,
              ))
        ],
      ),
    );
  }
}
