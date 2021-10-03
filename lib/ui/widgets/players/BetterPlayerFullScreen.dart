import 'package:auto_orientation/auto_orientation.dart';
import 'package:dtube_go/ui/widgets/players/BetterPlayer.dart';
import 'package:overlay_dialog/overlay_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  late YoutubePlayerController _controller;
  final String link;

  bool full = false;
  final UniqueKey youtubeKey = UniqueKey();

  _BetterPlayerFullScreenPageState(this.link);

  @override
  void initState() {
    // if (Device.orientation != Orientation.landscape) {
    //   AutoOrientation.landscapeAutoMode();
    // }

    super.initState();
  }

  @override
  void dispose() {
//    AutoOrientation.fullAutoMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            BP(
              videoUrl: link,
              looping: false,
              autoplay: true,
              localFile: false,
              controls: true,
              usedAsPreview: false,
              allowFullscreen: false,
              portraitVideoPadding: 0.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () {
                    //Navigator.pop(context);
                    DialogHelper().hide(context);
                  },
                  child: FaIcon(FontAwesomeIcons.arrowLeft)),
            ),
          ],
        ));
  }
}
