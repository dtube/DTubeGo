import 'package:better_player/better_player.dart';
// import 'package:chewie/chewie.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class P2PSourcePlayerMobile extends StatefulWidget {
  final String videoUrl;
  final bool looping;
  final bool autoplay;
  final bool localFile;
  final bool controls;
  final bool usedAsPreview;
  final bool allowFullscreen;
  final double portraitVideoPadding;
  final bool? openInFullscreen;
  final VideoPlayerController videocontroller;
  final double placeholderWidth;
  final double placeholderSize;

  P2PSourcePlayerMobile({
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
  _P2PSourcePlayerMobileState createState() => _P2PSourcePlayerMobileState();
}

class _P2PSourcePlayerMobileState extends State<P2PSourcePlayerMobile> {
  late BetterPlayerController _P2PSourcePlayerMobileController;

  late Future<void> _future;
  late double aspectRatio;
  Future<void> initVideoPlayer() async {
    // await widget.videocontroller.initialize();

    setState(() {
      aspectRatio = widget.videocontroller.value.size.width /
          widget.videocontroller.value.size.height;
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          !widget.localFile
              ? BetterPlayerDataSourceType.network
              : BetterPlayerDataSourceType.file,
          widget.videoUrl);

      // _P2PSourcePlayerMobileController = ChewieController(
      //     videoPlayerController: widget.videocontroller,
      //     aspectRatio: !(aspectRatio > 0.0) ? 1 : aspectRatio,
      //     autoPlay: widget.autoplay,
      //     looping: true,
      //     allowFullScreen: widget.allowFullscreen,
      //     allowMuting: true,
      //     showControls: widget.controls);
      _P2PSourcePlayerMobileController = BetterPlayerController(
          BetterPlayerConfiguration(
              autoDetectFullscreenAspectRatio: true,
              fit: BoxFit.contain,
              autoDispose: true,
              autoPlay: widget.autoplay),
          betterPlayerDataSource: betterPlayerDataSource);
    });
  }

  @override
  void initState() {
    super.initState();
    // widget.videocontroller = !widget.localFile
    //     ? VideoPlayerController.network(widget.videoUrl)
    //     : VideoPlayerController.file(File(widget.videoUrl));
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    widget.videocontroller.dispose();
    _P2PSourcePlayerMobileController.pause();
    _P2PSourcePlayerMobileController.dispose();
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
          return
              // Center(
              //   child:
              Padding(
                  padding: EdgeInsets.only(
                      left: aspectRatio < 1 ? widget.portraitVideoPadding : 0.0,
                      right:
                          aspectRatio < 1 ? widget.portraitVideoPadding : 0.0),
                  child: !widget.usedAsPreview
                      ? AspectRatio(
                          aspectRatio:
                              aspectRatio > 0.0 ? aspectRatio : 16 / 11,
                          child: widget.controls
                              ? BetterPlayer(
                                  controller: _P2PSourcePlayerMobileController,
                                )
                              : GestureDetector(
                                  child: BetterPlayer(
                                    controller:
                                        _P2PSourcePlayerMobileController,
                                  ),
                                  onTap: () {
                                    if (_P2PSourcePlayerMobileController
                                        .isPlaying()!) {
                                      _P2PSourcePlayerMobileController.pause();
                                    } else {
                                      _P2PSourcePlayerMobileController.play();
                                    }
                                  }),
                        )
                      : aspectRatio > 1
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
                  //),
                  );
        } else {
          return buildPlaceholderImage();
        }
      },
    );
  }
}
