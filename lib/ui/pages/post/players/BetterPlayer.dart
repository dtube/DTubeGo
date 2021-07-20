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
  final bool usedAsPreview;

  BP({
    required this.videoUrl,
    required this.looping,
    required this.autoplay,
    required this.localFile,
    required this.controls,
    required this.usedAsPreview,
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
    print("test");
    setState(() {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        !widget.localFile
            ? BetterPlayerDataSourceType.network
            : BetterPlayerDataSourceType.file,
        widget.videoUrl,
      );
      double aspectRatio = _videocontroller.value.size.width /
          _videocontroller.value.size.height;

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
            aspectRatio: aspectRatio,
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
        if (snapshot.connectionState == ConnectionState.done) {
          double _aspectRatio = _videocontroller.value.size.width /
              _videocontroller.value.size.height;
          return Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: _aspectRatio < 1 ? 50.0 : 0.0,
                  right: _aspectRatio < 1 ? 50.0 : 0.0),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _aspectRatio,
                    child: BetterPlayer(
                      controller: _betterPlayerController,
                    ),
                  ),
                  widget.usedAsPreview
                      ? _aspectRatio > 1
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 8, 30, 8),
                                  child: Text(
                                    "Hint: preview of landscape videos could be wrong oriented.\nBut the upload will usually be fine!",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(height: 0)
                      : SizedBox(height: 0)
                ],
              ),
            ),
          );
        } else {
          return buildPlaceholderImage();
        }
      },
    );
  }
}
