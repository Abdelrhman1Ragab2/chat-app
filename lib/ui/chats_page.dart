
import 'package:chat_if/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/message.dart';
import '../model/users.dart';
import '../providers/message_provider.dart';
import 'chattingPage.dart';

class ChatsPage extends StatelessWidget {
  final AppUser currentUser;

  const ChatsPage({Key? key, required this.currentUser}) : super(key: key);
  static const routeName = "ChatsPage";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(child: chatsBody(context)),
      ],
    ));
  }

  Widget chatsBody(BuildContext ctx) {
    return Container(
      // height: 600,
      child: ListView.separated(
        itemBuilder: (context, index) =>
            buildItem(ctx, currentUser.friends[index]),
        separatorBuilder: (context, index) => const SizedBox(
          height: 5,
        ),
        itemCount: currentUser.friends.length,
      ),
    );
  }

  Widget buildItem(
      BuildContext context, String friendsId) {
    return StreamBuilder(
        stream: Provider.of<UserProvider>(context).getUserStreamById(friendsId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            AppUser friend = snapshot.data!;
            return Container(
              height: 80,
              padding: const EdgeInsets.all(3),
              child: InkWell(
                  onTap: () async {
                    Navigator.pushNamed(context, CattingPage.routeName,
                        arguments: {
                          Message.messageSender: currentUser,
                          Message.messageReceiver: friend
                        });
                  },
                  child: bodyItem(context,friend)),
            );
          }

          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const SizedBox();
        });
  }

  Widget bodyItem(BuildContext context,AppUser friend) {
      return StreamBuilder<List<Message>>(
        stream: Provider.of<MessageProvider>(context, listen: false).getMessageStream(
          receiverId: friend.id,
          senderId: currentUser.id,
        ),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: const CircularProgressIndicator());
          // }
          if (snapshot.hasData) {
            var data = snapshot.data;
            data = Provider.of<MessageProvider>(context, listen: false)
                .filteringMessage(
              data!,
              senderId: currentUser.id,
              receiverId: friend.id,
            );
            Message? lastMessage=data.first;
            bool useTime= dayOrTime(lastMessage);

            return Row(
              children: [
                imagePrtBody(friend),
                const SizedBox(width: 5),
                nameAndLastMessageBody(friend,lastMessage),
                datePartBody(useTime,lastMessage)
              ],
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
  Widget imagePrtBody(AppUser friend)
  {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            "https://picsum.photos/seed/${friend.id}/200",
          ),
          radius: 28,
        ),
        Container(
          height: 13,
          width: 13,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(8)),
        ),
      ],
    );
  }

  Widget nameAndLastMessageBody(AppUser friend ,Message lastMessage)
  {
    return Container(width: 225,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            friend.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height:8),
          SizedBox(width: 225, child: Text(lastMessage.text,style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,)),
        ],
      ),
    );
  }

  Widget datePartBody(bool useTime,Message lastMessage)
  {
    return  Container(
      padding: const EdgeInsets.only(top: 10),
      alignment: Alignment.topLeft,
      child: Text(useTime?
      (DateFormat.jm().format(lastMessage.createdAt.toDate())):
      (DateFormat.yMd().format(lastMessage.createdAt.toDate()))


      ),
    );
  }

  bool dayOrTime(Message lastMessage){
    if(lastMessage.createdAt.toDate().day==DateTime.now().day
        &&lastMessage.createdAt.toDate().month==DateTime.now().month
        &&lastMessage.createdAt.toDate().year==DateTime.now().year)
    {return true;}
    return false;
  }

}
