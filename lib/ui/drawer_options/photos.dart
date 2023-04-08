import 'package:flutter/material.dart';

class PhotoOption extends StatelessWidget {
  const PhotoOption({Key? key}) : super(key: key);
  static const routeName="PhotoOption";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child:Text(routeName)
      ),
    );  }
}
