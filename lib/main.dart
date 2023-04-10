import 'package:chat_if/providers/authinticat.dart';
import 'package:chat_if/providers/chat_provider.dart';
import 'package:chat_if/providers/friend_provider.dart';
import 'package:chat_if/providers/message_provider.dart';
import 'package:chat_if/providers/tab_bar_provider.dart';
import 'package:chat_if/providers/user_provider.dart';
import 'package:chat_if/ui/mainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => TabBarProvider()),
    ChangeNotifierProvider(create: (_) =>AuthProvider()),
    ChangeNotifierProvider(create: (_) =>MessageProvider()),
    ChangeNotifierProvider(create: (_) =>FriendProvider()),
    ChangeNotifierProvider(create: (_) =>ChatProvider()),




  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
