import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/message.dart';
import '../model/users.dart';
import 'message_provider.dart';
class ImagingProvider with ChangeNotifier{


  final _imagesRef = FirebaseStorage.instance.ref("images");
  final _user = FirebaseAuth.instance.currentUser;
   bool takingImage=false;


  void takingImages(bool taking)
  {
    takingImage=taking;
    notifyListeners();
  }

  Future<String?> uploadImage(String folderName,XFile file) async {
    return await _uploadImage(folderName, file);
  }

  Future<String?> _uploadImage(String folderName, XFile file) async {
    final generatedFileName = await _generateFileName();
    if (generatedFileName == null) {
      return null;
    }
    final uploadResult = await _imagesRef
        .child(folderName)
        .child(generatedFileName)
        .putData(await file.readAsBytes());
    return await uploadResult.ref.getDownloadURL();
  }

  Future<String?> _generateFileName() async {

    if (_user == null) {
      return null;
    }
    return DateTime.now().millisecondsSinceEpoch.toString() + _user!.uid;

  }

  Future<XFile?> getImageFile() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 50);

    if (pickedFile == null) {
      return null;
    }
    return pickedFile;
  }


  Future<void> addImageMessage(XFile pic,String userId, String friendId,String?caption) async {
    takingImages(true);
    final url = await uploadImage(userId, pic);
    if (url != null) {
      await FirebaseFirestore.instance
          .collection("message")
          .withConverter(
          fromFirestore: Message.fromFirebase, toFirestore: Message.toFirebase)
          .doc()
          .set(
          Message(
              id: "",
              text: caption,
              imgurl: url,
              senderId: userId,
              receiverId: friendId,
              createdAt: Timestamp.now(),
              image: true));

    }
    takingImages(false);
  }
}