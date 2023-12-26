import 'package:chat_if/model/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/friend_provider.dart';
import '../../providers/user_provider.dart';

class FriendsRequests extends StatelessWidget {
  final AppUser currentUser;

  const FriendsRequests({Key? key, required this.currentUser})
      : super(key: key);
  static const routeName = "Friends Requests";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            routeName,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(children: [listBodyRequests()]));
  }

  Widget listBodyRequests() {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) =>
              friendDetailsBody(context, currentUser.friendsRequest[index]),
          separatorBuilder: (context, _) => const SizedBox(
                height: 5,
              ),
          itemCount: currentUser.friendsRequest.length),
    );
  }

  Widget friendDetailsBody(BuildContext context, String friendId) {
    return StreamBuilder<AppUser?>(
        stream: Provider.of<UserProvider>(context, listen: false)
            .getUserStreamById(friendId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AppUser newFriend = snapshot.data!;
            return _profileDetailsRequest(context, newFriend);
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

  Widget _profileDetailsRequest(BuildContext context, AppUser friend) {
    bool isFriend = currentUser.friends.contains(friend.id);
    return SizedBox(
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
                CircleAvatar(
                  radius: 56,
                  backgroundImage: NetworkImage(friend.imgUrl),
                ),
                const SizedBox(height: 16),
                Text(
                  friend.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  friend.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: () async {
                    await acceptRequest(context, friend);
                  },
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Theme.of(context).primaryColor,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Request Accept",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> acceptRequest(BuildContext context, AppUser friend) async {
    await Provider.of<FriendProvider>(context, listen: false)
        .updateFiends(currentUser, friend.id);

    await Provider.of<FriendProvider>(context, listen: false)
        .updateFiends(friend, currentUser.id);

    await Provider.of<FriendProvider>(context, listen: false)
        .deleteFiendsRequests(currentUser, friend.id);
  }
}
