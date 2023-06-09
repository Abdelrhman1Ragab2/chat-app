import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';

class MessageProvider with ChangeNotifier {
  final _messageCollection = FirebaseFirestore.instance
      .collection("message")
      .withConverter(
          fromFirestore: Message.fromFirebase, toFirestore: Message.toFirebase);

  Message? replyMessage;
  bool isReply = false;

  crateReplyMessage(Message? message) {
    isReply = true;
    replyMessage = message;
    notifyListeners();
  }

  closeReplyMessage() {
    isReply = false;
    notifyListeners();
  }

  Future<void> addMessage(Message message) async {
    await _messageCollection.doc().set(message);
  }

  Future<void> deleteMessage(String messageId) async {
    await _messageCollection.doc(messageId).delete();
  }

  Stream<List<Message>> getMessageStream(String chatId) {
    Query<Message> query =
        _messageCollection.orderBy(Message.messageCreatedAt, descending: true);
    return query
        .where(Message.messageChatId, isEqualTo: chatId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

// List<Message> filteringMessage(List<Message> messages,{required String senderId,required String receiverId})
// {
//
//  List<Message>newMessage=[];
//  messages.forEach((element) {
//   if(element.senderId==senderId && element.receiverId == receiverId ||
//       element.senderId==receiverId && element.receiverId ==senderId)
//     newMessage.add(element);
//  });
//  return newMessage;
// }
}
