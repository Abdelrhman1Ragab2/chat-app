import 'package:chat_if/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  String userAId;
  String userBId;
  Timestamp lastUpdate;
  //


  Chat({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.lastUpdate,
  });

  static Map<String, dynamic> toFirebase(
    Chat chat,
    SetOptions? setOptions,
  ) {
    return {
      chatUserAKey: chat.userAId,
      chatUserBKey: chat.userBId,
      chatLastUpdateKey:chat.lastUpdate,
    };
  }

  static Chat fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Chat(
      id: ds.id,
      //messages: (ds.get(chatMessageKey) as List).cast(),
      userAId: ds.get(chatUserAKey),
      userBId: ds.get(chatUserBKey),
      lastUpdate:  ds.get(chatLastUpdateKey),
    );
  }

  static const chatUserAKey = "user A";
  static const chatUserBKey = "user B ";
  static const chatLastUpdateKey = "last update";
}
