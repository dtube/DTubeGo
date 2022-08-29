import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer/P2PSourcePlayerMobile.dart';
import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer/P2PSourcePlayerWeb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class P2PSourcePlayer extends StatelessWidget {
  P2PSourcePlayer({
    Key? key,
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
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return P2PSourcePlayerWeb(
          url: videoUrl, height: placeholderWidth / 16 * 9);
    } else {
      return P2PSourcePlayerMobile(
        videoUrl: videoUrl,
        autoplay: true,
        looping: false,
        localFile: false,
        controls: true,
        usedAsPreview: false,
        allowFullscreen: true,
        portraitVideoPadding: 33.w,
        videocontroller: videocontroller,
        placeholderWidth: placeholderWidth,
        placeholderSize: placeholderSize,
        // ),
      );
    }
  }
}
