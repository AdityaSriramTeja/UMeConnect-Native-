import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:ume_connect/models/videos.dart';
import 'package:ume_connect/pages/otherProfileScreen.dart';
import 'package:ume_connect/style/style.dart';

import 'package:ume_connect/widgets/commentsheet.dart' as CustomBottomSheet;

// ignore: must_be_immutable
class HomeSideBar extends StatefulWidget {
  int likes;
  int comments;
  late bool isLiked = false;
  final String profilePic;
  String docId;

  HomeSideBar(
      {Key? key,
      required this.likes,
      required this.comments,
      required this.profilePic,
      required this.docId})
      : super(key: key);
  @override
  _HomeSideBarState createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar>
    with SingleTickerProviderStateMixin {
  bool isLike = true;
  late AnimationController animationController;
  late String likecounter = widget.likes.toString();
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        profileImageButton(),
        sideBarItems(),
        SizedBox(height: MediaQuery.of(context).size.height / 15),
        AnimatedBuilder(
            child: Stack(
              children: [
                Container(
                  //  margin: EdgeInsets.only(top: 80),
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.height / 12,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          image: NetworkImage(widget.profilePic))),
                ),
              ],
            ),
            animation: animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: 2 * pi * animationController.value,
                child: child,
              );
            })
      ],
    );
  }

  profileImageButton() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        InkWell(
          child: Container(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.height / 12,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(image: NetworkImage(widget.profilePic))),
          ),
          /*
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtherProfilePage(
                          name: document['username'],
                          profilePic: document['profile pic'],
                          posts: document['posts'],
                          followers: document['followers'],
                          following: document['following'],
                          email: document['email'],
                        )));
          },
         
        ),
        Positioned(
            bottom: -9,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                )) */
        )
      ],
    );
  }

  sideBarItems() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 11, left: 2),
          child: LikeButton(
            size: MediaQuery.of(context).size.height / 16,
            likeCount: widget.likes,
            circleColor:
                CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            //   likeCount: widget.likes,
            onTap: (isLiked) async {
              /*
                    if (isLiked = false) {
                      
                    } else if (isLiked = true) {
                      
                    }
                    */
              isLiked
                  ? FirebaseFirestore.instance
                      .collection("posts")
                      .doc(widget.docId)
                      .update({"likes": FieldValue.increment(-1)})
                  : FirebaseFirestore.instance
                      .collection("posts")
                      .doc(widget.docId)
                      .update({"likes": FieldValue.increment(1)});
              this.widget.isLiked = !isLiked;
              print(isLiked);

              print(likecounter);
              return !isLiked;
            },
          ),
        ),
        /*
        Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 50),
            child: Text(
              likecounter,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height / 40),
            )),
            */
        Container(
          margin: EdgeInsets.only(bottom: 11, right: 15),
          child: IconButton(
            icon: Icon(
              Icons.mode_comment_outlined,
              size: MediaQuery.of(context).size.height / 16,
              color: Colors.white,
              //  color: isFavorite ? ColorPlate.red : null,
            ),
            onPressed: () {
              CustomBottomSheet.showModalBottomSheet(
                  backgroundColor: Colors.white.withOpacity(0),
                  context: context,
                  builder: (BuildContext context) => UMeCommentSheet());
            },
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 50),
          child: Text(widget.comments.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height / 40)),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 11, right: 15),
          child: IconButton(
            icon: Icon(
              Icons.share,
              size: MediaQuery.of(context).size.height / 16,
              color: Colors.white,
              //  color: isFavorite ? ColorPlate.red : null,
            ),
            onPressed: () {
              // ignore: unnecessary_statements
              //   isFavorite != isFavorite;
            },
          ),
        ),
        Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 40),
            child: Text("share",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height / 40))),
      ],
    );
  }
}

//TODO this is the actual comment data class

class UMeCommentSheet extends StatelessWidget {
  const UMeCommentSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: ColorPlate.back1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(4),
            height: 4,
            width: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            height: 24,
            alignment: Alignment.center,
            // color: Colors.white.withOpacity(0.2),
            child: Text(
              'Comments',
              style: StandardTextStyle.small,
            ),
          ),
          Expanded(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: <Widget>[
                _CommentRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'UME DEVELOPER',
          style: StandardTextStyle.smallWithOpacity,
        ),
        Container(height: 2),
        Text(
          'Wow NICE POST',
          style: StandardTextStyle.normal,
        ),
      ],
    );
    Widget right = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        Text(
          '1',
          style: StandardTextStyle.small,
        ),
      ],
    );
    right = Opacity(
      opacity: 0.3,
      child: right,
    );
    var avatar = Container(
      margin: EdgeInsets.fromLTRB(0, 8, 10, 8),
      child: Container(
        height: 36,
        width: 36,
        child: ClipOval(
          child: Image.network(
            "https://i.pinimg.com/originals/3e/a3/89/3ea3898a4fad533eb3e941bd787f1cfd.gif",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: <Widget>[
          avatar,
          Expanded(child: info),
          right,
        ],
      ),
    );
  }
}
