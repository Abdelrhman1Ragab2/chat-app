import 'package:chat_if/model/users.dart';
import 'package:chat_if/ui/status_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authinticat.dart';
import '../providers/tab_bar_provider.dart';
import 'call_page.dart';
import 'chats_page.dart';
import 'friends_page.dart';

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
    TabController tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: Provider.of<TabBarProvider>(context).currentIndex,
    );

    return Scaffold(
        floatingActionButton: Card(

          shape: CircleBorder(),
          elevation: 20,
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 24, 61, 119),
              boxShadow: [
                BoxShadow(color: Colors.blue.shade100,spreadRadius: 2,offset: Offset.fromDirection(-1,-2)),
               
              ],
              borderRadius: BorderRadius.all(Radius.circular(20))

            ),
            width: 140,
            child: MaterialButton(
              child:Text("add new chat",style: TextStyle(color: Colors.white,fontSize: 18),),
              onPressed: () {
                Navigator.pushNamed(context, FriendsScreen.routeName);
              },
                ),
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).signOut();
                },
                icon: Icon(Icons.logout))
          ],
          title: const Text("Chat App"),
          bottom: TabBar(
            controller: tabController,
            tabs: const [
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
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 13, 40, 82),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            ChatsPage(currentUser: widget.currentUser),
            StatusPage(),
            CallPage()
          ],
        ));
  }
}
