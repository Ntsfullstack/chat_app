import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String? _selectedImagePath;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: Color(0xFF0F1828),
            fontSize: 20,
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _selectAvatar(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFD3D3EA),
                    child: _selectedImagePath != null
                        ? ClipOval(
                      child: Image.file(
                        File(_selectedImagePath!),
                        fit: BoxFit.cover,
                        width: 96,
                        height: 96,
                      ),
                    )
                        : const Icon(
                      Icons.person,
                      size: 48,
                      color: Color(0xAFA7A7FF),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F7FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'First Name (Required)',
                      hintStyle: TextStyle(
                        color: Color(0xFFADB5BD),
                        fontSize: 14,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      height: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFC6C6E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Last Name (Required)',
                      hintStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w600,
                        height: 0.7,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    _saveUserInfo(_firstNameController.text, _lastNameController.text, _selectedImagePath ?? '');
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 327,
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 11),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF002DE3),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Save',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF7F7FC),
                          fontSize: 16,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectAvatar(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
      print('Selected Image Path: ${image.path}');
    } else {
      // Handle case when no image is selected
    }
  }

  Future<void> _saveUserInfo(String firstName, String lastName, String imagePath) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'firstName': firstName,
        'lastName': lastName,
        'avatarUrl': imagePath,
      });
      print('User information saved to Firestore.');
    } catch (e) {
      print('Error saving user information: $e');
    }
  }
}
