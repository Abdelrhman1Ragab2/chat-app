
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);
  static const routeName="StatusPage";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(routeName),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
