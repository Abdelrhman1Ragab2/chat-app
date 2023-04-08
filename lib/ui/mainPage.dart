import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/authinticat.dart';
import 'package:chat_if/providers/user_provider.dart';
import 'package:chat_if/ui/drawer_options/files.dart';
import 'package:chat_if/ui/splash_screen.dart';
import 'package:chat_if/ui/status_page.dart';
import 'package:chat_if/ui/tapBarPages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'auth.dart';
import 'call_page.dart';
import 'chats_page.dart';
import 'chattingPage.dart';
import 'drawer_options/photos.dart';
import 'drawer_options/profile.dart';
import 'drawer_options/settings.dart';
import 'drawer_options/videos.dart';
import 'friends_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static const routeName = "MainPage";

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const String _fakeUser = "@ABA@";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
        initialData: AppUser(
            id: _fakeUser,
            phone: "fake",
            name: "fake",
            imgUrl: "",
            friends: [],
            email: ""),
        stream: Provider.of<UserProvider>(context, listen: false)
            .getCurrentUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // if (kDebugMode) {
            //   print(snapshot.error.toString());
            // }
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text(snapshot.error.toString())),
              ),
            );
          }

          final AppUser? user = snapshot.data;
          print(user);
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: const Color.fromARGB(255, 26, 64, 126),
                  accentColor: const Color.fromARGB(255, 127, 172, 181),
                  appBarTheme: const  AppBarTheme(
                    color: Color.fromARGB(255, 13, 40, 82),
                  )),
              routes: {
                MainPage.routeName: (context) => MainPage(),
                ChatsPage.routeName: (context) => ChatsPage(currentUser: user!),
                StatusPage.routeName: (context) => StatusPage(),
                CallPage.routeName: (context) => CallPage(),
                CattingPage.routeName: (context) => CattingPage(),
                FriendsScreen.routeName: (context) =>FriendsScreen(currentUser: user!),
                FileOption.routeName: (context) => FileOption(),
                VideoOption.routeName: (context) => VideoOption(),
                PhotoOption.routeName:(context)=>PhotoOption(),
                ProfileOption.routeName:(context)=>ProfileOption(),
                SettingOption.routeName:(context)=>SettingOption(),
              },
              home: mapUserToHome(context, user));
        });
  }

  Widget mapUserToHome(BuildContext context, AppUser? user) {
    if (user == null) return Auth();
    if (user!.id == _fakeUser) return SplashScreen();
    return TabBarPages(
      currentUser: user,
    );
  }
}
