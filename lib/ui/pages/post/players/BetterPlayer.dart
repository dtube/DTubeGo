// import 'package:chewie/chewie.dart';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BP extends StatefulWidget {
  final String videoUrl;
  final bool looping;
  final bool autoplay;
  final bool localFile;
  final bool controls;

  BP({
    required this.videoUrl,
    required this.looping,
    required this.autoplay,
    required this.localFile,
    required this.controls,
    Key? key,
  }) : super(key: key);

  @override
  _BPState createState() => _BPState();
}

class _BPState extends State<BP> {
  late BetterPlayerController _betterPlayerController;
  late VideoPlayerController _videocontroller;
  late Future<void> _future;

  Future<void> initVideoPlayer() async {
    await _videocontroller.initialize();
    setState(() {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          !widget.localFile
              ? BetterPlayerDataSourceType.network
              : BetterPlayerDataSourceType.file,
          widget.videoUrl);

      _betterPlayerController = BetterPlayerController(
          BetterPlayerConfiguration(
            controlsConfiguration: BetterPlayerControlsConfiguration(
              //showControls: widget.controls,
              enablePlayPause: true,
              enableSkips: false,
              showControlsOnInitialize: false,
            ),
            autoPlay: widget.autoplay,
            autoDispose: true,
            aspectRatio: _videocontroller.value.size.width /
                _videocontroller.value.size.height,
          ),
          betterPlayerDataSource: betterPlayerDataSource);
    });
  }

  @override
  void initState() {
    super.initState();
    _videocontroller = !widget.localFile
        ? VideoPlayerController.network(widget.videoUrl)
        : VideoPlayerController.file(File(widget.videoUrl));
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _videocontroller.dispose();
    _betterPlayerController.dispose();
    _betterPlayerController.pause();
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
        if (snapshot.connectionState == ConnectionState.waiting)
          return buildPlaceholderImage();

        double _aspectRatio = _videocontroller.value.size.width /
            _videocontroller.value.size.height;
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
                left: _aspectRatio < 1 ? 50.0 : 0.0,
                right: _aspectRatio < 1 ? 50.0 : 0.0),
            child: AspectRatio(
              aspectRatio: _videocontroller.value.size.width /
                  _videocontroller.value.size.height,
              child: BetterPlayer(
                controller: _betterPlayerController,
              ),
            ),
          ),
        );
      },
    );
  }
}
