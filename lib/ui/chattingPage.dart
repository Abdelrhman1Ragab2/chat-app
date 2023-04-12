import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/chat_provider.dart';
import 'package:chat_if/providers/friend_provider.dart';
import 'package:chat_if/providers/message_provider.dart';
import 'package:chat_if/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/message.dart';
import '../providers/ImageProvider.dart';
import '../providers/tab_bar_provider.dart';
import 'camer_ui.dart';

class CattingPage extends StatelessWidget {
  CattingPage({
    Key? key,
  }) : super(key: key);
  static const routeName = "CattingPage";

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    AppUser friend = routeArg[Message.messageReceiver];
    AppUser appUser = routeArg[Message.messageSender];
    final bottomMessage = Provider.of<MessageProvider>(context).bottomMessage;

    return Scaffold(
      appBar: appBarBody(context, friend,appUser),
      body: buildBody(context, friend, appUser),
      bottomSheet:
          Provider.of<TabBarProvider>(context).showBottomSheet
              ? bottomSheetBody(context, bottomMessage):const SizedBox(),

    );
  }

  PreferredSizeWidget? appBarBody(BuildContext context, AppUser friend,AppUser appUser) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 13, 40, 82),
      centerTitle: true,
      leadingWidth: 250,
      leading: leadingContainer(context, friend),
      actions: [
        IconButton(onPressed: () {

        }, icon: const Icon(Icons.phone)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
      ],
    );
  }

  Widget bottomSheetBody(BuildContext context, Message? message) {
    return Container(
        height: 70,
        width: double.maxFinite,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            bottomIcon(context, "Reply", Icons.reply, () {}),
            bottomIcon(context, "Copy", Icons.copy, () {}),
            bottomIcon(context, "Forward", Icons.forward, () {}),
            bottomIcon(context, "Delete", Icons.delete, () {}),
          ],
        ));
  }

  Widget bottomIcon(
      BuildContext context, String text, IconData icon, Function() function) {
    return Expanded(
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            onPressed: () {
              function;
              Provider.of<TabBarProvider>(context, listen: false)
                  .onShowBottomSheet();
            },
          ),
          Text(
            text,
            style: GoogleFonts.alef(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context, AppUser friend, AppUser appUser) {
    return InkWell(
      splashColor: Colors.white,
      onTap: (){
       if(Provider.of<TabBarProvider>(context,listen: false).showBottomSheet)
        Provider.of<TabBarProvider>(context,listen: false).onShowBottomSheet(showSheet: false);
      },
      child: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: listMessage(context, friend, appUser),
              flex: 15,
            ),
            const SizedBox(
              height: 3,
            ),
            textFieldBody(context, friend, appUser)
          ],
        ),
      ),
    );
  }

  Widget listMessage(BuildContext ctx, AppUser friend, AppUser user) {
    return StreamBuilder<List<Message>>(
        stream:
            Provider.of<MessageProvider>(ctx, listen: false).getMessageStream(
          receiverId: friend.id,
          senderId: user.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var data = snapshot.data;
            data = Provider.of<MessageProvider>(context, listen: false)
                .filteringMessage(
              data!,
              senderId: user.id,
              receiverId: friend.id,
            );
            bool? isReadMessage = readMessage(data.first, user);
            return ListView.separated(
              reverse: true,
              itemBuilder: (context, index) => messageBody(
                  data![index], ctx, user.id, friend, isReadMessage),
              separatorBuilder: (context, index) => const SizedBox(
                height: 5,
              ),
              itemCount: data!.length,
            );
          }
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          }

          return const Text("start chat!...");
        });
  }

  Widget leadingContainer(BuildContext context, AppUser friend) {
    return Container(
      width: 80,
      child: Row(
        children: [
          backIcon(context),
          imagePrtBody(friend),
          const SizedBox(width: 10),
          Text(
            friend.name,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget messageBody(Message message, BuildContext context, String userid,
      AppUser friend, bool? isReadMessage) {
    bool isSender = message.senderId == userid;
    return Row(
      mainAxisAlignment:
          !isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onLongPress: () {
            Provider.of<MessageProvider>(context, listen: false)
                .crateBottomMessage(message);
            Provider.of<TabBarProvider>(context, listen: false)
                .onShowBottomSheet();
          },
          child: Container(
            alignment: !isSender ? Alignment.centerLeft : Alignment.centerRight,
            decoration: BoxDecoration(
                color: isSender
                    ? const Color.fromARGB(255, 127, 172, 181)
                    : const Color.fromARGB(255, 13, 40, 82),
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      !isSender ? Radius.zero : const Radius.circular(20),
                  bottomRight:
                      isSender ? Radius.zero : const Radius.circular(20),
                  topLeft: !isSender ? Radius.zero : const Radius.circular(20),
                  topRight: isSender ? Radius.zero : const Radius.circular(20),
                )),
            margin: const EdgeInsets.only(right: 5, left: 5),
            child: Container(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
              width: getWidth(message.text),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: !isSender
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  message.image
                      ? SizedBox(
                          height: 300,
                          width: 250,
                          child: Card(
                            elevation: 0,
                            child: Image.network(
                              message.text,
                              fit: BoxFit.cover,
                              height: 300,
                              width: 250,
                            ),
                          ))
                      : Container(
                          padding:
                              const EdgeInsets.only(top: 5, left: 5, right: 5),
                          child: SelectableText(
                            message.text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSender ? Colors.black : Colors.white,
                            ),
                            //style: TextStyle(color: Colors.white),
                            toolbarOptions: const ToolbarOptions(
                              cut: true,
                              paste: true,
                              copy: true,
                              selectAll: true,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: !isSender
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        (DateFormat.jm().format(message.createdAt.toDate())),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 3),
                      if (isSender)
                        Icon(
                          Icons.done,
                          color: isReadMessage! ? Colors.blue : Colors.white,
                          size: 16,
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textFieldBody(BuildContext context, AppUser friend, AppUser user) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 13, 40, 82), width: 2),
                borderRadius: BorderRadius.circular(25),
                color: Color.fromARGB(255, 127, 172, 181)),
            child: IconButton(
                icon: const Icon(
                  Icons.mic,
                  size: 25,
                  color: Color.fromARGB(255, 13, 40, 82),
                ),
                onPressed: () {}),
          ),
          const SizedBox(width: 8),
          Container(
            width: 290,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 13, 40, 82), width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 127, 172, 181)),
            child: Row(
              children: [
                IconButton(
                    onPressed: () async {

                      Navigator.pushNamed(context, CameraUi.routeName,
                          arguments: {
                            "userId":user.id,
                            "friendId":friend.id,
                          }
                      );


                    },
                    icon: Icon(Icons.camera_alt)),
                Container(
                  width: 170,
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Message",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<FriendProvider>(context, listen: false)
                        .sortFiendsList(user, friend.id);

                    Provider.of<MessageProvider>(context, listen: false)
                        .addMessage(Message(
                      id: "",
                      createdAt: Timestamp.now(),
                      receiverId: friend.id,
                      senderId: user.id,
                      text: controller.text,
                      image: false,
                    ));
                    if (!friend.chats.contains(user.id)) {
                      Provider.of<ChatProvider>(context, listen: false)
                          .updateFiends(friend, user.id);
                    }
                    controller.clear();
                  },
                  icon: Icon(Icons.send),
                  disabledColor: Colors.grey,
                  color: Color.fromARGB(255, 13, 40, 82),
                  enableFeedback: controller.text.isNotEmpty,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imagePrtBody(AppUser friend) {
    return CircleAvatar(
      backgroundImage: NetworkImage(
        friend.imgUrl,
      ),
      radius: 24,
    );
  }

  Widget backIcon(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  double getWidth(String text) {
    if (text.trimRight().length > 40) return 280.0;
    return 75.0 + (text.length.toDouble() * 6);
  }



  bool? readMessage(Message? lastMessage, AppUser currentUser) {
    if (lastMessage == null) return null;
    if (lastMessage.receiverId == currentUser.id) return true;
    return false;
  }


}
