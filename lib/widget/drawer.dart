import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/authinticat.dart';
import 'package:chat_if/ui/drawer_options/photos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/options.dart';
import '../ui/drawer_options/files.dart';
import '../ui/drawer_options/friendes_requests.dart';
import '../ui/drawer_options/profile.dart';
import '../ui/drawer_options/settings.dart';
import '../ui/drawer_options/videos.dart';

class MyDrawer extends StatelessWidget {
  final AppUser currentUser;

  MyDrawer({Key? key, required this.currentUser}) : super(key: key);
  List<DrawerOptions> options = [
    DrawerOptions(
        lable: "Friend Requests", icon: Icons.request_page, routeName: FriendsRequests.routeName),
    DrawerOptions(
        lable: "Photos", icon: Icons.photo, routeName: PhotoOption.routeName),
    DrawerOptions(
        lable: "Files",
        icon: Icons.file_open_sharp,
        routeName: FileOption.routeName),
    DrawerOptions(
        lable: "Videos",
        icon: Icons.video_collection,
        routeName: VideoOption.routeName),
    DrawerOptions(
        lable: "Profile",
        icon: Icons.person,
        routeName: ProfileOption.routeName),
    DrawerOptions(
        lable: "Settings",
        icon: Icons.settings,
        routeName: SettingOption.routeName),
    DrawerOptions(
        lable: "LogOut", icon: Icons.logout_outlined, routeName: "logout"),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: infoBody(context),flex: 3,),
            Expanded(child: optionsBody(context),flex: 5,),
          ],
        ),
      ),
    );
  }

  Widget infoBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: double.maxFinite,
      decoration:  BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(currentUser.imgUrl
                 // "https://expertphotography.b-cdn.net/wp-content/uploads/2020/08/social-media-profile-photos-3.jpg"
     ),
              fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black26,
            ),
            padding: const EdgeInsets.all(5),
            child: Text(currentUser.name,
                style: GoogleFonts.lobsterTwo(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white)),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black26,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(currentUser.email,
                      style: GoogleFonts.alef(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget optionsBody(BuildContext ctx) {
    return ListView.separated(
        itemBuilder: (context, index) => listBody(ctx, options[index], index),
        separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
        itemCount: options.length);
  }

  Widget listBody(
      BuildContext context, DrawerOptions drawerOptions, int index) {
    return InkWell(
        onTap: () {
          if (index == 6) {
            Provider.of<AuthProvider>(context, listen: false).signOut();
          }
          Navigator.pushNamed(context, drawerOptions.routeName);
        },
        child: Card(
          elevation: 2,
          child: ListTile(
            leading: Icon(drawerOptions.icon),
            title: Text(
              drawerOptions.lable,
              style: GoogleFonts.abyssinicaSil(fontSize: 16),
            ),
            iconColor: Theme.of(context).primaryColor,
          ),
        ));
  }
}
