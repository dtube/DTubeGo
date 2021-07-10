// import 'package:chewie/chewie.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool controls;

  LocalVideoPlayer({
    required this.videoUrl,
    required this.controls,
    Key? key,
  }) : super(key: key);

  @override
  _LocalVideoPlayerState createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController _videocontroller;
  double _aspectRatio = 0.0;
  late Future<void> _future;

  Future<void> initVideoPlayer() async {
    await Future.delayed(Duration(seconds: 1));
    _videocontroller = VideoPlayerController.file(File(widget.videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _aspectRatio = _videocontroller.value.size.width /
              _videocontroller.value.size.height;
        });
      });
  }

  @override
  void initState() {
    super.initState();
    //  _future = initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _videocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: initVideoPlayer(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return _aspectRatio > 0.0
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: _aspectRatio < 1 ? 50.0 : 0.0,
                            right: _aspectRatio < 1 ? 50.0 : 0.0),
                        child: AspectRatio(
                          aspectRatio: _aspectRatio,
                          child: VideoPlayer(
                            _videocontroller,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
