import 'package:ume_connect/models/user.dart';

class Video {
  final String videoUrl;
  final User postedBy;
  final String caption;
  final String likes;
  final String comments;

  Video(this.videoUrl, this.postedBy, this.caption, this.likes, this.comments);
}
