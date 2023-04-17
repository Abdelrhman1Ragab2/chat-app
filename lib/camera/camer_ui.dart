import 'package:camera/camera.dart';
import 'package:chat_if/camera/caption_page.dart';
import 'package:chat_if/model/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/message.dart';
import '../providers/ImageProvider.dart';
import '../ui/chattingPage.dart';

class OpenCamera extends StatefulWidget {
  final cameras;

  OpenCamera({Key? key, required this.cameras}) : super(key: key);
  static const routeName = "CameraUi";

  @override
  State<OpenCamera> createState() => _OpenCameraState();
}

late List<CameraDescription> _cameras;
late NavigatorState _navigator;
var routeArg;

class _OpenCameraState extends State<OpenCamera> {
  late CameraController controller1;
  late CameraController controller2;
  bool takingImage = false;
  bool frontCamera = false;

  @override
  void initState() {
    super.initState();
    _cameras = widget.cameras;
    controller1 = CameraController(_cameras[0], ResolutionPreset.max);
    controller2 = CameraController(_cameras[1], ResolutionPreset.max);
    controller1.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      // check if is mounted
      if (mounted) {
        // if it is mounted then go to result screen, time is off bro..
        Navigator.pushNamed(context, CattingPage.routeName, arguments: {
          Message.messageSender: routeArg["user"],
          Message.messageReceiver: routeArg["friend"],
          "readMessage": true,
        });
         frontCamera = false;
      }
    });
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppUser user = routeArg["user"];
    final AppUser? friend = routeArg["friend"];
    final bool forStatus = routeArg["forStatus"];
    if (!controller1.value.isInitialized) {
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
                child: //takingImage
                   // ? waitingWidget()
                     CameraPreview(frontCamera ? controller2 : controller1)),
            takingImage
                ? const CircularProgressIndicator()
                : Container(child: button(user, friend,forStatus))
          ]),
        ),
      ),
    );
  }

  Widget button(AppUser user, AppUser? friend,bool forStatus) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 3)),
              child: InkWell(
                  onTap: () async {
                    await getImageFromGallery(user, friend,forStatus);

                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3)),
                    height: 60,
                    width: 15,
                    child: Image.asset(
                      "assets/images/gallery.png",
                      fit: BoxFit.fill,
                      width: 20,
                    ),
                  )),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () async {
                final pic = frontCamera
                    ? await controller2.takePicture()
                    : await controller1.takePicture();
                if(pic!=null)
                  {
                    await Navigator.pushNamed(context, CaptionPage.routeName, arguments: {
                      "pic": pic,
                      "user": user,
                      "friend": friend,
                      "forStatus":forStatus,
                    });
                  }


                Navigator.of(context).pop();

              },
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
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: InkWell(
                onTap: () async {
                  if (frontCamera)
                    await controller1.initialize();
                  else
                    await controller2.initialize();
                  setState(() {
                    frontCamera = !frontCamera;
                  });
                },
                child: const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.cameraswitch_outlined,
                      size: 38,
                      color: Colors.white,
                    ))),
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

  getImageFromGallery(AppUser user, AppUser? friend,bool forStatus) async {
    final pic = await Provider.of<ImagingProvider>(context, listen: false)
        .getImageFile();
    if(pic!=null)
      {
        Navigator.pushNamed(context, CaptionPage.routeName, arguments: {
          "pic": pic,
          "user": user,
          "friend": friend,
          "forStatus":forStatus,

        });
        Navigator.of(context).pop();
      }

  }
}
