import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BPMoments extends StatefulWidget {
  final String videoUrl;

  BPMoments({
    required this.videoUrl,
    Key? key,
  }) : super(key: key);

  @override
  _BPMomentsState createState() => _BPMomentsState();
}

class _BPMomentsState extends State<BPMoments> {
  late BetterPlayerController _betterPlayerController;
  late VideoPlayerController _videocontroller;
  late Future<void> _future;

  Future<void> initVideoPlayer() async {
    await _videocontroller.initialize();

    setState(() {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.videoUrl,
        bufferingConfiguration: BetterPlayerBufferingConfiguration(
          minBufferMs: Duration(seconds: 10).inMilliseconds,
          maxBufferMs: Duration(seconds: 60).inMilliseconds,
        ),
      );
      double aspectRatio = _videocontroller.value.size.width /
          _videocontroller.value.size.height;

      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          controlsConfiguration: BetterPlayerControlsConfiguration(
              showControls: false,
              enablePlayPause: true,
              enableSkips: false,
              showControlsOnInitialize: false,
              enableFullscreen: false),
          autoPlay: true,
          autoDispose: true,
          aspectRatio: aspectRatio,
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _videocontroller = VideoPlayerController.network(widget.videoUrl);
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _videocontroller.dispose();
    _betterPlayerController.pause();
    _betterPlayerController.dispose();
  }

  buildPlaceholderImage() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _videocontroller.value.size.width /
                _videocontroller.value.size.height,
            child: BetterPlayer(
              controller: _betterPlayerController,
            ),
          );
        } else {
          return buildPlaceholderImage();
        }
      },
    );
  }
}
