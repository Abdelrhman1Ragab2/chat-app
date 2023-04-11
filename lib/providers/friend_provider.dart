import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/users.dart';

class FriendProvider with ChangeNotifier{

  final _userCollection = FirebaseFirestore.instance
      .collection("user")
      .withConverter(
      fromFirestore: AppUser.fromFirebase, toFirestore: AppUser.toFirebase);

  bool showFriend=false;
  String emails="";
  String getEmail(String email)
  {
    emails=email;
    notifyListeners();
    return emails;
  }


  Future<void> updateFiends(AppUser user,  String friendId) async {
    List<String> friends=user.friends;
    friends.insert(0,friendId);

     return await _userCollection
        .doc(user.id)
        .update({AppUser.userFriendsKey: friends });
  }

  Future<void> updateFiendsRequests(AppUser friend,  String userId) async {
    List<String> friendsRequest=friend.friendsRequest;
    friendsRequest.insert(0,userId);

    return await _userCollection
        .doc(friend.id)
        .update({AppUser.friendsRequestsKey: friendsRequest });
  }
  Future<void> deleteFiends(AppUser friend,  String userId) async {
    List<String> friends=friend.friends;
    friends.remove(userId);
   return await _userCollection
        .doc(friend.id)
        .update({AppUser.userFriendsKey: friends });
  }

  Future<void> deleteFiendsRequests(AppUser user,  String friendId) async {
    List<String> friendsRequest=user.friendsRequest;
    friendsRequest.remove(friendId);
    return await _userCollection
        .doc(user.id)
        .update({AppUser.friendsRequestsKey: friendsRequest });
  }

  Future<void> sortFiendsList(AppUser user,  String friendId) async {
    List<String> friends=user.friends;
    int index=friends.indexOf(friendId);
    friends.removeAt(index);
    friends.insert(0,friendId);
    return await _userCollection
        .doc(user.id)
        .update({AppUser.userFriendsKey: friends });
  }

  Future<void>sortFriendsByLastMessage(AppUser currentUser)
  async {
  }


  void showFriendsSearch(bool value){

    showFriend=value;
    notifyListeners();
  }
}