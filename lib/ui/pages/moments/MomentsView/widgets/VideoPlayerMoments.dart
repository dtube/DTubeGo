import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/Comments/CommentDialog.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/controller/MomentsController.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerMoments extends StatefulWidget {
  //final String link;
  final FeedItem feedItem;
  MomentsController momentsController;
  VoidCallback goingInBackgroundCallback;
  VoidCallback goingInForegroundCallback;
  String defaultPostsVotingWeight;
  String defaultPostsVotingTip;
  String defaultCommentsVotingWeight;

  String momentsVotingWeight;
  String momentsUploadNSFW;
  String momentsUploadOC;
  String momentsUploadUnlist;
  String momentsUploadCrosspost;
  double currentVP;

  UserBloc userBloc;

  VideoPlayerMoments(
      {Key? key, //required this.link,
      required this.feedItem,
      required this.momentsController,
      required this.goingInBackgroundCallback,
      required this.goingInForegroundCallback,
      required this.defaultCommentsVotingWeight,
      required this.defaultPostsVotingTip,
      required this.defaultPostsVotingWeight,
      required this.momentsVotingWeight,
      required this.momentsUploadNSFW,
      required this.momentsUploadOC,
      required this.momentsUploadUnlist,
      required this.momentsUploadCrosspost,
      required this.userBloc,
      required this.currentVP})
      : super(key: key);
  @override
  _VideoPlayerMomentsState createState() => _VideoPlayerMomentsState();
}

class _VideoPlayerMomentsState extends State<VideoPlayerMoments> {
  late VideoPlayerController _videoController;

  late bool _votingDirection;

  late bool _showVotingBars;

  late bool _showCommentInput;

  TextEditingController _replyController = new TextEditingController();

  late bool _momentUploading;

  @override
  void initState() {
    super.initState();

    _votingDirection = true;
    _showVotingBars = false;

    _showCommentInput = false;
    _momentUploading = false;

    widget.momentsController.pause();
    _videoController = VideoPlayerController.network(widget.feedItem.videoUrl)
      ..initialize().then((_) {
        _videoController.play();
        widget.momentsController.play();
        setState(() {});
      });
    BlocProvider.of<IPFSUploadBloc>(context).add(IPFSUploaderInitState());
  }

