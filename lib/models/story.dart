import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  late String url;
  late DateTime uploadedAt;
  late bool viewed;

  Story({
    required this.url,
    required this.uploadedAt,
    required this.viewed,
  });

  // Phương thức giúp chuyển đổi dữ liệu từ Firestore thành đối tượng Story
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      url: json['url'] ?? '',
      uploadedAt: json['uploadedAt'] != null
          ? (json['uploadedAt'] as Timestamp).toDate()
          : DateTime.now(),
      viewed: json['viewed'] ?? false,
    );
  }

  // Phương thức giúp chuyển đổi đối tượng Story thành dữ liệu để lưu trữ trong Firestore
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'uploadedAt': uploadedAt,
      'viewed': viewed,
    };
  }
}
