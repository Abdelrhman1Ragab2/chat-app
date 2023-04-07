import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../model/users.dart';

class UserProvider with ChangeNotifier {
  final _userCollection = FirebaseFirestore.instance
      .collection("user")
      .withConverter(
          fromFirestore: AppUser.fromFirebase, toFirestore: AppUser.toFirebase);


  AppUser? friend;

  Future<AppUser> getUserById(String id) async {
    return (await _userCollection.doc(id).get()).data()!;
  }

  Stream<AppUser?> getCurrentUserStream() {
    return initApp()
        .asStream()
        .delay(const Duration(seconds: 2))
        .flatMap((app) {
      return getCurrentUserStreams();
    });
  }

  Future<FirebaseApp> initApp() async {
    return await Firebase.initializeApp();
  }

  Stream<AppUser?> getUserStreamById(String id) {
    return _userCollection.doc(id).snapshots().map((ds) => ds.data());
  }

  Stream<AppUser?> getCurrentUserStreams() {
    return FirebaseAuth.instance.authStateChanges().flatMap((user) {
      if (user == null) {
        return Stream.value(null);
      }

      return getUserStreamById(user.uid);
    });
  }

  Stream<AppUser> getFriendsStream(String email) {

    Query<AppUser> query=_userCollection.where(AppUser.userEmailKey,isEqualTo: email );

    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).single);
  }






}
