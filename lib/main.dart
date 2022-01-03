import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'package:flutter/services.dart';

import 'package:ume_connect/provider/googlesignIn.dart';

import 'package:ume_connect/signinAccess.dart';
import 'package:ume_connect/style/style.dart';

import 'api/stream_api.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = StreamChatClient(streamKey);
  await Firebase.initializeApp();
  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'UMe Connect',
        builder: (context, child) {
          return StreamChatCore(
            client: client,
            child: ChannelsBloc(
              child: UsersBloc(
                child: child!,
              ),
            ),
          );
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          hintColor: Colors.white,
          //  accentColor: Colors.white,
          primaryColor: ColorPlate.orange,
          primaryColorBrightness: Brightness.dark,
          scaffoldBackgroundColor: ColorPlate.back1,
          dialogBackgroundColor: ColorPlate.back2,
          textTheme: TextTheme(
            bodyText1: StandardTextStyle.normal,
          ),
        ),
        home: SignInAccess(),

        //home: AddVideo()
      ),
    );
  }
}
