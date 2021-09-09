import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerFullScreenPage extends StatefulWidget {
  final String link;
  final int time;

  const YoutubePlayerFullScreenPage(
      {Key? key, required this.link, required this.time})
      : super(key: key);
  @override
  _YoutubePlayerFullScreenPageState createState() =>
      _YoutubePlayerFullScreenPageState(link, time);
}

class _YoutubePlayerFullScreenPageState
    extends State<YoutubePlayerFullScreenPage> {
  late YoutubePlayerController _controller;
  final String link;
  final int time;
  bool full = false;
  final UniqueKey youtubeKey = UniqueKey();

  _YoutubePlayerFullScreenPageState(this.link, this.time);

  @override
  void initState() {
    print("link ${widget.link}");
    _controller = YoutubePlayerController(
      initialVideoId: widget.link,
      params: YoutubePlayerParams(
          showControls: false,
          showFullscreenButton: false,
          desktopMode: true,
          privacyEnhanced: true,
          useHybridComposition: true,
          startAt: Duration(seconds: time),
          autoPlay: true),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: YoutubePlayerControllerProvider(
                controller: _controller,
                child: YoutubePlayerIFrame(
                  aspectRatio: 16 / 9,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: FaIcon(FontAwesomeIcons.arrowLeft)),
            ),
          ],
        ));
  }
}
