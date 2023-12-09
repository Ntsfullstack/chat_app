import 'package:chat_app/contact_screen/contact_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/home_page/chat_user_card.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/more_widget/more_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: Colors.white,
        elevation: 0,
        bottomOpacity: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Contact',
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
            child: SvgPicture.asset('assets/vectors/ic_add.svg'),
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
              autofocus: true,
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
                      return ListView.separated(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(),
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
}
