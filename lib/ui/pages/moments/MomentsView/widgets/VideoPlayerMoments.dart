import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/ui/pages/moments/MomentsList.dart';
import 'package:dtube_togo/ui/pages/moments/MomentsView/controller/MomentsController.dart';
import 'package:dtube_togo/ui/pages/moments/MomentsView/widgets/MomentsUpload.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerMoments extends StatefulWidget {
  //final String link;
  final FeedItem feedItem;
  MomentsController parentStoryController;
  VoidCallback goingInBackgroundCallback;
  VoidCallback goingInForegroundCallback;

  VideoPlayerMoments({
    Key? key, //required this.link,
    required this.feedItem,
    required this.parentStoryController,
    required this.goingInBackgroundCallback,
    required this.goingInForegroundCallback,
  }) : super(key: key);
  @override
  _VideoPlayerMomentsState createState() => _VideoPlayerMomentsState();
}

class _VideoPlayerMomentsState extends State<VideoPlayerMoments> {
  late VideoPlayerController _videoController;
  @override
  void initState() {
    super.initState();
    widget.parentStoryController.pause();
    _videoController = VideoPlayerController.network(widget.feedItem.videoUrl)
      ..initialize().then((_) {
        _videoController.play();
        widget.parentStoryController.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    widget.parentStoryController.pause();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Stack(
          children: [
            _videoController.value.isInitialized
                ? GestureDetector(
                    onLongPressStart: (details) {
                      widget.parentStoryController.pause();
                      _videoController.pause();
                    },
                    onLongPressEnd: (details) {
                      widget.parentStoryController.play();
                      _videoController.play();
                    },
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.centerLeft,
              heightFactor: 1,
              child: Container(
                child: GestureDetector(onTap: () {
                  widget.parentStoryController.previous();
                }),
                width: 30,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              heightFactor: 1,
              child: Container(
                child: GestureDetector(onTap: () {
                  widget.parentStoryController.next();
                }),
                width: 30,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Container(
                  height: 10.h,
                  child: GestureDetector(
                    onTap: () {
                      //widget.parentStoryController.pause();
                      widget.goingInBackgroundCallback();
                      navigateToUserDetailPage(context, widget.feedItem.author,
                          widget.goingInForegroundCallback);
                    },
                    child: AccountAvatarBase(
                        username: widget.feedItem.author,
                        avatarSize: 10.h,
                        showVerified: true,
                        showName: true,
                        width: 60.w),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.externalLinkAlt),
                    onPressed: () {
                      // widget.parentStoryController.pause();
                      widget.goingInBackgroundCallback();
                      navigateToPostDetailPage(
                          context,
                          widget.feedItem.author,
                          widget.feedItem.link,
                          "none",
                          false,
                          widget.goingInForegroundCallback);
                    },
                  )),
            ),
            MomentsOverlay(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 5.w, top: 15.h),
                width: 25.w,
                height: 25.h,
                child: MultiBlocProvider(
                    providers: [
                      BlocProvider<UserBloc>(
                        create: (BuildContext context) =>
                            UserBloc(repository: UserRepositoryImpl())
                              ..add(FetchDTCVPEvent()),
                      ),
                    ],
                    child: MomentsUploadButton(
                        defaultVotingWeight:
                            double.parse("25"), // todo make this dynamic
                        clickedCallBack: () {
                          widget.parentStoryController.pause();
                        },
                        leaveDialogCallBack: () {
                          widget.parentStoryController.play();
                        })))
          ],
        ),
      ),
    );
  }
}
