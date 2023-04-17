import 'package:chat_if/model/status.dart';
import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/status_provider.dart';
import 'package:chat_if/ui/tabBar/status_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authinticat.dart';
import '../../providers/tab_bar_provider.dart';
import '../../widget/drawer.dart';
import '../../camera/camer_ui.dart';
import 'call_page.dart';
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
    int currentIndexs=Provider.of<TabBarProvider>(context).currentIndex;
    TabController tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: currentIndexs,
    );

    return Scaffold(
        floatingActionButton:
        currentIndexs==0 || currentIndexs==2
                ? InkWell(
                 onTap:(){
                   if(currentIndexs==0)
                     {
                       Navigator.pushNamed(context, FriendsScreen.routeName);
                     }
                   else{
                     Navigator.pushNamed(context, OpenCamera.routeName,
                     arguments: {
                       "user":widget.currentUser,
                       "friend":null,
                       "forStatus":true,
                     }
                     );
                   }
                 } ,
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
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        width: currentIndexs==0?160:140,

                          child: Text(
                            currentIndexs==0?
                            "add new friend":"add new story ",
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
              Tab(
                text: "Call",
              ),
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
            CallPage()
          ],
        ));
  }
}
