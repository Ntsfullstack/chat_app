import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/splashscreen.dart';
import 'package:chat_app/helper/dialog.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Profile')),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await APIs.updateActiveStatus(false);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                  APIs.auth = FirebaseAuth.instance;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()),
                    (Route<dynamic> route) => false,
                  );
                });
              });
            },
            icon: const Icon(
              Icons.logout,
            ),
            label: const Text('Logout'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image.file(
                                File(_image!),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: CachedNetworkImage(
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image ?? '',
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: -20,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(widget.user.email),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(),
                      hintText: 'eg. Sondeptraivcl',
                      label: Text('Name'),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.info_outline, color: Colors.blue),
                      border: OutlineInputBorder(),
                      hintText: 'eg. Sondeptraivcl',
                      label: Text('About'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(150, 50),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfor().then((value) => {
                              Dialogs.showSnackbar(
                                  context, 'Update Successfully')
                            });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: const Text(
                      'Update',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                  SizedBox(height: 25),
                  FutureBuilder<List<String>>(
                    future: APIs.getAllUserImages(APIs.me.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container(); // No images to display
                      } else {
                        return Column(
                          children: [
                            const SizedBox(height: 10),
                            Text('User Images:'),
                            SizedBox(
                              height: 100, // Adjust the height as needed
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      snapshot.data![index],
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 20),
          children: [
            const Text(
              'Pick profile picture',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(100, 100),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      print(
                          'image path : ${image.path} -- MimeType: ${image.mimeType}');
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateProfilePicture(File(_image!));
                    }
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/add.png'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(100, 100),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      print('image path : ${image.path}');
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateProfilePicture(File(_image!));
                    }
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/add.png'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
