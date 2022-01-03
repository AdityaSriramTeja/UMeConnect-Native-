import 'package:ume_connect/models/user.dart';
import 'package:ume_connect/models/videos.dart';

User currentUser = User('naruto');
User user1 = User('sasuke');
User user2 = User('sakura');

//fetch video data from firebase and send it to UserVideo.
final List<Video> videos = [
  Video("https://static.ybhospital.net/test-video-6.mp4", user1, 'caption', '3',
      '12'),
  Video("https://static.ybhospital.net/test-video-1.mp4", user2, 'caption2345',
      '200', '4'),
  Video("https://static.ybhospital.net/test-video-2.mp4", currentUser,
      'caption6543', '3000', '6'),
];
