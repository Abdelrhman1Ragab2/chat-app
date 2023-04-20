import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/chats.dart';
import '../model/chats.dart';
import '../model/chats.dart';
import '../model/users.dart';

class ChatProvider with ChangeNotifier {
  final _chatCollection = FirebaseFirestore.instance
      .collection("chats")
      .withConverter(
      fromFirestore: Chat.fromFirebase, toFirestore: Chat.toFirebase);
  final _userCollection = FirebaseFirestore.instance
      .collection("user")
      .withConverter(
      fromFirestore: AppUser.fromFirebase, toFirestore: AppUser.toFirebase);

  Future<void> crateChat(Chat chat) async {
    await _chatCollection.doc().set(chat);
  }

  Future<void> deleteChat(String id) async {
    await _chatCollection.doc(id).delete();
  }

  Stream<List<Chat>> getChatStream() {
    Query<Chat> query = _chatCollection.orderBy(
        Chat.chatLastUpdateKey, descending: true);
    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<Chat?> getChatStreamById(String id) {
    return _chatCollection.doc(id).snapshots().map((ds) => ds.data());
  }

  List<Chat> filteringChat(List<Chat> chats, AppUser currentUser) {
    List<Chat> newChats = [];
    for (var element in chats) {
      if (
      (currentUser.chats.contains(element.userAId) ||
          currentUser.chats.contains(element.userBId)
              &&
              (element.userAId == currentUser.id ||
                  element.userBId == currentUser.id)
      )) {
        newChats.add(element);
      }
    }
    return newChats;
  }

  Chat? getChatForSpeceficUserAndFriend(List<Chat> chats, String userId,
      String friendId) {
    for (var element in chats) {
      if ((element.userAId == userId || element.userBId == userId) &&
          (element.userAId == friendId || element.userBId == friendId)){
        return element;
      }
    }
  }

  Future<void> updateFiends(AppUser user, String friendId) async {
    List<String> chats = user.chats;
    chats.insert(0, friendId);

    return await _userCollection
        .doc(user.id)
        .update({AppUser.userChatsKey: chats});
  }

  Future<void> updateChat(String chatId, {var key, var value}) async {
    return await _chatCollection.doc(chatId).update({key: value});
  }
}
