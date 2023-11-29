import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app/home_page/chat_detail_screen.dart';
import 'package:chat_app/bottom_bar_screen/bottom_bar_screen.dart';
import 'package:flutter_svg/svg.dart';
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
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> people = [
    'nyc 1',
    'nyc 2',
    'nyc 3',
    'nyc 4',
    'nyc 5',
    'nyc 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          bottomOpacity: 0,
          title: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Chats',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Mulish'
                )

            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SvgPicture.asset('assets/vectors/ic_new_message.svg'),
            )
          ],
        ),
        bottomNavigationBar: BottomBarScreen(), // Gọi đến BottomBarScreen
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                      height: 58,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: CupertinoTextField(
                        placeholder: 'Search',
                        prefix: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.search,
                              color: Color.fromARGB(66, 0, 0, 0)),
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
                      )),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      itemCount: people.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, int i) {
                        bool isOnline =
                        true; // Replace with the actual online status of the user

                        return GestureDetector(
                          onTap: () {
                            // Navigate to chat detail screen when user is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    ChatDetailsScreen(i + 1, people[i]),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/avatars/${i + 1}.png'),
                                            scale: 10,
                                            fit: BoxFit.contain),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isOnline
                                              ? Colors.green
                                              : Colors.grey,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  people[i],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  // list item chat
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: people.length,
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      ChatDetailsScreen(
                                          index + 1, people[index]),
                                ),
                              );
                            },
                            leading: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset(
                                  "assets/images/avatars/${index + 1}.png",
                                ),
                              ),
                            ),
                            title: Text(
                              people[index],
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              "Bạn có tin nhắn mới ",
                            ),
                            trailing: Column(
                              children: [
                                const Text(
                                  '00.21',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue),
                                      child: const Center(
                                        child: Text(
                                          '9+',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })
                ],
              )
            ],
          ),
        ));
  }
}
