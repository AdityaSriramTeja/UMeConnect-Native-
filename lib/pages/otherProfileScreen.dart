import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ume_connect/models/firebaseUser.dart';
import 'package:ume_connect/pages/profilePage.dart';
import 'package:ume_connect/pages/userDetailsPage.dart';
import 'package:ume_connect/style/style.dart';
import 'package:ume_connect/widgets/avatar.dart';

// ignore: must_be_immutable
class OtherProfilePage extends StatefulWidget {
  OtherProfilePage(
      {Key? key,
      required this.name,
      required this.profilePic,
      required this.posts,
      required this.followers,
      required this.following,
      required this.email})
      : super(key: key);
  final String name;
  final String profilePic;
  int followers;
  final int following;
  final int posts;
  final String email;
  @override
  _OtherProfilePageState createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  bool isFollowing = false;

  unFollowUser() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseuser!.email)
        .collection("following")
        .doc(widget.email)
        .delete();
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseuser!.email)
        .update({"following": FieldValue.increment(-1)});
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.email)
        .update({"followers": FieldValue.increment(-1)});

    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.email)
        .collection("followers")
        .doc(firebaseuser!.email)
        .delete();
  }

  followUser() {
    print(firebaseuser!.email);
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseuser!.email)
        .collection("following")
        .doc(widget.email)
        .set({
      "following": widget.email,
      "profilePic": widget.profilePic,
      "name": widget.name
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseuser!.email)
        .update({"following": FieldValue.increment(1)});
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.email)
        .update({"followers": FieldValue.increment(1)});

    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.email)
        .collection("followers")
        .doc(firebaseuser!.email)
        .set({
      "follower": firebaseuser!.email,
      "profilePic": firebaseuser!.photoURL,
      "name": firebaseuser!.displayName
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget likeButton = Container(
      color: ColorPlate.back1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            child: _UserFollowBtn(
              title: isFollowing ? 'UnFollow' : "Follow",
            ),
            onTap: () {
              setState(() {
                this.isFollowing = !isFollowing;
                //_followersCount++;
                if (isFollowing) {
                  widget.followers = widget.followers + 1;
                  followUser();
                } else {
                  widget.followers = widget.followers - 1;
                  unFollowUser();
                }
              });
              //    followOrUnFollow();
            },
          ),
        ],
      ),
    );
    Widget avatar = Container(
      height: 120 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(left: 18),
      alignment: Alignment.bottomLeft,
      child: OverflowBox(
        alignment: Alignment.bottomLeft,
        minHeight: 20,
        maxHeight: 300,
        child: Container(
          height: 74,
          width: 74,
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(44),
            color: Colors.blue,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: ClipOval(
            child: Avatar.large(
              url: widget.profilePic,
            ),
          ),
        ),
      ),
    );
    Widget body = ListView(
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: <Widget>[
        Container(height: 20),
        Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[likeButton, avatar],
        ),
        Container(
          color: ColorPlate.back1,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 18),
                color: ColorPlate.back1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: StandardTextStyle.big,
                    ),
                    Container(height: 8),
                    Text(
                      'Hi there',
                      style: StandardTextStyle.smallWithOpacity.apply(
                        color: Colors.white,
                      ),
                    ),
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        _UserTag(tag: 'eat'),
                        _UserTag(tag: 'sleep'),
                        _UserTag(tag: 'work'),
                      ],
                    ),
                    Container(height: 10),
                  ],
                ),
              ),
              Container(
                color: ColorPlate.back1,
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextGroup(widget.followers.toString(), 'Followers'),
                    TextGroup(widget.following.toString(), 'Following'),
                    //     TextGroup(widget.posts.toString(), 'Posts'),
                  ],
                ),
              ),
              Container(
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              _UserVideoTable(),
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: <Color>[
              Colors.blue,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 400),
              height: double.infinity,
              width: double.infinity,
              color: ColorPlate.back1,
            ),
            body,
          ],
        ),
      ),
    );
  }
}

class _UserFollowBtn extends StatelessWidget {
  const _UserFollowBtn({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 20,
      ),
      margin: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(color: ColorPlate.orange),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPlate.orange),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _UserTag extends StatelessWidget {
  final String? tag;
  const _UserTag({
    Key? key,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag ?? 'posts',
        style: StandardTextStyle.smallWithOpacity,
      ),
    );
  }
}

class _UserVideoTable extends StatelessWidget {
  const _UserVideoTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DefaultTabController(
          length: 2,
          child: Container(
            height: 40,
            color: ColorPlate.back1,
            child: TabBar(
              tabs: [
                Tab(text: "Posts"),
                Tab(text: "videos"),
                //     Tab(text: "tags"),
              ],
            ),
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              _SmallVideo(),
              _SmallVideo(),
              _SmallVideo(),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              _SmallVideo(),
              _SmallVideo(),
              _SmallVideo(),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              _SmallVideo(),
              _SmallVideo(),
              _SmallVideo(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallVideo extends StatelessWidget {
  const _SmallVideo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 3 / 4.0,
        child: Container(
          decoration: BoxDecoration(
            color: ColorPlate.darkGray,
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.center,
          child: Text(
            'Feature Under Implimentation',
            style: TextStyle(
              color: Colors.white.withOpacity(0.1),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _PointSelectTextButton extends StatelessWidget {
  final bool isSelect;
  final String title;
  final Function? onTap;
  const _PointSelectTextButton(
    this.isSelect,
    this.title, {
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isSelect
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: ColorPlate.orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                )
              : Container(),
          Container(
            padding: EdgeInsets.only(left: 2),
            child: Text(
              title,
              style: isSelect
                  ? StandardTextStyle.small
                  : StandardTextStyle.smallWithOpacity,
            ),
          )
        ],
      ),
    );
  }
}

class TextGroup extends StatelessWidget {
  final String title, tag;
  final Color? color;

  const TextGroup(
    this.title,
    this.tag, {
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: StandardTextStyle.big.apply(color: color),
          ),
          Container(width: 4),
          Text(
            tag,
            style: StandardTextStyle.smallWithOpacity.apply(
              color: color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class TopToolRow extends StatelessWidget {
  final Widget? right;
  final bool? canPop;
  final Function? onPop;
  const TopToolRow({
    Key? key,
    this.right,
    this.canPop,
    this.onPop,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var popButton = canPop == true
        ? InkWell(
            child: Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.36),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
            onTap: () {
              if (onPop == null) {
                Navigator.of(context).pop();
              } else {
                onPop?.call();
              }
            },
          )
        : Container();
    Widget topButtonRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        popButton,
        Expanded(child: Container()),
        right ?? Container(),
      ],
    );
    return topButtonRow;
  }
}
