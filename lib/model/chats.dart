import 'package:chat_if/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  List<Message> messages;
  String userAId;
  String userBId;

  Chat({
    required this.id,
    required this.messages,
    required this.userAId,
    required this.userBId,
  });

  static Map<String, dynamic> toFirebase(
    Chat chat,
    SetOptions? setOptions,
  ) {
    return {
      chatMessageKey: chat.messages,
      chatUserAKey: chat.userAId,
      chatUserBKey: chat.userBId,
    };
  }

  static Chat fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Chat(
      id: ds.id,
      messages: (ds.get(chatMessageKey) as List).cast(),
      userAId: ds.get(chatUserAKey),
      userBId: ds.get(chatUserBKey),
    );
  }

  static const chatMessageKey = "chat Messages";
  static const chatUserAKey = "user A";
  static const chatUserBKey = "user B ";
}
