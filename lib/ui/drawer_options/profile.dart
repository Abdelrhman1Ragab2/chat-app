import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/users.dart';
import '../../providers/ImageProvider.dart';

class ProfileOption extends StatelessWidget {
  final AppUser currentUser;

  const ProfileOption({Key? key, required this.currentUser}) : super(key: key);
  static const routeName = "ProfileOption";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
              onTap: () async {
               await editProfileImage(
                context,
               currentUser.id,
              );
              },
        child: const Text("edit image"),
      )),
    );
  }

  Future<void> editProfileImage(BuildContext context, String userId) async {
    final pic = await Provider.of<ImagingProvider>(context).getImageFile();
    if (pic != null) {
      final url = await Provider.of<ImagingProvider>(context, listen: false)
          .uploadImage(userId, pic);
      if (url != null)
        await FirebaseFirestore.instance
            .collection("user")
            .doc(userId)
            .update({AppUser.userImageUrlKey: url});
    }
  }
}
