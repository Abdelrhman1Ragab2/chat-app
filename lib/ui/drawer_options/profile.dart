import 'package:chat_if/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/users.dart';
import '../../providers/ImageProvider.dart';

class ProfileOption extends StatelessWidget {
  final AppUser currentUser;

  ProfileOption({Key? key, required this.currentUser}) : super(key: key);
  static const routeName = "ProfileOption";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          imageBody(context),
          const SizedBox(
            height: 10,
          ),
          detailsBody(context),
          const SizedBox(
            height: 15,
          ),
          friendsInfoBody(),
        ],
      ),
    ));
  }

  Widget imageBody(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
          padding: const EdgeInsets.all(2),
          width: double.maxFinite,
          height: 400,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(currentUser.imgUrl), fit: BoxFit.cover)),
          child: const SizedBox()),
    );
  }

  Widget detailsBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            editBody(context, "Name", AppUser.usernameKey, currentUser.name),
            editBody(context, "Bio", AppUser.userBiolKey, currentUser.bio!),
            editBody(context, "Phone", AppUser.userPhoneNumberKey,
                currentUser.phone),
          ],
        ),
      ),
    );
  }

  Widget editBody(BuildContext context, String title, var key, String oldText) {
    return ListTile(
      onTap: () async {
        controller.text = oldText;
        await editInfo(context, key);
      },
      title: Text(title),
      trailing: const Icon(Icons.edit),
    );
  }

  Widget friendsInfoBody() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            friendInfoItem(
                "Friend", Icons.person, currentUser.friends.length, 3),
            friendInfoItem("Chat", Icons.chat, currentUser.chats.length, 3),
            friendInfoItem("Friend requests", Icons.request_page,
                currentUser.friends.length, 4),
          ],
        ),
      ),
    );
  }

  Widget friendInfoItem(String title, IconData icon, int length, int flex) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(length.toString()),
            const SizedBox(
              height: 5,
            ),
            Text(title)
          ],
        ),
      ),
    );
  }

  Future<void> editInfo(BuildContext context, var key) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Card(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await Provider.of<UserProvider>(context, listen: false)
                            .updateUserInfo(currentUser.id,
                                key: key, value: controller.text);
                        Navigator.of(context).pop();
                      },
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> editProfileImage(BuildContext context, String userId) async {
    final pic = await Provider.of<ImagingProvider>(context, listen: false)
        .getImageFile();
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
