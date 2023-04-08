import 'package:flutter/material.dart';

class SettingOption extends StatelessWidget {
  const SettingOption({Key? key}) : super(key: key);
  static const routeName="SettingOption";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child:Text(routeName)
      ),
    );
  }
}
