import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';
import 'package:ume_connect/pages/messagePage.dart';
import 'package:ume_connect/pages/searchPage.dart';
import 'package:ume_connect/style/style.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  int select = 0;
  @override
  Widget build(BuildContext context) {
    Widget topButtons = SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _TopIconTextButton(
              title: 'Messages',
              icon: Icons.message_outlined,
              color: Colors.teal,
              color2: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (cxt) => MessagePage(),
                  ),
                );
              },
            ),
            _TopIconTextButton(
              title: 'Search Users',
              icon: Icons.person_search_outlined,
              color: Colors.pink,
              color2: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (cxt) => SearchPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
    Widget ad = Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: AspectRatio(
        aspectRatio: 4.0,
        child: Container(
          decoration: BoxDecoration(
            color: ColorPlate.darkGray,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            'Hellooo =)',
            style: TextStyle(
              color: Colors.white.withOpacity(0.1),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
    Widget body = Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: <Widget>[
          topButtons,
          ad,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Notifications',
              style: StandardTextStyle.smallWithOpacity,
            ),
          ),
        ],
      ),
    );
    body = Container(
      color: ColorPlate.back1,
      child: Column(
        children: <Widget>[
          body,
        ],
      ),
    );
    return body;
  }
}

class _TopIconTextButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color color2;
  final String title;
  final Function onTap;

  const _TopIconTextButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.title,
    this.color2: Colors.white,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconContainer = Container(
      margin: EdgeInsets.all(6),
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            color2,
            color,
          ],
          stops: [0.1, 0.8],
        ),
      ),
      child: Icon(
        icon,
      ),
    );
    Widget body = Column(
      children: <Widget>[
        iconContainer,
        Text(
          title,
          style: StandardTextStyle.small,
        )
      ],
    );
    body = Tapped(
      child: body,
      onTap: onTap,
    );
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        child: body,
      ),
    );
  }
}
