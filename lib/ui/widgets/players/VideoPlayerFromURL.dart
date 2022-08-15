import 'dart:io';

import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerFromURL extends StatefulWidget {
  VideoPlayerFromURL({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<VideoPlayerFromURL> createState() => _VideoPlayerFromURLState();
}

class _VideoPlayerFromURLState extends State<VideoPlayerFromURL> {
  late VideoPlayerController _videoController;
  late YoutubePlayerController _ytController;
  bool _thumbnailTapped = false;
  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/videos/firstpage.mp4');
    _ytController = YoutubePlayerController(
      initialVideoId: "jlTUhhHSX00",
      params: YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          desktopMode: kIsWeb ? true : !Platform.isIOS,
          privacyEnhanced: true,
          useHybridComposition: true,
          autoPlay: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state is PostLoadingState) {
        return DtubeLogoPulseWithSubtitle(
            subtitle: "Loading video..", size: 20.w);
      } else if (state is PostLoadedState) {
        _ytController = YoutubePlayerController(
          initialVideoId: state.post.videoUrl!,
          params: YoutubePlayerParams(
              showControls: true,
              showFullscreenButton: true,
              desktopMode: kIsWeb ? true : !Platform.isIOS,
              privacyEnhanced: true,
              useHybridComposition: true,
              autoPlay: true),
        );
        return InkWell(
          onTap: () {
            setState(() {
              _thumbnailTapped = true;
            });
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ThumbnailWidget(
                  thumbnailTapped: _thumbnailTapped,
                  blur: false,
                  thumbUrl: state.post.thumbUrl!),
              PlayerWidget(
                thumbnailTapped: _thumbnailTapped,
                bpController: _videoController,
                videoSource: state.post.videoSource,
                videoUrl: state.post.videoUrl!,
                ytController: _ytController,
                placeholderWidth: 100.w,
                placeholderSize: 40.w,
              ),
            ],
          ),
        );
      }
      return Container(
          height: 20.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DTubeLogo(size: 20.w),
              Center(
                child: Text(
                  "No video or supported video player detected :(",
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ));
    });
  }
}
