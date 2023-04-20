import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat_if/model/status.dart';
import 'package:chat_if/providers/ImageProvider.dart';
import 'package:chat_if/providers/chat_provider.dart';
import 'package:chat_if/providers/status_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/chats.dart';
import '../model/users.dart';

class CaptionPage extends StatelessWidget {
  CaptionPage({Key? key}) : super(key: key);
  static const routeName = "CaptionPage";

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    XFile pic = routeArg["pic"];
    AppUser user = routeArg["user"];
    AppUser? friend = routeArg["friend"];
    bool forStatus = routeArg["forStatus"];

    return Scaffold(body: buildBody(context, pic, user, friend, forStatus));
  }


  Widget buildBody(BuildContext context, XFile pic, AppUser user,
      AppUser? friend, bool forStatus) {
    return StreamBuilder<List<Chat>>(
      stream: Provider.of<ChatProvider>(context,listen: false).getChatStream(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          Chat? chat=Provider.of<ChatProvider>(context,listen: false).getChatForSpeceficUserAndFriend(
              snapshot.data!,user.id ,friend!.id );
          return Container(
            color: const Color.fromARGB(255, 127, 172, 181),
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: imageBody(pic),
                ),
                Provider.of<ImagingProvider>(context).takingImage?
                const Center(child: CircularProgressIndicator()):
                textFieldBody(context, pic, user, friend, forStatus,chat!)
                ,
              ],
            ),
          );

        }
        return const Center(child: CircularProgressIndicator());
      }
    );
  }

  Widget imageBody(XFile pic) {
    return SizedBox(
      width: double.maxFinite,
      child: Image.file(
        File(pic.path),
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget textFieldBody(BuildContext context, XFile pic, AppUser user,
      AppUser? friend, bool forStatus,Chat chat) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.maxFinite,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: sendIconBody(context, pic, user, friend, forStatus,chat),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white, width: 3)),
          hintText: "caption",
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 13, 40, 82), fontSize: 18),
        ),
      ),
    );
  }

  Widget sendIconBody(
    BuildContext context,
    XFile pic,
    AppUser user,
    AppUser? friend,
    bool forStatus,
      Chat chat
  )
  {
    return IconButton(
      onPressed: () async {
        if (forStatus) {
          await addStory(context, pic, user);
        } else {
          await Provider.of<ImagingProvider>(context, listen: false)
              .addImageMessage(pic, user.id, friend!.id, controller.text,chat.id);
          await Provider.of<ChatProvider>(context, listen: false)
              .updateChat(chat.id,key: Chat.chatLastUpdateKey,value: Timestamp.now());
        }
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.send),
      disabledColor: Colors.grey,
      color: const Color.fromARGB(255, 13, 40, 82),
      enableFeedback: controller.text.isNotEmpty,
    );
  }

  Future<void> addStory(BuildContext context, XFile pic, AppUser user) async {
    Provider.of<ImagingProvider>(context, listen: false).takingImages(true);
    final url = await Provider.of<ImagingProvider>(context, listen: false)
        .uploadImage(user.name, pic);
    if (url != null) {
      Provider.of<StatusProvider>(context, listen: false).crateStatus(Status(
          id: "",
          userId: user.id,
          content: url,
          caption: controller.text,
          isImage: true,
          time: Timestamp.now(),
          friendViews: {},
          friendCanViews: [...user.friends, user.id]));
    }
    Provider.of<ImagingProvider>(context, listen: false).takingImages(false);

  }
}
