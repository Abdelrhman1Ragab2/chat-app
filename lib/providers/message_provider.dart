import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';

class MessageProvider with ChangeNotifier {
  final _messageCollection = FirebaseFirestore.instance
      .collection("chat")
      .withConverter(
          fromFirestore: Message.fromFirebase, toFirestore: Message.toFirebase);
 

  Future<void> addMessage(Message message) async {
    await _messageCollection.doc().set(message);
  }

  Stream<List<Message>> getMessageStream({required String senderId,required String receiverId}) {


 Query<Message> query=_messageCollection.orderBy(Message.messageCreatedAt,descending:true);
  // where(Message.messageSender,arrayContains:  {senderId ,receiverId} );
  // query.where(Message.messageReceiver,arrayContains: {senderId,receiverId});

     return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }


  List<Message> filteringMessage(List<Message> messages,{required String senderId,required String receiverId})
  {

   List<Message>newMessage=[];
   messages.forEach((element) {
    if(element.senderId==senderId && element.receiverId == receiverId ||
        element.senderId==receiverId && element.receiverId ==senderId)
      newMessage.add(element);
   });
   return newMessage;
  }

}
