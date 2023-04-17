import 'dart:math';

import 'package:chat_if/model/message.dart';
import 'package:chat_if/providers/friend_provider.dart';
import 'package:chat_if/providers/message_provider.dart';
import 'package:chat_if/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/users.dart';
import '../providers/animation_provider.dart';

class FriendsList extends StatelessWidget {
  final AppUser currentUser;
  final Message message;

  FriendsList({Key? key, required this.currentUser, required this.message})
      : super(key: key);
  static const routeName = "Friends List";
  TextEditingController searchController = TextEditingController();
  final animation = Tween(begin: 0, end: 2 * pi).transform(3);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme
          .of(context)
          .secondaryHeaderColor,
      elevation: 10,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          searchBody(context),
          const SizedBox(
            height: 20,
          ),
          friendsListBody(context),
        ],
      ),
      shadowColor: Colors.black54,
      title: const Text("Friends"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget friendsListBody(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) =>
            buildItem(context, currentUser.friends[index]),
        separatorBuilder: (context, index) =>
        const SizedBox(
          height: 10,
        ),
        itemCount: currentUser.friends.length,
      ),
    );
  }

  Widget buildItem(BuildContext context, String friendId) {
    return StreamBuilder<AppUser?>(
        stream: Provider.of<UserProvider>(context).getUserStreamById(friendId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AppUser? friend = snapshot.data;
            return itemBody(context, friend!);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget itemBody(BuildContext context, AppUser friend) {
    String selectedId = Provider
        .of<AnimationProvider>(context)
        .selectedId;
    return InkWell(
      onTap: () async {
        Provider.of<AnimationProvider>(context, listen: false).onSelectFriend(
            friend.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 20,
        child: AnimatedContainer(
          width: 100,
          height: selectedId == friend.id ? 160 : 80,
          duration: const Duration(seconds: 2),
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme
                    .of(context)
                    .primaryColor, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imagePrtBody(context, friend.imgUrl),
                      const SizedBox(width: 5),
                      Expanded(child: friendNameBody(context, friend.name))
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                if(selectedId == friend.id)
                  MaterialButton(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      onPressed: () async {
                        await Provider.of<MessageProvider>(context).addMessage(
                            Message(
                                id: "",
                                imgurl: null,
                                text: message.text,
                                senderId: currentUser.id,
                                receiverId: friend.id,
                                createdAt: Timestamp.now(),
                                image: message.image)
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child:const  Text(
                          "Send"
                          ,
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {}, icon: const Icon(Icons.search)),
          hintText: "search by name ",
        ),
      ),
    );
  }

  Widget imagePrtBody(BuildContext context, String imgUrl) {
    return CircleAvatar(
      backgroundImage: NetworkImage(imgUrl),
      radius: 28,
    );
  }

  Widget friendNameBody(BuildContext context, String name) {
    return Text(
      name,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        color: Theme
            .of(context)
            .primaryColor,
      ),
    );
  }
}
