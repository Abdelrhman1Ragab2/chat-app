import 'package:chat_if/model/users.dart';
import 'package:chat_if/ui/tabBar/status_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/camera/camer_ui.dart';
import '../../core/widget/drawer.dart';
import '../../providers/authinticat.dart';
import '../../providers/tab_bar_provider.dart';
import 'chats_page.dart';
import '../friends_search.dart';
import 'friends.dart';

class TabBarPages extends StatefulWidget {
  final AppUser currentUser;

  const TabBarPages({Key? key, required this.currentUser}) : super(key: key);
  static const String routeName = "TabBarPages";

  @override
  State<TabBarPages> createState() => _TabBarPagesState();
}

class _TabBarPagesState extends State<TabBarPages>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    int currentIndexs = Provider.of<TabBarProvider>(context).currentIndex;
    TabController tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: currentIndexs,
    );

    return Scaffold(
        floatingActionButton: currentIndexs != 1
            ? InkWell(
                onTap: () {
                  if (currentIndexs == 0) {
                    Navigator.pushNamed(context, FriendsScreen.routeName);
                  } else {
                    Navigator.pushNamed(context, OpenCamera.routeName,
                        arguments: {
                          "user": widget.currentUser,
                          "friend": null,
                          "forStatus": true,
                        });
                  }
                },
                child: Card(
                  shape: const CircleBorder(),
                  elevation: 20,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 24, 61, 119),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.shade100,
                              spreadRadius: 2,
                              offset: Offset.fromDirection(-1, -2)),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    width: currentIndexs == 0 ? 160 : 140,
                    child: Text(
                      currentIndexs == 0 ? "add new friend" : "add new story ",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).signOut();
                },
                icon: Icon(Icons.logout)),
          ],
          title: const Text("Chat App"),
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(
                text: "Friends",
              ),
              Tab(
                text: "Chat",
              ),
              Tab(
                text: "Status",
              ),
              // Tab(
              //   text: "Call",
              // ),
            ],
            onTap: (index) =>
                Provider.of<TabBarProvider>(context, listen: false)
                    .changeTab(index),
          ),
        ),
        drawer: MyDrawer(currentUser: widget.currentUser),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            Friends(currentUser: widget.currentUser),
            ChatsPage(currentUser: widget.currentUser),
            StatusPage(currentUser: widget.currentUser),
            // CallPage() add in new version from app;ication
          ],
        ));
  }
}
