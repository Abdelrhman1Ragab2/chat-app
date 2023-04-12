import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/friend_provider.dart';

class FriendsScreen extends StatelessWidget {
  final AppUser currentUser;

  FriendsScreen({Key? key, required this.currentUser}) : super(key: key);
  static const routeName = "FriendsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends"),
      ),
      body: buildBody(context),
    );
  }

  TextEditingController searchController = TextEditingController();

  Widget buildBody(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            searchBody(),
            const SizedBox(
              height: 20,
            ),
            buttonBody(context),
            const SizedBox(
              height: 20,
            ),
            Provider.of<FriendProvider>(context).showFriend
                ? friendDetailsBody(context)
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget searchBody() {
    return Container(
      padding: EdgeInsets.all(4),
      child: TextFormField(
        controller: searchController,
        decoration: const InputDecoration(hintText: "search for new friends"),
      ),
    );
  }

  Widget buttonBody(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(4),
      child: MaterialButton(
        elevation: 10,
        color: Theme.of(context).secondaryHeaderColor,
        onPressed: () {
          Provider.of<FriendProvider>(context, listen: false)
              .showFriendsSearch(true);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Search",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }

  Widget friendDetailsBody(BuildContext context) {
    final email = searchController.text;
    return StreamBuilder<AppUser>(
        stream: Provider.of<UserProvider>(context, listen: false)
            .getFriendsStream(email),
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

  Widget _profileDetails(BuildContext context, AppUser newFriend) {
    bool isFriend = currentUser.friends.contains(newFriend.id);
    bool isRequest = newFriend.friendsRequest.contains(currentUser.id);
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
                CircleAvatar(
                  radius: 56,
                  backgroundImage: NetworkImage(newFriend.imgUrl),
                ),
                const SizedBox(height: 16),
                Text(
                  newFriend.name,
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
                  newFriend.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                MaterialButton(
                  onPressed: () {
                    if (!isFriend)
                    {
                      if (!isRequest) {
                        Provider.of<FriendProvider>(context, listen: false)
                            .updateFiendsRequests(newFriend, currentUser.id);
                      } else {
                        Provider.of<FriendProvider>(context, listen: false)
                            .deleteFiendsRequests(newFriend, currentUser.id);
                      }
                     // Navigator.pop(context);
                    }

                  },
                  elevation: 10,
                  color: isFriend
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).secondaryHeaderColor,
                  child: Container(
                    width: 120,
                    child: isFriend
                        ? Text(
                      "Friend",
                      style: TextStyle(
                        color: isFriend ? Colors.white : Colors.black,
                      ),
                    ):Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                                isRequest ? "request sent" : "add Friend",
                                style: TextStyle(
                                  color: isFriend ? Colors.white : Colors.black,
                                ),
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          isRequest ? Icons.done : Icons.add,
                          color: isFriend ? Colors.white : Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
