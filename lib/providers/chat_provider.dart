import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/chats.dart';
import '../model/chats.dart';
import '../model/chats.dart';

class ChatProvider with ChangeNotifier {
  final _chatCollection = FirebaseFirestore.instance
      .collection("chats")
      .withConverter(
          fromFirestore: Chat.fromFirebase, toFirestore: Chat.toFirebase);

  Future<void> crateChat(Chat chat) async {
    await _chatCollection.doc().set(chat);
  }

  Future<void> deleteChat(String id) async {
    await _chatCollection.doc(id).delete();
  }

  Stream<List<Chat>> getChatStream() {
    return _chatCollection
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
  Stream<Chat?> getChatStreamById(String id) {
    return _chatCollection.doc(id).snapshots().map((ds) => ds.data());
  }

  List<Chat> filteringChat(List<Chat> chats,
      {required String currentUserId}) {
    List<Chat> newChats = [];
    chats.forEach((element) {
      if (element.userAId == currentUserId ||
          element.userBId== currentUserId )
        newChats.add(element);
    });
    return newChats;
  }
}
