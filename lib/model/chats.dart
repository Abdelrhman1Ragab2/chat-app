import 'package:chat_if/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  List<String> users;
 // List<String> messageIds;
  Timestamp lastUpdate;



  Chat({
    required this.id,
    required this.users,
   // required this.messageIds,
    required this.lastUpdate,
  });

  static Map<String, dynamic> toFirebase(
    Chat chat,
    SetOptions? setOptions,
  ) {
    return {
      chatIdKey:chat.id,
      chatUsersKey: chat.users,
     // chatMessagesKey:chat.messageIds,
      chatLastUpdateKey:chat.lastUpdate,
    };
  }

  static Chat fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Chat(

      id: ds.id,
  //    messageIds: (ds.get(chatMessagesKey) as List).cast(),
      users:  (ds.get(chatUsersKey) as List).cast(),
      lastUpdate:  ds.get(chatLastUpdateKey),
    );
  }

  static const chatIdKey = "id";
  static const chatUsersKey = "users";
  static const chatMessagesKey = "messages";
  static const chatLastUpdateKey = "last update";
}
