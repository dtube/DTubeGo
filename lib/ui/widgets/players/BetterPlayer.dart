import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
  final bool allowFullscreen;
  final double portraitVideoPadding;
  bool? openInFullscreen;
  VideoPlayerController videocontroller;

  BP({
    required this.videoUrl,
    required this.looping,
    required this.autoplay,
    required this.localFile,
    required this.controls,
    required this.usedAsPreview,
    required this.allowFullscreen,
    required this.portraitVideoPadding,
    this.openInFullscreen,
    required this.videocontroller,
    Key? key,
  }) : super(key: key);

  @override
  _BPState createState() => _BPState();
}

class _BPState extends State<BP> {
  late BetterPlayerController _betterPlayerController;
  // late VideoPlayerController _videocontroller;
  late Future<void> _future;
  late double aspectRatio;
  Future<void> initVideoPlayer() async {
    await widget.videocontroller.initialize();

    setState(() {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        !widget.localFile
            ? BetterPlayerDataSourceType.network
            : BetterPlayerDataSourceType.file,
        widget.videoUrl,
        bufferingConfiguration: BetterPlayerBufferingConfiguration(
          minBufferMs: Duration(seconds: 10).inMilliseconds,
          maxBufferMs: Duration(seconds: 60).inMilliseconds,
        ),
      );
      aspectRatio = widget.videocontroller.value.size.width /
          widget.videocontroller.value.size.height;

      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          fullScreenByDefault: widget.openInFullscreen != null
              ? widget.openInFullscreen!
              : false,
          autoDetectFullscreenDeviceOrientation: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
              enablePlayPause: true,
              enableSkips: false,
              showControlsOnInitialize: false,
              enableFullscreen: widget.allowFullscreen),
          autoPlay: widget.autoplay,
          autoDispose: true,
          aspectRatio: !(aspectRatio > 0.0) ? 1 : aspectRatio,
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    widget.videocontroller = !widget.localFile
        ? VideoPlayerController.network(widget.videoUrl)
        : VideoPlayerController.file(File(widget.videoUrl));
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    _betterPlayerController.pause();
    _betterPlayerController.dispose();
    widget.videocontroller.dispose();

    super.dispose();
  }

  buildPlaceholderImage() {
    return Container(
      width: 120.w,
      child: AspectRatio(
        aspectRatio: 8 / 5,
        child: Center(
          child: DtubeLogoPulseWithSubtitle(
            size: 40.w,
            subtitle: "loading video",
            // width: 100.w,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // double _aspectRatio = widget.videocontroller.value.size.width /
          //     widget.videocontroller.value.size.height;

          return Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: aspectRatio < 1 ? widget.portraitVideoPadding : 0.0,
                  right: aspectRatio < 1 ? widget.portraitVideoPadding : 0.0),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: aspectRatio > 0.0 ? aspectRatio : 16 / 9,
                    child: BetterPlayer(
                      controller: _betterPlayerController,
                    ),
                  ),
                  widget.usedAsPreview
                      ? aspectRatio > 1
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
