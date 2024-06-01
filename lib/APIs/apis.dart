import 'dart:convert';
import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static late ChatUser me;

  static User get user => auth.currentUser!;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        print('Push Token: $t');
      }
    });

    // for handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  // for sending push notification
  static Future<void> sendPushNotification(ChatUser chatUser,
      String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "some_data": "User ID: ${me.id}",
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
            'key=AAAAdlX6vHg:APA91bHjG826vkW9RqX6o3nbZSRHBsdLGXcEUpZ8Ji2tS3gBAHP2GzBx8CKYv8NeDwiwvSDeYH2oQYqAix-tBoCjz3qsLI0Od9FZ2qz-A2yWtgD9-rbR7abHu5Ri52CXgP21FYpteZ5A'
          },
          body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('\nsendPushNotificationE: $e');
    }
  }

//check if user exist or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //add chat user
  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    print('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      print('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        getFirebaseMessagingToken();
        await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
      } else {
        createUser().then((value) => getSelfInfo());
      }
    });
  }

  //create a new user
// create a new user
  static Future<void> createUser() async {
    final time = DateTime.now().toUtc(); // Use UTC time for consistency
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using ",
      image: user.photoURL.toString(),
      createdAt: time.toString(),
      isOnline: false,
      lastActive: time.toString(),
      pushToken: '',
      // Set lastMessageTime to current time
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return APIs.firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return APIs.firestore.collection('users').snapshots();
  }

  static Future<void> updateUserInfor() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

//update profile picture
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path
        .split('.')
        .last;
    print('Extension: $ext');

    // Use the user's UID and a timestamp as part of the storage path
    final timestamp = DateTime
        .now()
        .millisecondsSinceEpoch;
    final ref = storage
        .ref()
        .child('profile_pictures/${user.uid}/profile_picture_$timestamp.$ext');

    // Uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // Updating image in Firestore
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  static Future<List<String>> getAllUserImages(String uid) async {
    List<String> userImages = [];

    try {
      // Ensure that uid is not null before accessing it
      if (uid != null) {
        // Reference to the user's profile pictures folder
        final userImagesRef = storage.ref().child('profile_pictures/$uid');

        // Get all items (images) in the folder
        final ListResult result = await userImagesRef.listAll();

        // Loop through each item and add download URL to the list
        for (final Reference ref in result.items) {
          final String downloadURL = await ref.getDownloadURL();
          userImages.add(downloadURL);
        }
      } else {
        print('Error: User ID is null.');
      }
    } catch (e) {
      print('Error fetching user images: $e');
    }

    return userImages;
  }

  // static Future<String?> UpStory(File file) async {
  //   try {
  //     final ext = file.path.split('.').last;
  //     print('Extension: $ext');
  //     final ref = storage.ref().child('story/${user.uid}.$ext');
  //
  //     // Upload image
  //     final UploadTask uploadTask = ref.putFile(
  //       file,
  //       SettableMetadata(contentType: 'image/$ext'),
  //     );
  //
  //     // Wait for the upload to complete
  //     final TaskSnapshot taskSnapshot = await uploadTask;
  //     final String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //
  //     // After uploading, save story data to Firestore
  //     await FirebaseFirestore.instance.collection('stories').doc(user.uid).set({
  //       'url': downloadURL,
  //       'uploadedAt': FieldValue.serverTimestamp(),
  //     });
  //
  //     return downloadURL; // Return the uploaded image URL
  //   } catch (e) {
  //     print('Error uploading story: $e');
  //     return null; // Return null in case of an error
  //   }
  // }
  //
  // static Future<List<String>> getUserStories() async {
  //   final user = auth.currentUser;
  //   if (user == null) {
  //     print('User not authenticated');
  //     return [];
  //   }
  //
  //   final userStoryFolder = 'story/${user.uid}';
  //   final ref = storage.ref().child(userStoryFolder);
  //
  //   try {
  //     final ListResult result = await ref.listAll();
  //     final List<String> storyUrls = [];
  //
  //     for (final item in result.items) {
  //       final url = await item.getDownloadURL();
  //       storyUrls.add(url);
  //     }
  //
  //     return storyUrls;
  //   } catch (e) {
  //     print('Error getting user stories: $e');
  //     return [];
  //   }
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'push_token': me.pushToken,
    });
  }

  //* chat screen*//
  static String getConversationID(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return APIs.firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent',
        descending: true) // Sắp xếp theo thời gian gửi giảm dần
        .snapshots();
  }

//for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg,
      Type type) async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

// update read status
  static Future<void> updateMessageReadStatus(Message messages) async {
    firestore
        .collection('chat/${getConversationID(messages.fromId)}/messages/')
        .doc(messages.sent)
        .update({'read': DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

//send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path
        .split('.')
        .last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime
            .now()
            .millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}
