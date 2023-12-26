import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/user_provider.dart';
import 'package:chat_if/ui/drawer_options/files.dart';
import 'package:chat_if/ui/splash_screen.dart';
import 'package:chat_if/ui/tabBar/status_page.dart';
import 'package:chat_if/ui/tabBar/tapBarPages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/camera/camer_ui.dart';
import '../core/camera/caption_page.dart';
import '../core/widget/story_page.dart';
import 'auth.dart';
import 'drawer_options/friendes_requests.dart';
import 'tabBar/call_page.dart';
import 'tabBar/chats_page.dart';
import 'chattingPage.dart';
import 'drawer_options/photos.dart';
import 'drawer_options/profile.dart';
import 'drawer_options/settings.dart';
import 'drawer_options/videos.dart';
import 'friends_search.dart';

class MainPage extends StatefulWidget {
  final  cameras;
  const MainPage({Key? key,required this.cameras}) : super(key: key);
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
            bio: "",
            friends: [],
            email: "",
            isOnline: true,
            friendsRequest: [],
            chats: []),
        stream: Provider.of<UserProvider>(context, listen: false)
            .getCurrentUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // if (kDebugMode) {
            //   print(snapshot.error.toString());
            // }
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(backgroundColor: Colors.green,),
                body: Center(child: Text(snapshot.error.toString())),
              ),
            );
          }

          final AppUser? user = snapshot.data;
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: const Color.fromARGB(255, 21, 23, 91),
                  hintColor: const Color.fromARGB(255, 120, 203, 218),
                  appBarTheme: const AppBarTheme(
                    color:  Color.fromARGB(255, 28, 65, 126),
                  )),
              routes: {
                MainPage.routeName: (context) => MainPage(cameras: widget.cameras),
                ChatsPage.routeName: (context) => ChatsPage(currentUser: user!),
                StatusPage.routeName: (context) => StatusPage(currentUser: user!),
                CallPage.routeName: (context) => const CallPage(),
                CattingPage.routeName: (context) => CattingPage(),
                FriendsScreen.routeName: (context) =>
                    FriendsScreen(currentUser: user!),
                FileOption.routeName: (context) => const FileOption(),
                VideoOption.routeName: (context) => const VideoOption(),
                PhotoOption.routeName: (context) => const PhotoOption(),
                ProfileOption.routeName: (context) => ProfileOption(
                      currentUser: user!,
                    ),
                SettingOption.routeName: (context) => const SettingOption(),
                FriendsRequests.routeName: (context) =>
                    FriendsRequests(currentUser: user!),
                OpenCamera.routeName:(context)=>OpenCamera(cameras: widget.cameras),
                DelayedPage.routeName:(context)=>DelayedPage(currentUser: user!),
                CaptionPage.routeName:(context)=>CaptionPage(),
              },
              home: mapUserToHome(context, user));
        });
  }

  Widget mapUserToHome(BuildContext context, AppUser? user) {
    if (user == null) return const Auth();
    if (user.id == _fakeUser) return const SplashScreen();
    return TabBarPages(
      currentUser: user,
    );
  }
}
