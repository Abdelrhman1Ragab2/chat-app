import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/friend_provider.dart';

class FriendsScreen extends StatelessWidget {
  final AppUser currentUser;
  FriendsScreen({Key? key,required this.currentUser}) : super(key: key);
  static const routeName = "FriendsScreen";
  bool isAdd=false;

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
            SizedBox(width: 5,),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }

  Widget friendDetailsBody(BuildContext context) {
    return StreamBuilder<AppUser>(
        stream: Provider.of<UserProvider>(context, listen: false)
            .getFriendsStream(searchController.text),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AppUser newFriend = snapshot.data!;
            return _profileDetails(context,newFriend);
          }
          if (snapshot.hasError) {
            return const SizedBox();
            //return Text(snapshot.error.toString());
          } else {
            return const Text("waiting...");
          }
        });
  }

  Widget _profileDetails(BuildContext context, AppUser newFriend) {
    return  Container(
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
                Container(
                  width: 150,
                  child: MaterialButton(onPressed: ()async{
                    await Provider.of<FriendProvider>(context,listen: false).updateFiends(currentUser,newFriend.id);
                    //Provider.of<FriendProvider>(context,listen: false).showFriendsSearch(false);
                    isAdd=true;


                  },
                    elevation: 20,
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Row(
                      children: [
                        Text(isAdd?"done!":"add Friend"),
                       const SizedBox(width: 5,),
                         Icon(isAdd?Icons.done:Icons.add)
                      ],
                    ),),
                )
              ],
            ),
          )),
    );
  }
}
