// import 'package:chat_app/models/story.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class StoryScreen extends StatelessWidget {
//   final String userId;
//
//   const StoryScreen(
//       {Key? key,
//       required this.userId,
//       required String imagePath,
//       required Null Function() onStoryRemoved})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Story Screen'),
//       ),
//       body: FutureBuilder(
//         // Load stories for the selected user
//         future: _loadStories(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error loading stories: ${snapshot.error}');
//           } else {
//             // Display stories
//             final stories = snapshot.data as List<Story>;
//             return ListView.builder(
//               itemCount: stories.length,
//               itemBuilder: (context, index) {
//                 return Image.network(stories[index].url);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Future<List<Story>> _loadStories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('stories')
//           .doc(userId)
//           .get();
//       if (snapshot.exists) {
//         final data = snapshot.data() as Map<String, dynamic>;
//         final story = Story.fromJson(data);
//         return [story];
//       } else {
//         return [];
//       }
//     } catch (e) {
//       print('Error loading stories: $e');
//       return [];
//     }
//   }
// }
