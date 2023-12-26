import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/status.dart';
import '../../model/users.dart';
import '../../providers/user_provider.dart';

class ViewersBottomSheet extends StatelessWidget {
  final AppUser currentUser;
  final Status status;

  const ViewersBottomSheet(
      {Key? key, required this.status, required this.currentUser})
      : super(key: key);
  static const routeName = "ViewBottomSheet";

  @override
  Widget build(BuildContext context) {
    return bottomSheetBody(context, status);
  }

  Widget bottomSheetBody(BuildContext context, Status status) {
    return Container(
        color: Theme.of(context).primaryColor,
        width: double.maxFinite,
        height: gitHeight(status.friendViews.keys.toList().length),
        //color: Colors.black54,
        child: status.friendViews.isEmpty
            ? const Center(
                child: Text(
                  "No Views",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) =>
                    buildItem(context, status.friendViews.keys.toList()[index]),
                separatorBuilder: (_, __) => const SizedBox(),
                itemCount: status.friendViews.length));
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 20,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imagePrtBody(context, friend.imgUrl),
                const SizedBox(width: 5),
                Expanded(child: friendNameBody(context, friend.name)),
                dateForMyStatus(status)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imagePrtBody(BuildContext context, String imgUrl) {
    return CircleAvatar(
      backgroundImage: NetworkImage(imgUrl),
      radius: 22,
    );
  }

  Widget friendNameBody(BuildContext context, String name) {
    return Text(
      name,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget dateForMyStatus(Status status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(status.time.toDate().day == DateTime.now().day
            ? "today"
            : "yesterday"),
        const SizedBox(
          width: 5,
        ),
        Text((DateFormat.jm().format(status.time.toDate()))),
      ],
    );
  }

  double gitHeight(int len) {
    if (len > 4) {
      return 250.0;
    } else if (len < 2) {
      return 70;
    }
    return 70 + len * 70;
  }
}
