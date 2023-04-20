
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

import 'auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    return
      AnimatedSplashScreen(
        splashIconSize: 350.0,
        nextScreen: Auth(),
        duration: 3000,
        curve: Curves.bounceOut,
        splashTransition: SplashTransition.scaleTransition,
        splash:Image.asset("assets/images/chatlogo.png") ,
        pageTransitionType: PageTransitionType.leftToRightJoined,
    );
  }
}
