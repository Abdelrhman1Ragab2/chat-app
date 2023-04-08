import 'package:flutter/material.dart';

class VideoOption extends StatelessWidget {
  const VideoOption({Key? key}) : super(key: key);
  static const routeName="VideoOption";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child:Text(routeName)
      ),
    );
  }
}
