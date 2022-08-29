import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer/P2SourcePlayer.dart';
import 'package:dtube_go/ui/widgets/players/YTplayerIframe.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/Random/randomGenerator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerWidget extends StatelessWidget {
  PlayerWidget({
    Key? key,
    required bool thumbnailTapped,
    required this.videoSource,
    required this.videoUrl,
    required VideoPlayerController bpController,
    required YoutubePlayerController ytController,
    required this.placeholderSize,
    required this.placeholderWidth,
  })  : _thumbnailTapped = thumbnailTapped,
        _bpController = bpController,
        _ytController = ytController,
        super(key: key);

  final bool _thumbnailTapped;
  final String videoSource;
  final String videoUrl;
  final VideoPlayerController _bpController;
  final YoutubePlayerController _ytController;
  final double placeholderWidth;
  final double placeholderSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: _thumbnailTapped,
        child: (["sia", "ipfs"].contains(videoSource) && videoUrl != "")
            ?
            // AspectRatio(
            //     aspectRatio: 16 / 9,
            // child:
            P2PSourcePlayer(
                videoUrl: videoUrl,
                autoplay: true,
                looping: false,
                localFile: false,
                controls: true,
                usedAsPreview: false,
                allowFullscreen: true,
                portraitVideoPadding: 33.w,
                videocontroller: _bpController,
                placeholderWidth: placeholderWidth,
                placeholderSize: placeholderSize,
                // ),
              )
            : (videoSource == 'youtube' && videoUrl != "")
                ? YTPlayerIFrame(
                    videoUrl: videoUrl,
                    autoplay: true,
                    allowFullscreen: false,
                    controller: _ytController,
                  )
                : Text("no player detected"),
      ),
    );
  }
}

class ThumbnailWidget extends StatelessWidget {
  const ThumbnailWidget({
    Key? key,
    required bool thumbnailTapped,
    required this.blur,
    required this.thumbUrl,
  })  : _thumbnailTapped = thumbnailTapped,
        super(key: key);

  final bool _thumbnailTapped;
  final bool blur;
  final String thumbUrl;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_thumbnailTapped,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: blur
            ? ClipRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaY: 5,
                    sigmaX: 5,
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: thumbUrl,
                    errorWidget: (context, url, error) => DTubeLogo(
                      size: 50,
                    ),
                  ),
                ),
              )
            : globals.disableAnimations
                ? ThumbnailContainer(thumbUrl: thumbUrl)
                : Shimmer(
                    duration: Duration(seconds: 5),
                    interval: Duration(seconds: generateRandom(3, 15)),
                    color: globalAlmostWhite,
                    colorOpacity: 0.1,
                    child: ThumbnailContainer(thumbUrl: thumbUrl)),
      ),
    );
  }
}

class ThumbnailContainer extends StatelessWidget {
  const ThumbnailContainer({
    Key? key,
    required this.thumbUrl,
  }) : super(key: key);

  final String thumbUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: thumbUrl,
      fit: BoxFit.fitWidth,
      errorWidget: (context, url, error) => DTubeLogo(
        size: 50,
      ),
    );
  }
}
