import 'package:flutter/material.dart';


class ProfileOption extends StatelessWidget {
  const ProfileOption({Key? key}) : super(key: key);
  static const routeName="ProfileOption";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child:Text(routeName)
      ),
    );  }
}
