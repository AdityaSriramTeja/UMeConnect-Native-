import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ume_connect/models/firebaseUser.dart';
import 'package:ume_connect/style/style.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({Key? key}) : super(key: key);

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  late TextEditingController controller;
  late TextEditingController videocontroller;
  String name = "";
  String videoName = "";
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    videocontroller = TextEditingController();
  }

  @override
  dispose() {
    controller.dispose();
    videocontroller.dispose();
    super.dispose();
  }

  Future<CloudinaryResponse> takePhoto() async {
    //  CloudinaryResponse response;
    try {
      /*
      var result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        
      );
*/
      var file = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width - 30);
      if (file != null) {
        // for (PlatformFile file in result.files) {
        if (file.path != "") {
          openDialog(file);
        }
      } else if (file == null) print("file not selected");
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }

    throw Exception;

    // return response;
  }

  static Future<CloudinaryResponse> uploadFileOnCloudinary({
    String? filePath,
    String? name,
    required CloudinaryResourceType resourceType,
  }) async {
    //String result;
    CloudinaryResponse response;
    if (name == null) {
      name = "";
    }
    try {
      //this is my image database

      var cloudinary = CloudinaryPublic('narutoget', 'ih9qmdqy', cache: true);
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(filePath!, resourceType: resourceType),
      );
      print(response.secureUrl);
      FirebaseFirestore.instance.collection("photoPosts").add({
        "photoUrl": response.secureUrl,
        "likes": 0,
        "comments": 1,
        "postedBy": firebaseuser!.email,
        "postedByUsername": firebaseuser!.displayName,
        "timestamp": FieldValue.serverTimestamp(),
        "profilePic": firebaseuser!.photoURL,
        "caption": name,
      });
      //TODO add video storage cloudinary

    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }

    throw Exception();
  }

  static Future<CloudinaryResponse> uploadVideoFileOnCloudinary({
    String? filePath,
    String? videoName,
    required CloudinaryResourceType resourceType,
  }) async {
    //String result;
    CloudinaryResponse response;
    print(videoName);
    if (videoName == null) {
      videoName = "";
    }
    try {
      //this is my image database

      var cloudinary = CloudinaryPublic('dinog71yj', 'ilnqnzw9', cache: true);
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(filePath!, resourceType: resourceType),
      );
      print(response.secureUrl);
      FirebaseFirestore.instance.collection("posts").add({
        "videoUrl": response.secureUrl,
        "likes": 0,
        "comments": 1,
        "postedBy": firebaseuser!.email,
        "postedByUsername": firebaseuser!.displayName,
        "timestamp": FieldValue.serverTimestamp(),
        "profilePic": firebaseuser!.photoURL,
        "caption": videoName
      });
      //TODO add video storage cloudinary

    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }

    throw Exception();
  }
  //TODO selection video

  Future<CloudinaryResponse> selectVideo() async {
    //  CloudinaryResponse response;
    try {
      /*
      var result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        
      );
*/
      var file = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (file != null) {
        // for (PlatformFile file in result.files) {
        if (file.path != "") {
          openVideoDialog(file);
        }
        //  }
      } else if (file == null) print("file not selected");
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }

    throw Exception;

    // return response;
  }

  //TODO select PHOTO

  Future<CloudinaryResponse> selectPhoto() async {
    //  CloudinaryResponse response;
    try {
      /*
      var result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        
      );
*/
      var file = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width - 30);
      if (file != null) {
        // for (PlatformFile file in result.files) {
        if (file.path != "") {
          openDialog(file);
        }
        //  }
      } else if (file == null) print("file not selected");
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }

    throw Exception;

    // return response;
  }

  //TODO take videos
  Future<CloudinaryResponse> takeVideo() async {
    //  CloudinaryResponse response;
    try {
      /*
      var result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        
      );
*/
      var file = await ImagePicker().pickVideo(source: ImageSource.camera);
      if (file != null) {
        // for (PlatformFile file in result.files) {
        if (file.path != "") {
          openVideoDialog(file);
        }
        //  }
      } else if (file == null) print("file not selected");
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }

    throw Exception;

    // return response;
  }

  Future<String?> openDialog(var file) => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Caption"),
            content: TextField(
              decoration: InputDecoration(hintText: "enter post caption"),
              autofocus: true,
              controller: controller,
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final name = controller.text;
                    setState(() {
                      this.name = name;
                    });
                    Navigator.of(context).pop(controller.text);
                    await uploadFileOnCloudinary(
                        filePath: file.path,
                        resourceType: CloudinaryResourceType.Auto,
                        //     fileType: file.extension,
                        name: name);
                  },
                  child: Text("Submit"))
            ],
          ));
  Future<String?> openVideoDialog(var file) => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Caption"),
            content: TextField(
              decoration: InputDecoration(hintText: "enter Video caption"),
              autofocus: true,
              controller: videocontroller,
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final videoName = videocontroller.text;
                    setState(() {
                      this.videoName = videoName;
                    });
                    Navigator.of(context).pop(videocontroller.text);
                    await uploadVideoFileOnCloudinary(
                        filePath: file.path,
                        resourceType: CloudinaryResourceType.Auto,
                        //     fileType: file.extension,
                        videoName: videoName);
                  },
                  child: Text("Submit"))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    Widget rightButtons = Column(
      children: <Widget>[
        _CameraIconButton(
          icon: Icons.repeat,
          title: 'reverse',
        ),
        /*
        _CameraIconButton(
          icon: Icons.tonality,
          title: 'contrast',
        ),
        _CameraIconButton(
          icon: Icons.texture,
          title: '滤镜',
        ),
        */
        _CameraIconButton(
          icon: Icons.sentiment_satisfied,
          title: 'filters',
        ),
        _CameraIconButton(
          icon: Icons.timer,
          title: 'timer',
        ),
      ],
    );
    rightButtons = Opacity(
      opacity: 0.8,
      child: Container(
        padding: EdgeInsets.only(right: 20, top: 12),
        alignment: Alignment.topRight,
        child: Container(
          child: rightButtons,
        ),
      ),
    );
    Widget selectMusic = Container(
      padding: EdgeInsets.only(left: 20, top: 20),
      alignment: Alignment.topCenter,
      child: DefaultTextStyle(
        style: TextStyle(
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: IgnorePointer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.music_note,
              ),
              Text(
                'Default Sound',
                style: StandardTextStyle.normal,
              ),
              Container(width: 32, height: 12),
            ],
          ),
        ),
      ),
    );

    var notice = Container(
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Press 'upload photo' to upload a photo",
              style: GoogleFonts.inconsolata(
                  textStyle: TextStyle(
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.width / 20)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Press 'upload video' to upload a video",
              style: GoogleFonts.inconsolata(
                  textStyle: TextStyle(
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.width / 20)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Tap the Capture Icon once to take a picture",
              style: GoogleFonts.inconsolata(
                  textStyle: TextStyle(
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.width / 20)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Press and hold the Capture Icon to take a video",
              style: GoogleFonts.inconsolata(
                  textStyle: TextStyle(
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.width / 20)),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );

    var cameraButton = Container(
      padding: EdgeInsets.only(bottom: 12),
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        //padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () => selectPhoto(),
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Container(height: 2),
                Text(
                  "upload your photo",
                  style: StandardTextStyle.smallWithOpacity,
                )
              ],
            ),
            Expanded(
              child: Center(
                  child: InkWell(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.white.withOpacity(0.4),
                      width: 6,
                    ),
                  ),
                ),
                onTap: () {
                  //TODO FILE PICKER
                  takePhoto();
                },
                onLongPress: () {
                  takeVideo();
                },
              )),
            ),
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () => selectVideo(),
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Container(height: 2),
                Text(
                  "upload your video",
                  style: StandardTextStyle.smallWithOpacity,
                )
              ],
            ),
          ],
        ),
      ),
    );
    var body = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        notice,
        cameraButton,
        selectMusic,
        rightButtons,
      ],
    );

    return Scaffold(
      // backgroundColor: Color(0xFFf5f5f4),
      body: SafeArea(
        child: body,
      ),
    );
  }
}

class _SidePhotoButton extends StatelessWidget {
  final String? title;
  const _SidePhotoButton({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer();
  }
}

class _CameraIconButton extends StatelessWidget {
  final IconData? icon;
  final String? title;
  const _CameraIconButton({
    Key? key,
    this.icon,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: DefaultTextStyle(
          style: TextStyle(shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ]),
          child: Column(
            children: <Widget>[
              Icon(
                icon,
              ),
              Text(
                title!,
                style: StandardTextStyle.small,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
