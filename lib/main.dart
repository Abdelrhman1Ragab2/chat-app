import 'package:camera/camera.dart';
import 'package:chat_if/providers/ImageProvider.dart';
import 'package:chat_if/providers/animation_provider.dart';
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
  final cameras =await availableCameras();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => TabBarProvider()),
    ChangeNotifierProvider(create: (_) =>AuthProvider()),
    ChangeNotifierProvider(create: (_) =>MessageProvider()),
    ChangeNotifierProvider(create: (_) =>FriendProvider()),
    ChangeNotifierProvider(create: (_) =>ChatProvider()),
    ChangeNotifierProvider(create: (_) =>ImagingProvider()),
    ChangeNotifierProvider(create: (_)=>AnimationProvider()),




  ], child: MyApp(cameras: cameras,)));
}

class MyApp extends StatelessWidget {
  final cameras;
  const MyApp({Key? key ,required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPage(cameras: cameras,);
  }
}
