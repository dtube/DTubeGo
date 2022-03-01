// currently unused

import 'package:dtube_go/ui/widgets/players/ChewiePlayer.dart';
import 'package:dtube_go/utils/GetAppDocDirectory.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class OnboardingVideo extends StatefulWidget {
  OnboardingVideo({Key? key, required this.videoname}) : super(key: key);
  String videoname;

  @override
  State<OnboardingVideo> createState() => _OnboardingVideoState();
}

class _OnboardingVideoState extends State<OnboardingVideo> {
  late VideoPlayerController _videocontroller;

  @override
  void initState() {
    _videocontroller =
        VideoPlayerController.asset('assets/videos/firstpage.mp4');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      //height: deviceHeight * 0.6,
      width: deviceWidth * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<String>(
          future: getFileUrl(widget.videoname),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.data != null) {
              //return BetterPlayer.file(snapshot.data!);
              return ChewiePlayer(
                  videoUrl: snapshot.data!,
                  looping: false,
                  autoplay: true,
                  localFile: true,
                  controls: false,
                  usedAsPreview: false,
                  allowFullscreen: false,
                  portraitVideoPadding: 50.0,
                  placeholderWidth: 100.w,
                  placeholderSize: 40.w,
                  videocontroller: _videocontroller);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
