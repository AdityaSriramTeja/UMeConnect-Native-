/*
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamApi {
  static const apiKey = "bpt82p2yyb2a";
  static final client = StreamChatClient(apiKey, logLevel: Level.SEVERE);
}
*/

import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as log;
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

const streamKey = "bpt82p2yyb2a";

var logger = log.Logger();

extension StreamChatContext on BuildContext {
  /// Fetches the current user image.
  String? get currentUserImage => currentUser!.image;

  /// Fetches the current user.
  User? get currentUser => StreamChatCore.of(this).currentUser;
}
