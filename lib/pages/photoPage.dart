import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:ume_connect/models/firebaseUser.dart';
import 'package:ume_connect/pages/otherProfileScreen.dart';
import 'package:ume_connect/pages/profilePage.dart';
import 'package:ume_connect/style/style.dart';
import 'package:ume_connect/widgets/avatar.dart';
import 'package:like_button/like_button.dart';
import 'package:ume_connect/widgets/commentsheet.dart' as CustomBottomSheet;
import 'package:ume_connect/widgets/homeSideBar.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  bool isLiked = false;
  Future<QuerySnapshot<Map<String, dynamic>>> getPhotoStream(uid) async {
    QuerySnapshot userFollowSnapshots = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .get();
    final users = userFollowSnapshots.docs.map((doc) => doc.id).toList();
    Future<QuerySnapshot<Map<String, dynamic>>> photoStream = FirebaseFirestore
        .instance
        .collection("photoPosts")
        .where("postedBy", whereIn: users)
        .orderBy('timestamp', descending: true)
        .get();
    return photoStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Following"),
          elevation: 0,
        ),
        body: FutureBuilder(
            future: getPhotoStream(firebaseuser!.email),
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
                  print("hiii");
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  buildPostSection(
                                    (snapshot.data!.docs[index].data()
                                        as dynamic)['photoUrl'],
                                    (snapshot.data!.docs[index].data()
                                        as dynamic)['profilePic'],
                                    (snapshot.data!.docs[index].data()
                                        as dynamic)['postedByUsername'],
                                    (snapshot.data!.docs[index].data()
                                        as dynamic)['likes'],
                                    (snapshot.data!.docs[index].data()
                                        as dynamic)['comments'],
                                    snapshot.data!.docs[index].id,
                                    (snapshot.data!.docs[index].data()
                                        as dynamic)['caption'],
                                  ),
                                  Divider(
                                    height: 3,
                                    thickness: 3,
                                  )
                                ],
                              );
                            }),
                      ),
                    ],
                  );
              }
            }));
  }

  bool liked = false;
  Container buildPostSection(String urlPost, String urlProfilePhoto,
      String username, int likes, int comments, String docId, String caption) {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPostFirstRow(urlProfilePhoto, username),
            SizedBox(
              height: 10,
            ),
            buildPostPicture(urlPost),
            SizedBox(
              height: 5,
            ),
            Row(children: <Widget>[
              Expanded(
                  child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Marquee(
                        text: caption + "     ",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        velocity: 30,
                      ))),
              IconButton(onPressed: () {}, icon: Icon(Icons.share)),
              GestureDetector(
                child: LikeButton(
                  size: 25,
                  circleColor: CircleColor(
                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  likeCount: likes,
                  onTap: (isLiked) async {
                    /*
                    if (isLiked = false) {
                      
                    } else if (isLiked = true) {
                      
                    }
                    */
                    isLiked
                        ? FirebaseFirestore.instance
                            .collection("photoPosts")
                            .doc(docId)
                            .update({"likes": FieldValue.increment(-1)})
                        : FirebaseFirestore.instance
                            .collection("photoPosts")
                            .doc(docId)
                            .update({"likes": FieldValue.increment(1)});
                    this.isLiked = !isLiked;
                    print(isLiked);
                    return !isLiked;
                  },
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.comment_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    CustomBottomSheet.showModalBottomSheet(
                        backgroundColor: Colors.white.withOpacity(0),
                        context: context,
                        builder: (BuildContext context) => UMeCommentSheet());
                  }),
            ]),
            SizedBox(
              height: 8,
            ),
          ],
        ));
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Row buildPostFirstRow(String urlProfilePhoto, String username) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Avatar.small(
              url: urlProfilePhoto,
              /*
              onTap: () {
               Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtherProfilePage(
                                              name: username,
                                              profilePic:
                                                  urlProfilePhoto,
                                              posts: document['posts'],
                                              followers: document['followers'],
                                              following: document['following'],
                                              email: document['email'],
                                            )));;
              },
              */
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              username,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ],
    );
  }

  Stack buildPostPicture(String urlPost) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent,
                  spreadRadius: 2,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(urlPost),
              )),
        ),
      ],
    );
  }
}
