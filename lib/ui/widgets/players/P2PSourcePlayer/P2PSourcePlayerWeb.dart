import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class P2PSourcePlayerWeb extends StatefulWidget {
  P2PSourcePlayerWeb({Key? key, required this.url, required this.height})
      : super(key: key);
  String url;

  double height;

  @override
  _P2PSourcePlayerWebState createState() => _P2PSourcePlayerWebState();
}

class _P2PSourcePlayerWebState extends State<P2PSourcePlayerWeb> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            videoFit: BoxFit.fitHeight,
            controls: const FlickPortraitControls(),
          ),
        ));
  }
}
