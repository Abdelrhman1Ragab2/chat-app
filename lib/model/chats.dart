import 'package:chat_if/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  List<Message> messages;
  String userAId;
  String userBId;
  Timestamp lastUpdate;
  bool userAActive;
  bool userBActive;


  Chat({
    required this.id,
    required this.messages,
    required this.userAId,
    required this.userBId,
    required this.userAActive,
    required this.userBActive,
    required this.lastUpdate,
  });

  static Map<String, dynamic> toFirebase(
    Chat chat,
    SetOptions? setOptions,
  ) {
    return {
      chatMessageKey: chat.messages,
      chatUserAKey: chat.userAId,
      chatUserBKey: chat.userBId,
      chatUserAActiveKey:chat.userAActive,
      chatUserBActiveKey:chat.userBActive,
      chatLastUpdateKey:chat.lastUpdate,
    };
  }

  static Chat fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Chat(
      id: ds.id,
      messages: (ds.get(chatMessageKey) as List).cast(),
      userAId: ds.get(chatUserAKey),
      userBId: ds.get(chatUserBKey),
      userAActive:  ds.get(chatUserAActiveKey),
      userBActive:  ds.get(chatUserBActiveKey),
      lastUpdate:  ds.get(chatLastUpdateKey),
    );
  }

  static const chatMessageKey = "chat Messages";
  static const chatUserAKey = "user A";
  static const chatUserBKey = "user B ";
  static const chatUserAActiveKey = "user A active";
  static const chatUserBActiveKey = "user B active";
  static const chatLastUpdateKey = "last update";
}
