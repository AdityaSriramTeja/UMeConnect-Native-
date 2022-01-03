import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:ume_connect/models/firebaseUser.dart';
import 'package:ume_connect/pages/addVideoPage.dart';
import 'package:ume_connect/pages/photoPage.dart';
import 'package:ume_connect/pages/homePage.dart';
import 'package:ume_connect/pages/inboxPage.dart';
import 'package:ume_connect/pages/profilePage.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({
    Key? key,
  }) : super(key: key);

  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int selectedPageIndex = 0;

  static List<Widget> pages = [
    PhotoPage(),
    VideoPage(),
    AddVideo(),
    InboxPage(),
    ProfilePage(),
  ];

  void _onIconTapped(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    connectUser();
    super.initState();
  }

  @override
  void dispose() {
    print(firebaseuser!.displayName);
    firebaseuser = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: pages[selectedPageIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          height: 50,
          color: Colors.white,
          items: <Widget>[
            Icon(Icons.photo, color: Colors.black),
            Icon(Icons.video_collection, color: Colors.black),
            Icon(Icons.add_box_outlined, color: Colors.black),
            Icon(Icons.inbox_outlined, color: Colors.black),
            Icon(Icons.supervised_user_circle_outlined, color: Colors.black),
          ],
          animationDuration: Duration(milliseconds: 400),
          onTap: (index) {
            if (index == 0) {
              _onIconTapped(0);
            } else if (index == 1) {
              _onIconTapped(1);
            } else if (index == 2) {
              _onIconTapped(2);
            } else if (index == 3) {
              _onIconTapped(3);
            } else if (index == 4) {
              _onIconTapped(4);
            }
          }),
    );
  }

  Future<void> connectUser() async {
    final client = StreamChatCore.of(context).client;
    await client.connectUser(
      User(
        id: firebaseuser!.uid,
        extraData: {
          'name': firebaseuser!.displayName,
          'image': firebaseuser!.photoURL,
        },
      ),
      client.devToken(firebaseuser!.uid).rawValue,
    );

    List<String> splitList = firebaseuser!.displayName!.split(" ");
    List<String> indexList = [];
    for (int i = 0; i < splitList.length; i++) {
      for (int j = 1; j < splitList[i].length + 1; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: firebaseuser!.email)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseuser!.email)
          .set({
        "username": firebaseuser!.displayName,
        "email": firebaseuser!.email,
        "uid": firebaseuser!.uid,
        "profile pic": firebaseuser!.photoURL,
        "searchIndex": indexList,
        "followers": 0,
        "following": 0,
        "posts": 0
      });
    }
  }
}
