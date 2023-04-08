import 'package:flutter/material.dart';

class FileOption extends StatelessWidget {
  const FileOption({Key? key}) : super(key: key);
  static const routeName="FileOption";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child:Text(routeName)
      ),
    );
  }
}
