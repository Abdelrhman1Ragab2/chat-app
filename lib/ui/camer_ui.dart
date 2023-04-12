import 'package:camera/camera.dart';
import 'package:chat_if/model/message.dart';
import 'package:chat_if/model/users.dart';
import 'package:chat_if/providers/message_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ImageProvider.dart';

class CameraUi extends StatefulWidget {
  final cameras;

  CameraUi({Key? key, required this.cameras}) : super(key: key);
  static const routeName = "CameraUi";

  @override
  State<CameraUi> createState() => _CameraUiState();
}

late List<CameraDescription> _cameras;

class _CameraUiState extends State<CameraUi> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    _cameras = widget.cameras;
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final userId = routeArg["userId"];
    final friendId = routeArg["friendId"];
    if (!controller.value.isInitialized) {
      return Scaffold();
    }
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            SizedBox(
                height: double.infinity,
                child: Provider.of<ImagingProvider>(context).takingImage
                    ? waitingWidget()
                    : CameraPreview(controller)),
            Provider.of<ImagingProvider>(context).takingImage
                ? const CircularProgressIndicator()
                : Container(child: button(userId, friendId))
          ]),
        ),
      ),
    );
  }

  Widget button(String userId, String friendId) {
    return Row(

      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: InkWell(
              onTap: () async{
                await getImageFromGallery(userId,friendId);

              },
              child: Container(
                width: 50,
                height: 50,
                child: Image.asset(
                  "assets/images/gallery.png",

                  width: 50,
                  height: 50,
                ),
              )),
        ),
        Container(
          padding: EdgeInsets.only(left: 40),
          child: InkWell(
            onTap: () async {
              final pic = await controller.takePicture();
              await Provider.of<ImagingProvider>(context, listen: false)
                  .takePicture(pic, userId, friendId);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 8),
                        borderRadius: BorderRadius.circular(30)),
                  )
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget waitingWidget() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: const Center(
        child: Text(
          "waiting for image processing please..",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  getImageFromGallery(String userId,String friendId) async {

    final pic =
        await Provider.of<ImagingProvider>(context, listen: false)
            .getImageFile();
    if (pic == null) return;
    await Provider.of<ImagingProvider>(context, listen: false)
        .takePicture(pic, userId, friendId);
    Navigator.pop(context);
  }
}
