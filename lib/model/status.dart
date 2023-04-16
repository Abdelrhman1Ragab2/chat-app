import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  String id;
  String content;
  String userId;
  List<String> friendViews;
  List<String> friendCanViews;
  Timestamp time;
  bool isImage;


  Status({
    required this.id,
    required this.userId,
    required this.content,
    required this.isImage,
    required this.time,
    required this.friendViews,
    required this.friendCanViews,
  });

  static Map<String, dynamic> toFirebase(
      Status status, SetOptions? setOptions) {
    return {
      userIdKey:status.userId,
      contentKey: status.content,
      imageKey: status.isImage,
      timeKey: status.time,
      friendViewsKey: status.friendViews,
      friendCanViewsKey: status.friendCanViews,
    };
  }

  static Status fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Status(
      id: ds.id,
      userId: ds.get(userIdKey),
      content: ds.get(contentKey),
      isImage: ds.get(imageKey),
      time: ds.get(timeKey),
      friendViews: (ds.get(friendViewsKey) as List).cast(),
      friendCanViews: (ds.get(friendCanViewsKey) as List).cast(),
    );
  }

  static const userIdKey = "userId";
  static const contentKey = "content";
  static const imageKey = "isImage";
  static const timeKey = "cratedTime";
  static const friendViewsKey = "friendViews";
  static const friendCanViewsKey = "friendCanViews";
}
