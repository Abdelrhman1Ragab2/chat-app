import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/chat_provider.dart';
import 'package:chat_if/providers/message_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/camera/camer_ui.dart';
import '../core/widget/message_bottom_sheet.dart';
import '../model/chats.dart';
import '../model/message.dart';
import '../providers/tab_bar_provider.dart';

class CattingPage extends StatefulWidget {
  const CattingPage({
    Key? key,
  }) : super(key: key);
  static const routeName = "CattingPage";

  @override
  State<CattingPage> createState() => _CattingPageState();
}

class _CattingPageState extends State<CattingPage> {
  TextEditingController controller = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final routeArg =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    AppUser friend = routeArg[Message.messageReceiver];
    AppUser appUser = routeArg[Message.messageSender];
    Chat chat = routeArg["chat"];

    return Scaffold(
      appBar: appBarBody(context, friend, appUser),
      body: buildBody(context, friend, appUser, chat),
    );
  }

  PreferredSizeWidget? appBarBody(BuildContext context, AppUser friend,
      AppUser appUser) {
    return AppBar(
      centerTitle: true,
      leadingWidth: 250,
      leading: leadingContainer(context, friend),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
      ],
    );
  }

  Widget buildBody(BuildContext context, AppUser friend, AppUser appUser,
      Chat chat) {
    return InkWell(
      onTap: () {
        if (Provider
            .of<TabBarProvider>(context, listen: false)
            .showBottomSheet) {
          Provider.of<TabBarProvider>(context, listen: false)
              .onShowBottomSheet(showSheet: false);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/chatting.png"))),
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 11,
              child: listMessage(context, friend, appUser,chat),
            ),
            const SizedBox(
              height: 3,
            ),
            bottomPartBody(context, friend, appUser, chat)
          ],
        ),
      ),
    );
  }

  Widget listMessage(BuildContext ctx, AppUser friend, AppUser user,Chat chat) {
    return StreamBuilder<List<Message>>(
        stream:
        Provider.of<MessageProvider>(ctx, listen: false).getMessageStream(
          chat.id
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var data = snapshot.data!;

            if (data.isEmpty) {
              return const SizedBox();
            }
            bool? isReadMessage = readMessage(data.first, user);
            return ListView.separated(
              reverse: true,
              itemBuilder: (context, index) =>
                  messageBody(data[index], ctx, user, friend, isReadMessage,chat),
              separatorBuilder: (context, index) =>
              const SizedBox(
                height: 5,
              ),
              itemCount: data.length,
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
    return Row(
      children: [
        backIcon(context),
        imagePrtBody(friend),
        const SizedBox(width: 10),
        SizedBox(
          width: 130,
          child: Text(
            friend.name,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget messageBody(Message message, BuildContext context, AppUser user,
      AppUser friend, bool? isReadMessage,Chat chat) {
    bool isSender = message.senderId == user.id;
    return Row(
      mainAxisAlignment:
      !isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              elevation: 10,
              builder: (BuildContext context) {
                return MessageBottomSheet(
                  chat: chat,
                  currentUser: user,
                  message: message,
                );
              },
            );
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
            margin: const EdgeInsets.only(right: 2, left: 2),
            child: Container(
              padding:
              const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
              width: message.image ? 280 : getWidth(message.text!),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: !isSender
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  messageContent(message, isSender),
                  const SizedBox(
                    height: 3,
                  ),
                  messageTimeBody(message, isSender, isReadMessage, friend)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget messageContent(Message message, bool isSender) {
    return message.image
        ? Column(
      crossAxisAlignment: isSender
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        SizedBox(
            height: 300,
            width: 265,
            child: Card(
              elevation: 0,
              child: Image.network(
                message.imgUrl!,
                fit: BoxFit.cover,

              ),
            )),
        const SizedBox(height: 10),
        Text(message.text == null ? "" : message.text!,
          style: TextStyle(color: isSender ? Colors.black : Colors.white,
              fontSize: 16
          ),)
      ],
    )
        : Container(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: SelectableText(
        message.text!,
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
    );
  }

  Widget messageTimeBody(Message message, bool isSender, bool? isReadMessage,
      AppUser friend) {
    return Row(
      mainAxisAlignment:
      !isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          (DateFormat.jm().format(message.createdAt.toDate())),
          textAlign: TextAlign.end,
          style: const TextStyle(
              fontSize: 12, color: Colors.white60, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 3),
        if (isSender)
          const Icon(
            Icons.done,
            color: Colors.white,
            size: 16,
          )
      ],
    );
  }

  Widget bottomPartBody(BuildContext context, AppUser friend, AppUser user,
      Chat chat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        recordBody(),
        const SizedBox(width: 8),
        inputBody(context, user, friend, chat),
      ],
    );
  }

  Widget recordBody() {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 13, 40, 82), width: 2),
          borderRadius: BorderRadius.circular(28),
          color: const Color.fromARGB(255, 127, 172, 181)),
      child: IconButton(
          icon: const Icon(
            Icons.mic,
            size: 25,
            color: Color.fromARGB(255, 13, 40, 82),
          ),
          onPressed: () {}),
    );
  }

  Widget inputBody(BuildContext context, AppUser user, AppUser friend,
      Chat chat) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 13, 40, 82), width: 2),
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 127, 172, 181)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (Provider
                .of<MessageProvider>(context)
                .isReply)
              replyMessageBody(context),
            Row(
              children: [
                cameraIconBody(context, user, friend),
                textFieldBody(),
                sendIconBody(context, user, friend, chat),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget replyMessageBody(BuildContext context) {
    return Stack(alignment: Alignment.topRight, children: [
      Container(
        width: 290,
        height: 48,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 40, 70, 122),
        ),
        child: Center(
            child: SizedBox(
              width: 280,
              child: Text(
                Provider
                    .of<MessageProvider>(context)
                    .replyMessage!
                    .text!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            )),
      ),
      IconButton(
          onPressed: () {
            Provider.of<MessageProvider>(context, listen: false)
                .closeReplyMessage();
          },
          icon: const Icon(
            Icons.close,
            size: 18,
            color: Colors.white,
          ))
    ]);
  }

  Widget cameraIconBody(BuildContext context, AppUser user, AppUser friend) {
    return IconButton(
        onPressed: () async {
          Navigator.pushNamed(context, OpenCamera.routeName, arguments: {
            "user": user,
            "friend": friend,
            "forStatus": false,

          });
        },
        icon: const Icon(Icons.camera_alt));
  }

  Widget sendIconBody(BuildContext context, AppUser user, AppUser friend,
      Chat chat) {
    return IconButton(
      onPressed: () async {
        print("user.id out ${user.id}");


        if(controller.text.isNotEmpty)
          {
            await Provider.of<MessageProvider>(context, listen: false).addMessage(
                Message(
                  id:"",
                  imgUrl: null,
                  chatId: chat.id,
                  createdAt: Timestamp.now(),
                  receiverId: friend.id,
                  senderId: user.id,
                  text: controller.text,
                  image: false,
                ));

            print("user.id in ${user.id}");

            if (!friend.chats.contains(user.id)) {
              Provider.of<ChatProvider>(context, listen: false)
                  .updateFiends(friend, user.id);
            }
            print("user.id  in${user.id}");
            await Provider.of<ChatProvider>(context, listen: false).updateChat(
                chat.id
                , key: Chat.chatLastUpdateKey,
                value:Timestamp.now());

            controller.clear();
          }


      },
      icon: const Icon(Icons.send),
      disabledColor: Colors.grey,
      color:  const Color.fromARGB(255, 13, 40, 82),
      enableFeedback: controller.text.isNotEmpty,
    );
  }

  Widget textFieldBody() {
    return SizedBox(
      width: 170,
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "Message",
        ),
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
    if (text
        .trimRight()
        .length > 40) return 280.0;
    return 75.0 + (text.length.toDouble() * 6);
  }

  bool? readMessage(Message? lastMessage, AppUser currentUser) {
    if (lastMessage == null) return null;
    if (lastMessage.receiverId == currentUser.id) return true;
    return false;
  }
}
