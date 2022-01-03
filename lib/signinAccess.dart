import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ume_connect/models/firebaseUser.dart';
import 'package:ume_connect/navigationContainer.dart';
import 'package:ume_connect/screens/signup.dart';

class SignInAccess extends StatelessWidget {
  const SignInAccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.hasError)
          return Center(
            child: Text("an error has occured"),
          );
        else if (snapshot.hasData) {
          firebaseuser = FirebaseAuth.instance.currentUser;
          firebaseuser!.reload();
          return NavigationContainer();
        } else
          return SignUp();
      },
    ));
  }
}
