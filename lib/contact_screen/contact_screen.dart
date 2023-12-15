import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/bottom_bar_screen/bottom_bar_screen.dart';
import 'package:chat_app/contact_screen/contact_user_card.dart';
import 'package:chat_app/helper/dialog.dart';
import 'package:chat_app/home_page/chat_user_card.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/more_widget/more_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CntactsPage extends StatefulWidget {
  const CntactsPage({Key? key});

  @override
  State<CntactsPage> createState() => _CntactsPageState();
}

class _CntactsPageState extends State<CntactsPage> {
  TextEditingController searchController = TextEditingController();
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 1),
          child: Text(
            'Contacts',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Mulish',
              height: 1,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _addChatuserDialog();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SvgPicture.asset('assets/vectors/ic_add.svg'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
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
                child: Icon(Icons.search, color: Colors.black),
              ),
              placeholderStyle:
                  const TextStyle(color: Color.fromARGB(66, 0, 0, 0)),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFC1C4D3),
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
                          return Contact_user_Card(
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

//for add new chat user
  void _addChatuserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    size: 30,
                  ),
                  Text(' Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
