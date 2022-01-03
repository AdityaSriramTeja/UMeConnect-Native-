import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ume_connect/models/firebaseUser.dart';
import 'package:ume_connect/widgets/homeSideBar.dart';
import 'package:ume_connect/widgets/videoDetails.dart';
import 'package:ume_connect/widgets/videoTile.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int _snappedPageIndex = 0;
  //Stream<QuerySnapshot<Object?>>? videoStream;
  //QuerySnapshot videosnapshot;
  @override
  void initState() {
    // fetchVideoStream();
    super.initState();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getVideoStream(uid) async {
    QuerySnapshot userFollowSnapshots = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .get();
    final users = userFollowSnapshots.docs.map((doc) => doc.id).toList();
    Future<QuerySnapshot<Map<String, dynamic>>> videoStream = FirebaseFirestore
        .instance
        .collection("posts")
        .where("postedBy", whereIn: users)
        .orderBy('timestamp', descending: true)
        .get();
    return videoStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Center(
                child: Text("Following",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 16, color: Colors.grey[300])))),
        body: FutureBuilder<QuerySnapshot>(
            future: getVideoStream(firebaseuser!.email),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Text("Start Following people to populate your Feed!",
                        style: GoogleFonts.pacifico(
                            textStyle: TextStyle(
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.width / 9))));
              } else if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: new Text('Loading...'));
                default:
                  return PageView.builder(
                    onPageChanged: (int page) => {
                      setState(() {
                        _snappedPageIndex = page;
                        print(page);
                      }),
                    },
                    scrollDirection: Axis.horizontal,
                    //   controller: PageController(
                    //       initialPage: 0, keepPage: true, viewportFraction: 1),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //  List<QueryDocumentSnapshot<Object?>> document = snapshot.data!.docs;
                      print((snapshot.data!.docs[index].data()
                          as dynamic)['postedByUsername']);
                      print("hiii");
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoTile(
                            videoUrl: (snapshot.data!.docs[index].data()
                                as dynamic)['videoUrl'],
                            currentPage: index,
                            snappedPageIndex: _snappedPageIndex,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 12, bottom: 75),
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    // color: Colors.amber,
                                    child: VideoDetails(
                                      postedBy:
                                          (snapshot.data!.docs[index].data()
                                              as dynamic)['postedByUsername'],
                                      caption: (snapshot.data!.docs[index]
                                          .data() as dynamic)['caption'],
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  // color: Colors.pink,
                                  padding: EdgeInsets.only(bottom: 40),
                                  height:
                                      MediaQuery.of(context).size.height / 1.27,
                                  child: HomeSideBar(
                                    likes: (snapshot.data!.docs[index].data()
                                        as dynamic)['likes'],
                                    comments: (snapshot.data!.docs[index].data()
                                        as dynamic)['comments'],
                                    profilePic: (snapshot.data!.docs[index]
                                        .data() as dynamic)['profilePic'],
                                    docId: snapshot.data!.docs[index].id,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    },
                  );
              }
            }));
  }
}
