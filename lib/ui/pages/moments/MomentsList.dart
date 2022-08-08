// import 'dart:ffi';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/MomentsItem.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/MomentsView.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/controller/MomentsController.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/widgets/MomentsUpload.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/widgets/VideoPlayerMoments.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Bool2VoidFunc = void Function(bool);

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

  String? _defaultMomentsVotingWeight;
  String? _momentsUploadNSFW;
  String? _momentsUploadOC;
  String? _momentsUploadUnlist;
  String? _momentsUploadCrosspost;
  String? _momentsCustomTitle;
  String? _momentsCustomBody;
  String? _fixedDownvoteActivated;
  String? _fixedDownvoteWeight;
  bool volumeMute = false;
  late List<FeedItem> feedItems = [];

  late UserBloc _userBloc;
  double _currentVp = 0.0;

  Future<bool> getConfigValues() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    _defaultPostVotingWeight = await sec.getDefaultVote();
    _defaultPostVotingTip = await sec.getDefaultVoteTip();
    _defaultCommentsVotingWeight = await sec.getDefaultVoteComments();
    _defaultMomentsVotingWeight = await sec.getMomentVotingWeight();
    _momentsUploadNSFW = await sec.getMomentNSFW();
    _momentsUploadOC = await sec.getMomentOC();
    _momentsUploadUnlist = await sec.getMomentUnlist();
    _momentsUploadCrosspost = await sec.getMomentCrosspost();
    _momentsCustomTitle = await sec.getMomentTitle();
    _momentsCustomBody = await sec.getMomentBody();
    _fixedDownvoteActivated = await sec.getFixedDownvoteActivated();
    _fixedDownvoteWeight = await sec.getFixedDownvoteWeight();

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
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchDTCVPEvent());
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
            return BlocBuilder<UserBloc, UserState>(
                bloc: _userBloc,
                builder: (context, state) {
                  if (state is UserDTCVPLoadedState) {
                    _currentVp = state.vtBalance["v"]! + 0.0;
                  }

                  return BlocBuilder<FeedBloc, FeedState>(
                    builder: (context, state) {
                      if (state is FeedInitialState ||
                          state is FeedLoadingState && _feedItems.isEmpty) {
                        return buildLoading(context);
                      } else if (state is FeedLoadedState) {
                        if (state.feedType == widget.feedType) {
                          feedItems = state.feed;
                          if (moments.isEmpty) {
                            for (var f in state.feed) {
                              // if moment is <= 60 seconds
                              if (f.jsonString != null &&
                                  f.jsonString!.dur != "" &&
                                  int.parse(f.jsonString!.dur) <= 60 &&
                                  // AND if no negative video
                                  f.summaryOfVotes >= 0 &&
                                  // AND if no nsfw video
                                  f.jsonString!.nsfw == 0) {
                                moments.add(MomentsItem(
                                    VideoPlayerMoments(
                                      momentsController: momentsController,
                                      defaultCommentsVotingWeight:
                                          _defaultCommentsVotingWeight!,
                                      defaultPostsVotingWeight:
                                          _defaultPostVotingWeight!,
                                      defaultPostsVotingTip:
                                          _defaultPostVotingTip!,
                                      key: UniqueKey(),
                                      goingInBackgroundCallback:
                                          widget.goingInBackgroundCallback,
                                      goingInForegroundCallback:
                                          widget.goingInForegroundCallback,
                                      feedItem: f,
                                      momentsVotingWeight:
                                          _defaultMomentsVotingWeight!,
                                      momentsUploadNSFW: _momentsUploadNSFW!,
                                      momentsUploadOC: _momentsUploadOC!,
                                      momentsUploadUnlist:
                                          _momentsUploadUnlist!,
                                      momentsUploadCrosspost:
                                          _momentsUploadCrosspost!,
                                      currentVP: _currentVp,
                                      userBloc:
                                          BlocProvider.of<UserBloc>(context),
                                      fixedDownvoteActivated:
                                          _fixedDownvoteActivated == "true",
                                      fixedDownvoteWeight:
                                          double.parse(_fixedDownvoteWeight!),
                                    ),
                                    duration: Duration(
                                        seconds: f.jsonString!.dur != ""
                                            ? int.parse(f.jsonString!.dur) + 1
                                            : 5)));
                              }
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
                          defaultCommentsVotingWeight:
                              _defaultCommentsVotingWeight!,
                          defaultMomentsVotingWeight:
                              _defaultMomentsVotingWeight!,
                          momentsUploadNSFW: _momentsUploadNSFW!,
                          momentsUploadOC: _momentsUploadOC!,
                          momentsUploadUnlist: _momentsUploadUnlist!,
                          momentsUploadCrosspost: _momentsUploadCrosspost!,
                          momentsCustomTitle: _momentsCustomTitle!,
                          momentsCustomBody: _momentsCustomBody!,
                          controller: momentsController);
                    },
                  );
                });
          }
        });
  }

  Widget buildLoading(BuildContext context) {
    return Center(
      child: widget.feedType == "UserFeed"
          ? SizedBox(height: 0, width: 0)
          : DtubeLogoPulseWithSubtitle(
              subtitle: "loading moments..",
              size: 40.w,
            ),
    );
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
  String defaultMomentsVotingWeight;
  String momentsUploadNSFW;
  String momentsUploadOC;
  String momentsUploadUnlist;
  String momentsUploadCrosspost;
  String momentsCustomTitle;
  String momentsCustomBody;

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
      required this.defaultMomentsVotingWeight,
      required this.momentsUploadNSFW,
      required this.momentsUploadOC,
      required this.momentsUploadUnlist,
      required this.momentsUploadCrosspost,
      required this.controller,
      required this.momentsCustomTitle,
      required this.momentsCustomBody})
      : super(key: key);

  @override
  _MomentsContainerState createState() => _MomentsContainerState();
}

