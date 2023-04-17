import 'dart:math';

import 'package:camera/camera.dart';
import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/status_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../model/status.dart';
import '../../providers/ImageProvider.dart';
import '../../providers/user_provider.dart';
import '../../widget/story_page.dart';

class StatusPage extends StatelessWidget {
  final AppUser currentUser;

  const StatusPage({Key? key, required this.currentUser}) : super(key: key);
  static const routeName = "StatusPage";

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<StatusProvider>(context, listen: false)
            .getStatusStream(currentUser.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            List<Status> status = snapshot.data!;
            return dividedBody(context, status);
          }
          return const SizedBox();
        });
  }

  Widget dividedBody(BuildContext context, List<Status> status) {
    return Column(
      children: [
        myStatus(context, status),
        separatedContainer(context),
        Expanded(child: statusFriendsBody(context, status))
      ],
    );
  }

  Widget separatedContainer(BuildContext context) {

    return Container(
      width: double.infinity,
      height: 30,
      color: Theme.of(context).primaryColor,
      child: const Padding(
        padding: EdgeInsets.all(5),
        child: Center(
            child: Text(
          "Friends Status",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        )),
      ),
    );
  }

  Widget myStatus(BuildContext context, List<Status> status) {
    List<Status> myStatus = getMyStatus(status, currentUser.id);
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, DelayedPage.routeName, arguments: {
          "status": myStatus,
          "appUser": currentUser,
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 10, 2, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myImage(context, myStatus),
            const SizedBox(
              width: 5,
            ),
            nameBody("My status")
          ],
        ),
      ),
    );
  }

  Widget myImage(BuildContext context, List<Status> myStatus) {
    return DottedBorder(
        strokeWidth: 3,
        color: Colors.green.shade600,
        dashPattern:
            myStatus.length <= 1 ? [180, 0] : [(180) / myStatus.length, 5],
        borderType: BorderType.Circle,
        radius: const Radius.circular(32),
        padding: const EdgeInsets.all(6),
        child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage(myStatus.isEmpty
                        ? currentUser.imgUrl
                        : myStatus[0].content),
                    fit: BoxFit.fill,
                  )),
              child: const SizedBox()),
        );
  }

  Widget statusFriendsBody(BuildContext ctx, List<Status> status) {
    return ListView.separated(
      itemBuilder: (context, index) =>
          buildItem(ctx, status, currentUser.friends[index]),
      separatorBuilder: (context, index) => const SizedBox(
        height: 5,
      ),
      itemCount: currentUser.friends
          .length, // edit after add remove chat to currentUser.chats.length
    );
  }

  Widget buildItem(BuildContext context, List<Status> status, String friendId) {
    List<Status> myStatus = getMyStatus(status, friendId);
    return myStatus.isEmpty
        ? const SizedBox()
        : StreamBuilder(
            stream:
                Provider.of<UserProvider>(context).getUserStreamById(friendId),
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
                        Navigator.pushNamed(context, DelayedPage.routeName,
                            arguments: {
                              "status": myStatus,
                              "appUser": friend,
                            });
                      },
                      child: bodyItem(context, friend, myStatus)),
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

  Widget bodyItem(BuildContext context, AppUser friend, List<Status> status) {
    return Row(
      children: [
        imagePrtBody(status, context),
        const SizedBox(width: 5),
        nameBody(friend.name),
        datePartBody(status[0])
      ],
    );
  }

  Widget imagePrtBody(List<Status> status, BuildContext context) {
    return DottedBorder(
      strokeWidth: 3,
      color: Colors.green.shade600,
      dashPattern: status.length <= 1 ? [180, 0] : [(180) / status.length, 5],
      borderType: BorderType.Circle,
      radius: const Radius.circular(32),
      padding: const EdgeInsets.all(6),
      child: Container(
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            status[0].content,
          ),
          radius: 30,
        ),
      ),
    );
  }

  Widget nameBody(String name) {
    return Container(
      width: 200,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget datePartBody(Status status) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text((DateFormat.jm().format(status.time.toDate()))),
    );
  }

  List<Status> getMyStatus(List<Status> status, String userId) {
    List<Status> myStatus = [];
    for (var element in status) {
      if (element.userId == userId) {
        myStatus.add(element);
      }
    }
    return myStatus;
  }
}
