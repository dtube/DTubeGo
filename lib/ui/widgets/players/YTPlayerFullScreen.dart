import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:overlay_dialog/overlay_dialog.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerFullScreenPage extends StatefulWidget {
  final String link;

  const YoutubePlayerFullScreenPage({Key? key, required this.link})
      : super(key: key);
  @override
  _YoutubePlayerFullScreenPageState createState() =>
      _YoutubePlayerFullScreenPageState(link);
}

class _YoutubePlayerFullScreenPageState
    extends State<YoutubePlayerFullScreenPage> {
  late YoutubePlayerController _controller;
  final String link;

  bool full = false;
  final UniqueKey youtubeKey = UniqueKey();

  _YoutubePlayerFullScreenPageState(this.link);

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.link,
      params: YoutubePlayerParams(
          showControls: false,
          showFullscreenButton: false,
          desktopMode: true,
          privacyEnhanced: true,
          useHybridComposition: true,
          autoPlay: true),
    );
    if (Device.orientation != Orientation.landscape) {
      AutoOrientation.landscapeAutoMode();
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.close();
    AutoOrientation.portraitAutoMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: YoutubePlayerControllerProvider(
                    controller: _controller,
                    child: YoutubePlayerIFrame(
                      aspectRatio: 16 / 9,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: IconButton(
                      onPressed: () {
                        DialogHelper().hide(context);
                        AutoOrientation.fullAutoMode();
                      },
                      icon: FaIcon(FontAwesomeIcons.arrowLeft)),
                ),
              ],
            ),
          ),
        ));
  }
}
