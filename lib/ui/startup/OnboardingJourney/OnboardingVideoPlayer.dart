// currently unused

import 'package:dtube_go/ui/widgets/players/BetterPlayer.dart';
import 'package:dtube_go/utils/GetAppDocDirectory.dart';
import 'package:flutter/material.dart';

class OnboardingVideo extends StatelessWidget {
  OnboardingVideo({Key? key, required this.videoname}) : super(key: key);
  String videoname;

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
          future: getFileUrl(videoname),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.data != null) {
              //return BetterPlayer.file(snapshot.data!);
              return BP(
                videoUrl: snapshot.data!,
                looping: false,
                autoplay: true,
                localFile: true,
                controls: false,
                usedAsPreview: false,
                allowFullscreen: false,
                portraitVideoPadding: 50.0,
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
