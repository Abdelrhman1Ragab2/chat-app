import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  String text;
  Timestamp createdAt;
  String senderId;
  String receiverId;

  Message({
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
  });

  static Map<String, dynamic> toFirebase(Message message,
      SetOptions? setOptions,) {
    return {
      messageText: message.text,
      messageCreatedAt: message.createdAt,
      messageSender: message.senderId,
      messageReceiver: message.receiverId
    };
  }

  static Message fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Message(text: ds.get(messageText),
        senderId: ds.get(messageSender),
        receiverId: ds.get(messageReceiver),
        createdAt: ds.get(messageCreatedAt));
  }

  static const messageText = "messageText";
  static const messageCreatedAt = "createdAt";
  static const messageSender = "senderId";
  static const messageReceiver = " receiverId ";
}
