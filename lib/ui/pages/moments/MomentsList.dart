import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/MomentsItem.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/MomentsView.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/controller/MomentsController.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/widgets/MomentsUpload.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/widgets/VideoPlayerMoments.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/style/dtubeLoading.dart';

import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef ListOfString2VoidFunc = void Function(List<String>);

class MomentsList extends StatefulWidget {
  String feedType;
  VoidCallback goingInBackgroundCallback;
  VoidCallback goingInForegroundCallback;

  // define callback for tabcontainer to not rebuild the whole Container to avoid playback in background

  MomentsList({
    required this.feedType,
    // required this.momentsController,
    required this.goingInBackgroundCallback,
    required this.goingInForegroundCallback,
    Key? key,
  }) : super(key: key);

  @override
  State<MomentsList> createState() => _MomentsListState();
}

class _MomentsListState extends State<MomentsList> {
  late FeedBloc postBloc;

  final ScrollController _scrollController = ScrollController();
  late MomentsController momentsController;
  List<FeedItem> _feedItems = [];
  List<MomentsItem> moments = [];
  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;
  String? _defaultPostVotingWeight;
  String? _defaultPostVotingTip;
  String? _defaultCommentsVotingWeight;

  Future<bool> getConfigValues() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    _defaultPostVotingWeight = await sec.getDefaultVote();
    _defaultPostVotingTip = await sec.getDefaultVoteTip();
    _defaultCommentsVotingWeight = await sec.getDefaultVoteComments();
    if (_nsfwMode == null) {
      _nsfwMode = 'Blur';
    }
    if (_hiddenMode == null) {
      _hiddenMode = 'Hide';
    }
    return true;
  }

  @override
  void initState() {
    momentsController = new MomentsController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getConfigValues(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return buildLoading(context);
          } else {
            return BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedInitialState ||
                    state is FeedLoadingState && _feedItems.isEmpty) {
                  return buildLoading(context);
                } else if (state is FeedLoadedState) {
                  if (state.feedType == widget.feedType) {
                    if (moments.isEmpty) {
                      for (var f in state.feed) {
                        moments.add(MomentsItem(
                            BlocProvider<UserBloc>(
                              create: (context) =>
                                  UserBloc(repository: UserRepositoryImpl()),
                              child: VideoPlayerMoments(
                                momentsController: momentsController,
                                defaultCommentsVotingWeight:
                                    _defaultCommentsVotingWeight!,
                                defaultPostsVotingWeight:
                                    _defaultPostVotingWeight!,
                                defaultPostsVotingTip: _defaultPostVotingTip!,
                                key: UniqueKey(),
                                goingInBackgroundCallback:
                                    widget.goingInBackgroundCallback,
                                goingInForegroundCallback:
                                    widget.goingInForegroundCallback,
                                feedItem: f,
                              ),
                            ),
                            duration: Duration(
                                seconds: f.jsonString!.dur != ""
                                    ? int.parse(f.jsonString!.dur) + 1
                                    : 5)));
                      }
                    }
                  }
                  BlocProvider.of<FeedBloc>(context).isFetching = false;
                } else if (state is FeedErrorState) {
                  return buildErrorUi(state.message);
                }

                return MomentsContainer(
                    momentItems: moments,
                    feedType: widget.feedType,
                    appUser: _applicationUser!,
                    defaultPostsVotingTip: _defaultPostVotingTip!,
                    defaultPostsVotingWeight: _defaultPostVotingWeight!,
                    defaultCommentsVotingWeight: _defaultCommentsVotingWeight!,
                    controller: momentsController);
              },
            );
          }
        });
  }

  Widget buildLoading(BuildContext context) {
    return Center(
        child: widget.feedType == "UserFeed"
            ? SizedBox(height: 0, width: 0)
            : DTubeLogoPulse(size: 20.w));
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class MomentsContainer extends StatefulWidget {
  List<MomentsItem> momentItems;
  String defaultPostsVotingWeight;
  String defaultCommentsVotingWeight;
  String defaultPostsVotingTip;
  String appUser;

  String feedType;
  MomentsController controller;

  MomentsContainer(
      {Key? key,
      required this.momentItems,
      required this.feedType,
      required this.appUser,
      required this.defaultPostsVotingTip,
      required this.defaultPostsVotingWeight,
      required this.defaultCommentsVotingWeight,
      required this.controller})
      : super(key: key);

  @override
  _MomentsContainerState createState() => _MomentsContainerState();
}

class _MomentsContainerState extends State<MomentsContainer> {
  String author = "";
  String title = "";
  int pos = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(FetchDTCVPEvent());
  }

  @override
  void dispose() {
    widget.controller.pause();
    // widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.momentItems.length > 0) {
      return Stack(
        children: [
          MomentsView(
            momentsItems: widget.momentItems,
            repeat: true,
            controller: widget.controller,
            inline: false,
            onStoryShow: (momentsItem) {},
          ),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserDTCVPLoadedState) {
              return MomentsOverlay(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 5.w, top: 15.h),
                  width: 25.w,
                  height: 25.h,
                  child: MomentsUploadButton(
                      currentVT: state.vtBalance['v']! + 0.0,
                      defaultVotingWeight: double.parse(widget
                          .defaultPostsVotingWeight), // todo make this dynamic
                      clickedCallback: () {
                        // setState(() {
                        //   widget.momentsController.pause();
                        //   _videoController.pause();
                        // });
                      },
                      leaveDialogWithUploadCallback: () {
                        // setState(() {
                        //   widget.momentsController.pause();
                        //   _videoController.pause();
                        //   _momentUploading = true;
                        // });
                      },
                      leaveDialogWithoutUploadCallback: () {
                        //   widget.momentsController.play();
                        //   _videoController.play();
                        //   _momentUploading = false;
                      }));
            }
            return SizedBox(height: 0, width: 0);
          })
        ],
      );
    } else {
      return Stack(
        children: [
          Center(
            child: Text(
              "no moments found",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserDTCVPLoadedState) {
              return MomentsOverlay(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 5.w, top: 15.h),
                  width: 25.w,
                  height: 25.h,
                  child: MomentsUploadButton(
                      currentVT: state.vtBalance['v']! + 0.0,
                      defaultVotingWeight: double.parse(widget
                          .defaultPostsVotingWeight), // todo make this dynamic
                      clickedCallback: () {
                        // setState(() {
                        //   widget.momentsController.pause();
                        //   _videoController.pause();
                        // });
                      },
                      leaveDialogWithUploadCallback: () {
                        // setState(() {
                        //   widget.momentsController.pause();
                        //   _videoController.pause();
                        //   _momentUploading = true;
                        // });
                      },
                      leaveDialogWithoutUploadCallback: () {
                        //   widget.momentsController.play();
                        //   _videoController.play();
                        //   _momentUploading = false;
                      }));
            }
            return SizedBox(height: 0, width: 0);
          })
        ],
      );
    }
  }
}

class MomentsOverlay extends StatelessWidget {
  Alignment alignment;
  EdgeInsets padding;
  double width;
  double height;
  Widget child;
  Color? debugColor;
  MomentsOverlay(
      {Key? key,
      required this.alignment,
      required this.padding,
      required this.width,
      required this.height,
      required this.child,
      this.debugColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        color: debugColor,
        width: width,
        height: height,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
