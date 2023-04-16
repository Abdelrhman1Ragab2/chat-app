import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/status.dart';

class StatusProvider with ChangeNotifier {
  final _statusCollection = FirebaseFirestore.instance
      .collection("status")
      .withConverter(
          fromFirestore: Status.fromFirebase, toFirestore: Status.toFirebase);



  Future<void> crateStatus(Status status) async {
    await _statusCollection.doc().set(status);
  }

  Future<void> deleteStatus(String statusId) async {
    await _statusCollection.doc(statusId).delete();
  }

  Future<void> showStatus(Status status, String userId) async {
    status.friendViews.add(userId);
    List<String> newFriendsView = status.friendViews;
    await _statusCollection
        .doc(status.id)
        .update({Status.friendViewsKey: newFriendsView});
  }

  Stream<List<Status>> getStatusStream(String userId) {
    Query<Status> query=_statusCollection.orderBy(Status.timeKey, descending: true);
    return query.where(Status.friendCanViewsKey, arrayContains: userId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
  Stream<List<Status>> getStatusStreamForFriend(String friendId) {
    Query<Status> query=_statusCollection.orderBy(Status.timeKey, descending: true);
    return query.where(Status.userIdKey, isEqualTo: friendId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}
