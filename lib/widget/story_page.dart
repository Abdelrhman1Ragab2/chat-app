import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

import '../model/status.dart';
import '../model/users.dart';

class DelayedPage extends StatefulWidget {
  DelayedPage({Key? key}) : super(key: key);
  static const routeName = "DelayedPage";

  @override
  State<DelayedPage> createState() => _DelayedPageState();
}

class _DelayedPageState extends State<DelayedPage> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    storyItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<Status> status = routeArg["status"];
    fullList(status);
    AppUser appUser = routeArg["appUser"];
    return Scaffold(
      appBar: AppBar(
        leading: leadingContainer(context, appUser),
        leadingWidth: 250,
      ),
      body: storyBody(),
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



  Widget storyBody() {
    return SizedBox(
      height: double.maxFinite,
      child: StoryView(
        onComplete: (){
          storyItems.clear();
          Navigator.pop(context);
        },
        storyItems:storyItems,
        controller: storyController,
      ),
    );
  }

  void fullList(List<Status> status)
  {
    for (var element in status) {
      storyListed(element);
    }
  }
  List<StoryItem> storyListed(Status status)
  {
    setState(() {
      storyItems.add(StoryItem.pageImage(
        imageFit: BoxFit.contain,
          caption:status.caption,
          url: status.content,
          controller: storyController,
          duration: const Duration(seconds: 5)));
    });

    return storyItems;

  }
  List<StoryItem> storyItems=[];

}
