
import 'package:chat_if/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/users.dart';
import '../providers/message_provider.dart';
import '../providers/tab_bar_provider.dart';
import 'friends_list.dart';

class MyBottomSheet extends StatelessWidget {
  AppUser? currentUser;
  Message? message;
   MyBottomSheet({Key? key,required this.currentUser,required this.message}) : super(key: key);
  static const routeName="MyBottomSheet";

  @override
  Widget build(BuildContext context) {
    return bottomSheetBody(context,currentUser,message);
  }


  Widget bottomSheetBody(BuildContext context,AppUser? currentUser, Message? message)
  {
    return Container(
      color:Theme.of(context).primaryColor,
        height: 80,
        width: double.maxFinite,
        //color: Colors.black54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            bottomIcon(context, "Reply", Icons.reply, () async{
             await Provider.of<MessageProvider>(context,listen: false).crateReplyMessage(message!);
              Navigator.pop(context);

            }),
            bottomIcon(context, "Copy", Icons.copy, () {
              final data =ClipboardData(text: message!.text);
              Clipboard.setData(data);
              Navigator.pop(context);
            }),
            bottomIcon(context, "Forward", Icons.forward, () async{
              friendsList(context,currentUser!,message!);
            }),
            bottomIcon(context, "Delete", Icons.delete, () async{
              await Provider.of<MessageProvider>(context,listen: false).deleteMessage(message!.id);
              Navigator.pop(context);
            }),
          ],
        ));
  }

  Widget bottomIcon(BuildContext context, String text, IconData icon, Function() function) {
    return Expanded(
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            onPressed: () {
              function();
              Provider.of<TabBarProvider>(context, listen: false)
                  .onShowBottomSheet();
            },
          ),
          Text(
            text,
            style: GoogleFonts.alef(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }

  void friendsList(BuildContext context,AppUser currentUser,Message message) async {
    showDialog(
        context: context,
        builder: (context) {
          return FriendsList(currentUser: currentUser,message: message,);
        });
  }

}
