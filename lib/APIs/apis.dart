import 'dart:math';

import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static late ChatUser me;
  static User get user => auth.currentUser!;
  static Future<bool> userExists() async {
    return (await firestore
        .collection('users')
        .doc(user.uid)
        .get()
    ).exists;

  }

  static Future<void> getSelfInfo() async {
   await firestore.collection('users').doc(user.uid).get().then((user) {
     if(user.exists) {
       me = ChatUser.fromJson(user.data()!);
       print('My Data: ${user.data()}');
     }else {
       createUser().then((value) => getSelfInfo());
     }

   });


  }
  //create a new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
      about: "Hey, I'm using ",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: ''

    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());

  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return APIs.firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid )
        .snapshots();
    }
}