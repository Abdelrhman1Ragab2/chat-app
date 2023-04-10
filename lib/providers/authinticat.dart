import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import '../model/users.dart';

class AuthProvider with ChangeNotifier {
  final _userCollection = FirebaseFirestore.instance
      .collection("user")
      .withConverter(
          fromFirestore: AppUser.fromFirebase, toFirestore: AppUser.toFirebase);

  final _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  String? email;
  String? pass;
  String? userName;
  num? phone;
  bool isLogin = false;
  bool isError=false;
  String?errorMessage="";
  bool isLoading=false;

  void onSubmit() async{
    bool isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();

      try{
        isLoading=true;
        isLogin ?
        await signIn(email!, pass!) :
        await signUp(email!, pass!);
        isLoading=false;

      }
      on FirebaseException catch(error){
        errorMessage= error.code;
        isLoading=false;
        isError=true;
      }
    }

    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await addFirebaseUser(userCred.user!);
    notifyListeners();
  }

  Future<void> addFirebaseUser(User firebaseUser) async {
    String userId = firebaseUser.uid;
    final newUser = AppUser(
      id: userId,
      email: firebaseUser.email!,
      imgUrl: "https://picsum.photos/seed/$userId/200",
      name: userName!,
      phone: "01550886075",
      friends: [],
    );
    await _addNewUser(newUser);
  }

  Future<void> _addNewUser(AppUser user) async {
    await _userCollection.doc(user.id).set(user);
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  void logOrSign() {
    isLogin = !isLogin;
    notifyListeners();
  }



}


