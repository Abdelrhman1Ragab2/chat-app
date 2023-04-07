
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key}) : super(key: key);
  static const routeName="CallPage";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(routeName),
      ),
    );
  }
}
