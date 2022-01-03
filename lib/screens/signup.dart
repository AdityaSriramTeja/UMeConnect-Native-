import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ume_connect/provider/googlesignIn.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Login"),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 13,
                ),
                Text(
                  "UMe Connect",
                  style: GoogleFonts.pacifico(
                      textStyle: TextStyle(
                          color: Colors.blue,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.width / 5)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(double.infinity, 50)),
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.blue,
                  ),
                  label: Text(
                    "Login with google",
                  ),
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);

                    provider.googleLogin();
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Text(
          "Developed By Aditya Sriramteja Chilukuri",
          style: GoogleFonts.inconsolata(
              textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.width / 20)),
        ));
  }
}
