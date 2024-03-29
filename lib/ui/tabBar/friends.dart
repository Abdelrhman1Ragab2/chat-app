import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/chats.dart';
import '../../providers/friend_provider.dart';
import '../../providers/user_provider.dart';

class Friends extends StatelessWidget {
  final AppUser currentUser;

  const Friends({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentUser.friends.isEmpty
        ?  Padding(
          padding:  const EdgeInsets.all(20.0),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/emptychat.png"),
                   const SizedBox(height: 30,),
                   const Text(
                      "There are no friends .. Add new friends to be able\n to start conversations and participate with them",
                   style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
            ],
          ),
        )
        : Column(
            children: [
              listBodyFriends(),
              const SizedBox(
                height: 50,
              ),
            ],
          );
  }

  Widget listBodyFriends() {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) =>
              friendDetailsBody(context, currentUser.friends[index]),
          separatorBuilder: (context, _) => const SizedBox(
                height: 5,
              ),
          itemCount: currentUser.friends.length),
    );
  }

  Widget friendDetailsBody(BuildContext context, String friendId) {
    return StreamBuilder<AppUser?>(
        stream: Provider.of<UserProvider>(context, listen: false)
            .getUserStreamById(friendId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AppUser newFriend = snapshot.data!;
            return _profileDetails(context, newFriend);
          }
          if (snapshot.hasError) {
            return const SizedBox();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _profileDetails(BuildContext context, AppUser friend) {
    bool isFriend = currentUser.friends.contains(friend.id);
    return Container(
      width: 250,
      child: Card(
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                imageBody(friend.imgUrl),
                const SizedBox(height: 16),
                nameBody(friend.name),
                const SizedBox(
                  height: 8,
                ),
                bioBody(friend.bio),
                const SizedBox(
                  height: 8,
                ),
                emailBody(friend.email),
                const SizedBox(
                  height: 8,
                ),
                actionBody(context, friend)
              ],
            ),
          )),
    );
  }

  Widget imageBody(String imgUrl) {
    return CircleAvatar(
      radius: 56,
      backgroundImage: NetworkImage(imgUrl),
    );
  }

  Widget nameBody(String name) {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget bioBody(String? bio) {
    return Text(
      bio ?? "",
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color.fromARGB(255, 61, 128, 5),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget emailBody(String email) {
    return Text(
      email,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget actionBody(BuildContext context, AppUser friend) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Provider.of<FriendProvider>(context, listen: false)
                .deleteFiends(currentUser, friend.id);
          },
          child: Card(
            elevation: 15,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Delete Friend",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.delete_sharp,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        currentUser.chats.contains(friend.id)
            ? const SizedBox()
            : InkWell(
                onTap: () async {
                  await startChat(context, friend);
                },
                child: Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Start chat",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.chat_sharp,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Future<void> startChat(BuildContext context, AppUser friend) async {
    if (friend.chats.contains(currentUser.id)) {
      await Provider.of<ChatProvider>(context, listen: false)
          .updateFiends(currentUser, friend.id);
    } // my friend crate chat no need to crate a new chat
    else {
      await Provider.of<ChatProvider>(context, listen: false).crateChat(Chat(

          id: "",
          users: [currentUser.id,friend.id],
          lastUpdate: Timestamp.now(),
      ),currentUser.id,friend.id
      );

      await Provider.of<ChatProvider>(context, listen: false)
          .updateFiends(currentUser, friend.id);
    }
  }
}
