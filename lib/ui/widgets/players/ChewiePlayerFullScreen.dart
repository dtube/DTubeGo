import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';

import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/players/ChewiePlayer.dart';
import 'package:flutter/services.dart';
import 'package:overlay_dialog/overlay_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class BetterPlayerFullScreenPage extends StatefulWidget {
  final String link;

  const BetterPlayerFullScreenPage({Key? key, required this.link})
      : super(key: key);
  @override
  _BetterPlayerFullScreenPageState createState() =>
      _BetterPlayerFullScreenPageState(link);
}

class _BetterPlayerFullScreenPageState
    extends State<BetterPlayerFullScreenPage> {
  final String link;
  late ChewieController _chewiePlayerController;
  late VideoPlayerController _videocontroller;

  late Future<void> _future;
  bool full = false;
  final UniqueKey youtubeKey = UniqueKey();

  _BetterPlayerFullScreenPageState(this.link);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    AutoOrientation.landscapeAutoMode();
    _videocontroller = VideoPlayerController.network(widget.link);

    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    AutoOrientation.portraitAutoMode();

    _videocontroller
        .pause()
        .then((value) => Future.delayed(Duration(seconds: 10)));

    _videocontroller.dispose();

    _chewiePlayerController.pause();
    _chewiePlayerController.dispose();
    // _videocontroller = null;
    super.dispose();
  }

  Future<void> initVideoPlayer() async {
    await _videocontroller.initialize();

    setState(() {
      // BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      //   BetterPlayerDataSourceType.network,
      //   widget.link,
      //   bufferingConfiguration: BetterPlayerBufferingConfiguration(
      //     minBufferMs: Duration(seconds: 10).inMilliseconds,
      //     maxBufferMs: Duration(seconds: 60).inMilliseconds,
      //   ),
      // );
      double aspectRatio = _videocontroller.value.size.width /
          _videocontroller.value.size.height;

      _chewiePlayerController = ChewieController(
        // BetterPlayerConfiguration(
        //   fullScreenByDefault: true,
        //   autoDetectFullscreenDeviceOrientation: true,
        //   controlsConfiguration: BetterPlayerControlsConfiguration(
        //       enablePlayPause: true,
        //       enableSkips: false,
        //       showControlsOnInitialize: false,
        //       enableFullscreen: true),
        //   autoPlay: true,
        //   autoDispose: true,
        //   aspectRatio: aspectRatio,
        // ),
        // betterPlayerDataSource: betterPlayerDataSource,
        videoPlayerController: _videocontroller,
        autoPlay: true,
        looping: true,
      );
    });
  }

  buildPlaceholderImage() {
    return Container(
      width: 120.w,
      child: AspectRatio(
        aspectRatio: 8 / 5,
        child: Center(
          child: DtubeLogoPulseWithSubtitle(
            size: 20.h,
            subtitle: "loading video...",
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
            double _aspectRatio = _videocontroller.value.size.width /
                _videocontroller.value.size.height;
            return Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _aspectRatio,
                      child: Chewie(
                        controller: _chewiePlayerController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          onPressed: () async {
                            _videocontroller.pause();
                            _chewiePlayerController.pause();
                            await Future.delayed(Duration(seconds: 2));
                            // _videocontroller.pause();
                            // _videocontroller.//Navigator.pop(context);
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                            AutoOrientation.portraitAutoMode();
                            // _betterPlayerController.pause();
                            // _betterPlayerController.dispose();
                            // _videocontroller.dispose();

                            DialogHelper().hide(context);
                          },
                          child: FaIcon(FontAwesomeIcons.arrowLeft)),
                    ),
                  ],
                ));
          } else {
            return buildPlaceholderImage();
          }
        });
  }
}
