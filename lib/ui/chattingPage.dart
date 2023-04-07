import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/friend_provider.dart';
import 'package:chat_if/providers/message_provider.dart';
import 'package:chat_if/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/message.dart';

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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 13, 40, 82),
          centerTitle: true,
          leadingWidth: 250,
          leading: leadingContainer(context,friend),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined)),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(appUser.imgUrl), fit: BoxFit.fitHeight)),
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
              textFieldBody(context, friend.id, appUser)
            ],
          ),
        ));
  }

  Widget listMessage(BuildContext ctx, AppUser friend, AppUser user) {
    return StreamBuilder<List<Message>>(
        stream: Provider.of<MessageProvider>(ctx, listen: false).getMessageStream(
          receiverId: friend.id,
          senderId: user.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child:  CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var data = snapshot.data;
            data = Provider.of<MessageProvider>(context, listen: false)
                .filteringMessage(
              data!,
              senderId: user.id,
              receiverId: friend.id,
            );
            return ListView.separated(
              reverse: true,
              itemBuilder: (context, index) =>
                  messageBody(data![index], ctx, user.id),
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

  Widget leadingContainer(BuildContext context, AppUser friend)
  {
    return Container(
      width: 80,
      child: Row(
        children: [
          backIcon(context),
          imagePrtBody(friend),
          const SizedBox(width: 10),
          Text(friend.name,style: TextStyle(fontSize: 18),),
        ],
      ),
    );
  }

  Widget messageBody(Message message, BuildContext context, String userid) {
    bool isSender = message.senderId == userid;
    return Row(
      mainAxisAlignment:
          !isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: isSender
                  ? const Color.fromARGB(255, 127, 172, 181)
                  : const Color.fromARGB(255, 13, 40, 82),
              borderRadius: BorderRadius.only(
                bottomLeft: !isSender ? Radius.zero : const Radius.circular(20),
                bottomRight: isSender ? Radius.zero : const Radius.circular(20),
                topLeft: !isSender ? Radius.zero : const Radius.circular(20),
                topRight: isSender ? Radius.zero : const Radius.circular(20),
              )),
          margin: const EdgeInsets.only(right: 5, left: 5),
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
            width: getWidth(message.text),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  !isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5),
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget textFieldBody(BuildContext context, String friendId, AppUser user) {
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
                IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
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

                    Provider.of<FriendProvider>(context,listen: false).sortFiendsList(user, friendId);

                    Provider.of<MessageProvider>(context, listen: false)
                        .addMessage(Message(
                            createdAt: Timestamp.now(),
                            receiverId: friendId,
                            senderId: user.id,
                            text: controller.text));
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
        "https://picsum.photos/seed/${friend.id}/200",
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
    return 60.0 + (text.length.toDouble() * 6);
  }
}
