import 'package:flutter/material.dart';
import 'package:ume_connect/style/style.dart';

class UserDetailPage extends StatefulWidget {
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    var userHead = Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.5,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              'Information',
              style: StandardTextStyle.big,
            ),
          ),
        ),
      ],
    );
    Widget body = ListView(
      padding: EdgeInsets.only(
        bottom: 80 + MediaQuery.of(context).padding.bottom,
      ),
      children: <Widget>[
        userHead,
        _UserInfoRow(
          title: 'Display name',
          rightIcon: Text(
            'Billy',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'Username',
          rightIcon: Text(
            'Billy@UMeConnect',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'Pronouns',
          rightIcon: Text(
            'He/Him',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'age',
          rightIcon: Text(
            '18',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'Hobbies',
          rightIcon: Text(
            'eat, sleep, work',
            style: StandardTextStyle.small,
          ),
        ),
        _UserInfoRow(
          title: 'bio',
          rightIcon: Text(
            'This is my mega social media app',
            style: StandardTextStyle.small,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.yellow,
          ),
          onPressed: () {},
          child: Text('Save Changes'),
        )
      ],
    );
    body = Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: body,
      ),
    );
    return Scaffold(
      body: Container(
        color: ColorPlate.back1,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _UserInfoRow extends StatelessWidget {
  _UserInfoRow({
    this.icon,
    this.title,
    this.rightIcon,
    this.onTap,
  });
  final Widget? icon;
  final Widget? rightIcon;
  final String? title;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    Widget iconImg = Container(
      height: 24,
      width: 24,
      child: icon,
    );

    Widget row = Container(
      height: 48,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border(
          bottom: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        children: <Widget>[
          icon != null ? iconImg : Container(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                title!,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: rightIcon ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
          ),
        ],
      ),
    );

    return row;
  }
}
