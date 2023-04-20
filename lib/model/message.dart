import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String? text;
  String?imgUrl;
  Timestamp createdAt;
  String chatId;
  String senderId;
  String receiverId;
  bool image;

  Message({
    required this.id,
    required this.chatId,
    required this.text,
    required this.imgUrl,
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
      messageChatId:message.chatId,
      messageText: message.text,
      messageImgUrl:message.imgUrl,
      messageCreatedAt: message.createdAt,
      messageSender: message.senderId,
      messageReceiver: message.receiverId,
      messageImage:message.image
    };
  }

  static Message fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Message(
      id: ds.id,
      chatId: ds.get(messageChatId),
      text: ds.get(messageText),
      imgUrl:  ds.get(messageImgUrl),
      senderId: ds.get(messageSender),
      receiverId: ds.get(messageReceiver),
      createdAt: ds.get(messageCreatedAt),
      image: ds.get(messageImage),
    );
  }

  static const messageChatId = "chatId";
  static const messageText = "Text";
  static const messageImgUrl = "ImgUrl";
  static const messageCreatedAt = "createdAt";
  static const messageSender = "senderId";
  static const messageReceiver = "receiverId ";
  static const messageImage = "isImage";
}
