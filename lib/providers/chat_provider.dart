import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  Future<void> crateChat(Chat chat,String userId,String friendId) async {
    List<Chat>chats=await getFutureChat(userId);
    bool havePastChat=false;
    for (var element in chats) {
      if (
      element.users.contains(friendId)
      ) {
        havePastChat=true;
      }

    }
    if(havePastChat==false){
      await _chatCollection.doc().set(chat);
    }

  }

  Future<void> deleteChat(String id) async {
    await _chatCollection.doc(id).delete();
  }

  Stream<List<Chat>> getChatStream(String userId) {
    Query<Chat> query = _chatCollection.orderBy(
        Chat.chatLastUpdateKey, descending: true);

    return query.where(Chat.chatUsersKey,arrayContains: userId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
  Future<List<Chat>> getFutureChat(String userId) {
    Query<Chat> query = _chatCollection.where(Chat.chatUsersKey,arrayContains: userId);
    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList()).first;
  }


  Chat? getChatForSpecificUserAndFriend(List<Chat> chats, String userId,
      String friendId) {
    for (var element in chats) {
      if (element.users.contains(userId)&&element.users.contains(friendId)){
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
  Future<void> test(AppUser user, String friendId) async {
    return await _userCollection
        .doc(user.id)
        .update({AppUser.userBiolKey:"some need test" });
  }


  Future<void> updateChat(String chatId, {var key, var value}) async {
    return await _chatCollection.doc(chatId).update({key: value});
  }
}
