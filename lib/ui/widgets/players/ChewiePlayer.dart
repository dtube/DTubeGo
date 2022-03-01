import 'package:chewie/chewie.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewiePlayer extends StatefulWidget {
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
  double placeholderWidth;
  double placeholderSize;

  ChewiePlayer({
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
    required this.placeholderSize,
    required this.placeholderWidth,
    Key? key,
  }) : super(key: key);

  @override
  _ChewiePlayerState createState() => _ChewiePlayerState();
}

class _ChewiePlayerState extends State<ChewiePlayer> {
  late ChewieController _chewiePlayerController;

  late Future<void> _future;
  late double aspectRatio;
  Future<void> initVideoPlayer() async {
    await widget.videocontroller.initialize();

    setState(() {
      aspectRatio = widget.videocontroller.value.size.width /
          widget.videocontroller.value.size.height;

      _chewiePlayerController = ChewieController(
          videoPlayerController: widget.videocontroller,
          aspectRatio: aspectRatio != null
              ? !(aspectRatio > 0.0)
                  ? 1
                  : aspectRatio
              : 1.77,
          autoPlay: widget.autoplay,
          looping: true,
          allowFullScreen: widget.allowFullscreen,
          allowMuting: true,
          showControls: widget.controls);
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
    widget.videocontroller.dispose();
    _chewiePlayerController.pause();
    _chewiePlayerController.dispose();
    super.dispose();
  }

  buildPlaceholderImage() {
    return Container(
      width: widget.placeholderWidth,
      child: AspectRatio(
        aspectRatio: 8 / 5,
        child: Center(
          child: DtubeLogoPulseWithSubtitle(
            size: widget.placeholderSize,
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
          return Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: aspectRatio < 1 ? widget.portraitVideoPadding : 0.0,
                  right: aspectRatio < 1 ? widget.portraitVideoPadding : 0.0),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: aspectRatio > 0.0 ? aspectRatio : 16 / 9,
                    child: widget.controls
                        ? Chewie(
                            controller: _chewiePlayerController,
                          )
                        : GestureDetector(
                            child: Chewie(
                              controller: _chewiePlayerController,
                            ),
                            onTap: () {
                              if (_chewiePlayerController.isPlaying) {
                                _chewiePlayerController.pause();
                              } else {
                                _chewiePlayerController.play();
                              }
                            }),
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
                      : SizedBox(height: 0),
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