  @override
  void dispose() {
    widget.momentsController.pause();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('moments' + widget.feedItem.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage < 1) {
          _videoController.pause();
          widget.momentsController.pause();
        }
        if (visiblePercentage > 90) {
          _videoController.play();
          widget.momentsController.play();
        }
      },
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Stack(
            children: [
              GestureDetector(
                onLongPressStart: (details) {
                  widget.momentsController.pause();
                  _videoController.pause();
                },
                onLongPressEnd: (details) {
                  widget.momentsController.play();
                  _videoController.play();
                },
                onHorizontalDragEnd: (DragEndDetails details) {
                  if (details.primaryVelocity != null &&
                      details.primaryVelocity! > 0) {
                    widget.momentsController.previous();
                  } else if (details.primaryVelocity != null &&
                      details.primaryVelocity! < 0) {
                    widget.momentsController.next();
                  }
                },
                child: _videoController.value.isInitialized
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                      )
                    : Center(child: Container(height: 100.h, width: 100.w)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                heightFactor: 1,
                child: Container(
                  child: GestureDetector(onTap: () {
                    widget.momentsController.previous();
                  }),
                  width: 30,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                heightFactor: 1,
                child: Container(
                  child: GestureDetector(onTap: () {
                    widget.momentsController.next();
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
                        navigateToUserDetailPage(
                            context,
                            widget.feedItem.author,
                            widget.goingInForegroundCallback);
                      },
                      child: AccountAvatarBase(
                        username: widget.feedItem.author,
                        avatarSize: 10.h,
                        showVerified: true,
                        showName: true,
                        width: 60.w,
                        height: 10.h,
                      ),
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
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Container(
                    height: 20.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!widget.feedItem.alreadyVoted!) {
                              setState(() {
                                widget.momentsController.pause();
                                _videoController.pause();
                              });
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    MultiBlocProvider(
                                  providers: [
                                    BlocProvider<PostBloc>(
                                        create: (context) => PostBloc(
                                            repository: PostRepositoryImpl())),
                                    BlocProvider<UserBloc>(
                                        create: (context) => UserBloc(
                                            repository: UserRepositoryImpl())),
                                  ],
                                  child: VotingDialog(
                                    txBloc: BlocProvider.of<TransactionBloc>(
                                        context),
                                    defaultVote: double.parse(
                                        widget.momentsVotingWeight),
                                    defaultTip: double.parse(
                                        widget.defaultPostsVotingTip),
                                    author: widget.feedItem.author,
                                    link: widget.feedItem.link,
                                    downvote: false,
                                    //currentVT: state.vtBalance['v']! + 0.0,
                                    isPost: true,
                                    okCallback: () {
                                      setState(() {
                                        widget.momentsController.play();
                                        _videoController.play();
                                      });
                                    },
                                    cancelCallback: () {
                                      setState(() {
                                        widget.momentsController.play();
                                        _videoController.play();
                                      });
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          child: ShadowedIcon(
                            icon: FontAwesomeIcons.thumbsUp,
                            color: widget.feedItem.alreadyVoted! &&
                                    widget.feedItem.alreadyVotedDirection!
                                ? globalRed
                                : Colors.white,
                            shadowColor: Colors.black,
                            size: 8.w,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!widget.feedItem.alreadyVoted!) {
                              setState(() {
                                widget.momentsController.pause();
                                _videoController.pause();
                              });

                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    MultiBlocProvider(
                                  providers: [
                                    BlocProvider<PostBloc>(
                                        create: (context) => PostBloc(
                                            repository: PostRepositoryImpl())),
                                    BlocProvider<UserBloc>(
                                        create: (context) => UserBloc(
                                            repository: UserRepositoryImpl())),
                                  ],
                                  child: VotingDialog(
                                    txBloc: BlocProvider.of<TransactionBloc>(
                                        context),
                                    defaultVote: double.parse(
                                        widget.momentsVotingWeight),
                                    defaultTip: double.parse(
                                        widget.defaultPostsVotingTip),
                                    author: widget.feedItem.author,
                                    link: widget.feedItem.link,
                                    downvote: true,
                                    //currentVT: state.vtBalance['v']! + 0.0,
                                    isPost: true,
                                    okCallback: () {
                                      setState(() {
                                        widget.momentsController.play();
                                        _videoController.play();
                                      });
                                    },
                                    cancelCallback: () {
                                      setState(() {
                                        widget.momentsController.play();
                                        _videoController.play();
                                      });
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          child: ShadowedIcon(
                            icon: FontAwesomeIcons.flag,
                            color: widget.feedItem.alreadyVoted! &&
                                    !widget.feedItem.alreadyVotedDirection!
                                ? globalRed
                                : Colors.white,
                            shadowColor: Colors.black,
                            size: 8.w,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.momentsController.pause();
                              _videoController.pause();
                            });
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  BlocProvider<UserBloc>(
                                create: (context) =>
                                    UserBloc(repository: UserRepositoryImpl()),
                                child: CommentDialog(
                                  txBloc:
                                      BlocProvider.of<TransactionBloc>(context),
                                  originAuthor: widget.feedItem.author,
                                  originLink: widget.feedItem.link,
                                  defaultCommentVote: double.parse(
                                      widget.defaultCommentsVotingWeight),
                                  okCallback: () {
                                    setState(() {
                                      widget.momentsController.play();
                                      _videoController.play();
                                    });
                                  },
                                  cancelCallback: () {
                                    setState(() {
                                      widget.momentsController.play();
                                      _videoController.play();
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: ShadowedIcon(
                            icon: FontAwesomeIcons.comment,
                            color: Colors.white,
                            shadowColor: Colors.black,
                            size: 8.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
