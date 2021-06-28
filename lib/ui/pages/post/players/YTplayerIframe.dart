import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class YTPlayerIFrame extends StatefulWidget {
  const YTPlayerIFrame(
      {Key? key, required this.videoUrl, required this.autoplay})
      : super(key: key);

  final String videoUrl;
  final bool autoplay;

  @override
  _YTPlayerIFrameState createState() => _YTPlayerIFrameState();
}

class _YTPlayerIFrameState extends State<YTPlayerIFrame> {
  late YoutubePlayerController _controller;

//TextEditingController _seekToController;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoUrl,
      params: YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          desktopMode: true,
          privacyEnhanced: true,
          useHybridComposition: true,
          autoPlay: widget.autoplay),
    );

    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      print('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      print('Exited Fullscreen');
    };
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // _controller.dispose();
    _controller.close();
    // _idController.dispose();
    // _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _player = YoutubePlayerIFrame();

    return YoutubePlayerControllerProvider(
        // Passing controller to widgets below.
        controller: _controller,
        child: _player);
  }
}
