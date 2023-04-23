import 'package:chat_if/providers/status_provider.dart';
import 'package:chat_if/widget/viewers_status_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

import '../model/chats.dart';
import '../model/message.dart';
import '../model/status.dart';
import '../model/users.dart';
import '../providers/chat_provider.dart';
import '../providers/message_provider.dart';

class DelayedPage extends StatefulWidget {
  final AppUser currentUser;

  DelayedPage({Key? key, required this.currentUser}) : super(key: key);
  static const routeName = "DelayedPage";

  @override
  State<DelayedPage> createState() => _DelayedPageState();
}

class _DelayedPageState extends State<DelayedPage>
    with SingleTickerProviderStateMixin {
  final storyController = StoryController();
  TextEditingController controller = TextEditingController();
  bool editVisable = false;

  @override
  void dispose() {
    storyController.dispose();
    storyItems.clear();
    super.dispose();
  }

  int index = 0;
  int count = 0;
  int lastIndex=0;

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<Status> status = routeArg["status"];
    AppUser appUser = routeArg[
        "appUser"]; // if i tap on my status appUser==currentUser else appUser==friendUser
    if (count == 0) {
      fullList(status, widget.currentUser.id);
    }
    return Scaffold(
      appBar: AppBar(
        leading: leadingContainer(context, appUser),
        leadingWidth: 250,
        actions: [
          Visibility(
              visible: widget.currentUser.id == appUser.id,
              child: viewIcon(status[index]))
        ],
      ),
      body: storyBody(context, status[index],status.length,widget.currentUser,appUser.id),
    );
  }

  Widget leadingContainer(BuildContext context, AppUser appUser) {
    return Row(
      children: [
        backIcon(context),
        imagePrtBody(appUser),
        const SizedBox(width: 10),
        friendName(appUser)
      ],
    );
  }

  Widget backIcon(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  Widget friendName(AppUser friend) {
    return SizedBox(
      width: 130,
      child: Text(
        friend.name,
        style: const TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis,
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

  Widget storyBody(
    BuildContext context,
    Status status,int len,
      AppUser user,
      String friendId,
  ) {
    return StreamBuilder<List<Chat>>(
        stream: Provider.of<ChatProvider>(context,listen: false).getChatStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(!user.chats.contains(friendId))
              {
                  Provider.of<ChatProvider>(context,listen: false).crateChat(Chat(
                  id: "",
                  lastUpdate: Timestamp.now(),
                  userAId: friendId,
                  userBId: user.id,

                ));}
            Chat? chat=Provider.of<ChatProvider>(context,listen: false).getChatForSpeceficUserAndFriend(
                snapshot.data!,user.id ,friendId );

                     return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: double.maxFinite,
                  child: StoryView(
                    onComplete: () {
                      storyItems.clear();
                      Navigator.pop(context);
                    },

                    onStoryShow: (story) {

                      if (count != 0 && index+1<len) {
                        setState(() {
                          {
                            index++;
                          }

                        });
                      }
                      if(count.isEven &&index!=0)
                      {
                        setState(() {
                          index--;
                        });
                      }
                      count ++;
                      print("    $count     $index");

                    },
                    progressPosition: ProgressPosition.top,
                    storyItems: storyItems,
                    controller: storyController,
                  ),
                ),
                widget.currentUser.id == status.userId
                    ? const SizedBox()
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          editVisable
                              ? storyController.play()
                              : storyController.pause();
                          setState(() {
                            editVisable = !editVisable;
                            count = 1;
                          });
                        },
                        icon: Icon(
                          editVisable
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: Colors.white,
                          size: 36,
                        )),
                    replyBody(context, status,chat! )
                  ],
                )
              ],
            );


          }
          return const Center(child: CircularProgressIndicator());
        }
    );
  }

  void fullList(List<Status> status, String userId) {
    for (var element in status) {
      if (!element.friendViews.containsKey(userId) &&
          element.userId != widget.currentUser.id) {
        Provider.of<StatusProvider>(context, listen: false)
            .showStatus(element, widget.currentUser.id);
      }
      storyListed(element);
    }
  }

  List<StoryItem> storyListed(Status status) {
    setState(() {
      storyItems.add(StoryItem.pageImage(
        imageFit: BoxFit.contain,
          controller: storyController,
          url: status.content,
          shown: true,
          caption: status.caption,
          duration: const Duration(seconds: 5)));
    });

    return storyItems;
  }

  Widget viewIcon(Status status) {
    return IconButton(
        onPressed: () async {
          storyController.pause();
          await showModalBottomSheet(
            context: context,
            elevation: 10,
            builder: (BuildContext context) {
              return ViewersBottomSheet(
                currentUser: widget.currentUser,
                status: status,
              );
            },
          );
          storyController.play();
        },
        icon: const Icon(
          Icons.remove_red_eye,
          color: Colors.white,
        ));
  }

  Widget replyBody(BuildContext context, Status status,Chat chat) {
    return Visibility(
      visible: editVisable,
      child: SizedBox(
        width: double.maxFinite,
        height: 70,
        //color: Colors.black54,
        child: textFieldBody(context, status.userId, status.content,chat),
      ),
    );
  }

  Widget textFieldBody(BuildContext context, String friendId, String url,Chat chat) {
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        width: double.maxFinite,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: sendIconBody(context, friendId, url,chat),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white, width: 3)),
            hintText: "reply..",
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 13, 40, 82), fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget sendIconBody(BuildContext context, String friendId, String url,Chat chat) {
    return IconButton(
      onPressed: () async {
        await Provider.of<MessageProvider>(context, listen: false).addMessage(
            Message(
                id: "",
                text: controller.text,
                chatId: chat.id,
                imgUrl: url,
                senderId: widget.currentUser.id,
                receiverId: friendId,
                createdAt: Timestamp.now(),
                image: true));
        await Provider.of<ChatProvider>(context, listen: false)
            .updateChat(chat.id,key: Chat.chatLastUpdateKey,value: Timestamp.now());
        setState(() {
          editVisable = !editVisable;
        });
        storyController.play();
      },
      icon: const Icon(Icons.send),
      disabledColor: Colors.grey,
      color: const Color.fromARGB(255, 13, 40, 82),
      enableFeedback: controller.text.isNotEmpty,
    );
  }

  List<StoryItem> storyItems = [];
}
