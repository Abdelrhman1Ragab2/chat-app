import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String? text;
  String?imgurl;
  Timestamp createdAt;
  String senderId;
  String receiverId;
  bool image;

  Message({
    required this.id,
    required this.text,
    required this.imgurl,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.image,
  });

  static Map<String, dynamic> toFirebase(
    Message message,
    SetOptions? setOptions,
  ) {
    return {
      messageText: message.text,
      messageImgUrl:message.imgurl,
      messageCreatedAt: message.createdAt,
      messageSender: message.senderId,
      messageReceiver: message.receiverId,
      messageImage:message.image
    };
  }

  static Message fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Message(
      id: ds.id,
      text: ds.get(messageText),
      imgurl:  ds.get(messageImgUrl),
      senderId: ds.get(messageSender),
      receiverId: ds.get(messageReceiver),
      createdAt: ds.get(messageCreatedAt),
      image: ds.get(messageImage),
    );
  }

  static const messageText = "Text";
  static const messageImgUrl = "ImgUrl";
  static const messageCreatedAt = "createdAt";
  static const messageSender = "senderId";
  static const messageReceiver = "receiverId ";
  static const messageImage = "isImage";
}
