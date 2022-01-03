import 'package:flutter/material.dart';
import 'package:ume_connect/models/videos.dart';
import 'package:video_player/video_player.dart';

class VideoTile extends StatefulWidget {
  VideoTile(
      {Key? key,
      required this.videoUrl,
      required this.snappedPageIndex,
      required this.currentPage})
      : super(key: key);
  final String videoUrl;
  final int snappedPageIndex;
  final int currentPage;

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController _videoController;
  late Future _initilizeVideoPlayer;
  bool isVideoPlaying = true;
  @override
  void initState() {
    _videoController = VideoPlayerController.network(widget.videoUrl);
    _initilizeVideoPlayer = _videoController.initialize();
    _videoController.setLooping(true);

    _videoController.play();
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void pauseOrPlayVideo() {
    isVideoPlaying ? _videoController.pause() : _videoController.play();
    setState(() {
      isVideoPlaying = !isVideoPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    (widget.snappedPageIndex == widget.currentPage && isVideoPlaying)
        ? _videoController.play()
        : _videoController.pause();
    return Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: FutureBuilder(
            future: _initilizeVideoPlayer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                  onTap: () => {pauseOrPlayVideo()},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                            height: _videoController.value.size.height,
                            width: _videoController.value.size.width,
                            child: VideoPlayer(_videoController)),
                      ),
                      IconButton(
                          onPressed: () => {
                                _videoController.play(),
                              },
                          icon: Icon(Icons.play_arrow_outlined),
                          color: Colors.white
                              .withOpacity(isVideoPlaying ? 0 : 0.7),
                          iconSize: 100),
                    ],
                  ),
                );
              } else {
                //TODO add loading animation when the internet is slow
                return Container(color: Colors.pink);
              }
            },
          ),
        ));
  }
}