class _MomentsContainerState extends State<MomentsContainer> {
  String author = "";
  String title = "";
  int pos = 0;
  bool _volumeMute = false;

  void changeVolume() {
    setState(() {
      _volumeMute = !_volumeMute;
    });
  }

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<UserBloc>(context).add(FetchDTCVPEvent());
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
                padding: EdgeInsets.only(left: 2.w),
                width: 100.w,
                height: 25.h,
                child: Row(
                  children: [
                    MomentsUploadButton(
                        size: globalIconSizeMedium,
                        currentVT: state.vtBalance['v']! + 0.0,
                        defaultVotingWeight: double.parse(widget
                            .defaultMomentsVotingWeight), // todo make this dynamic
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
                        },
                        momentsVotingWeight: widget.defaultMomentsVotingWeight,
                        momentsUploadNSFW: widget.momentsUploadNSFW,
                        momentsUploadOC: widget.momentsUploadOC,
                        momentsUploadUnlist: widget.momentsUploadUnlist,
                        momentsUploadCrosspost: widget.momentsUploadCrosspost,
                        customMomentTitle: widget.momentsCustomTitle,
                        customMomentBody: widget.momentsCustomBody),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: OverlayText(text: "Create"),
                    )
                  ],
                ),
              );
            }
            return SizedBox(height: 0, width: 0);
          }),
        ],
      );
    } else {
      return Stack(
        children: [
          Center(
            child: AllMomentsSeenWidget(widget: widget),
          ),
          MomentsOverlay(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 2.w),
              width: 100.w,
              height: 25.h,
              child: Row(
                children: [
                  MomentsUpload(widget: widget, size: globalIconSizeMedium),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: OverlayText(text: "Create"),
                  )
                ],
              ))
        ],
      );
    }
  }
}

class AllMomentsSeenWidget extends StatelessWidget {
  const AllMomentsSeenWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final MomentsContainer widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Oops! You have seen all recent moments!",
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: MomentsUpload(widget: widget, size: globalIconSizeBig * 2),
          ),
          // FaIcon(FontAwesomeIcons.search, size: 20.w,),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              "Feel free to share a moment of your life by tapping on the big icon above!",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}

class MomentsUpload extends StatelessWidget {
  const MomentsUpload({
    Key? key,
    required this.widget,
    required this.size,
  }) : super(key: key);

  final MomentsContainer widget;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserDTCVPLoadedState) {
        return MomentsUploadButton(
            size: size,
            currentVT: state.vtBalance['v']! + 0.0,
            defaultVotingWeight: double.parse(
                widget.defaultPostsVotingWeight), // todo make this dynamic
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
            },
            momentsVotingWeight: widget.defaultMomentsVotingWeight,
            momentsUploadNSFW: widget.momentsUploadNSFW,
            momentsUploadOC: widget.momentsUploadOC,
            momentsUploadUnlist: widget.momentsUploadUnlist,
            momentsUploadCrosspost: widget.momentsUploadCrosspost,
            customMomentTitle: widget.momentsCustomTitle,
            customMomentBody: widget.momentsCustomBody);
      }
      return SizedBox(height: 0, width: 0);
    });
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
