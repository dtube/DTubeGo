import 'package:dtube_go/bloc/web3storage/web3storage_bloc.dart';
import 'package:dtube_go/bloc/web3storage/web3storage_bloc_full.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:share_plus/share_plus.dart';

import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/Comments/CommentDialog.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/controller/MomentsController.dart';
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

  double fixedDownvoteWeight;
  bool fixedDownvoteActivated;

  UserBloc userBloc;

  VideoPlayerMoments({
    Key? key, //required this.link,
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
    required this.currentVP,
    required this.fixedDownvoteActivated,
    required this.fixedDownvoteWeight,
  }) : super(key: key);
  @override
  _VideoPlayerMomentsState createState() => _VideoPlayerMomentsState();
}

class _VideoPlayerMomentsState extends State<VideoPlayerMoments> {
  late VideoPlayerController _videoController;

  late bool _votingDirection;

  late bool _showVotingBars;

  late bool _showCommentInput;
  bool _volumeMute = false;

  bool _showPauseIcon = false;

  TextEditingController _replyController = new TextEditingController();

  late bool _momentUploading;

  void setMomentSeen() async {
    await sec.addSeenMoments(
        widget.feedItem.author + "/" + widget.feedItem.link,
        widget.feedItem.ts.toString());
  }

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
    // BlocProvider.of<IPFSUploadBloc>(context).add(IPFSUploaderInitState());
    BlocProvider.of<Web3StorageBloc>(context).add(Web3StorageInitState());
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
          setMomentSeen();
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
                  setState(() {
                    _showPauseIcon = true;
                  });
                },
                onLongPressEnd: (details) {
                  widget.momentsController.play();
                  _videoController.play();
                  setState(() {
                    _showPauseIcon = false;
                  });
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
                          child: Stack(
                            children: [
                              VideoPlayer(_videoController),
                              _showPauseIcon
                                  ? Center(
                                      child: FaIcon(
                                      FontAwesomeIcons.pause,
                                      size: 30.w,
                                    ))
                                  : Container(),
                            ],
                          ),
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
                      child: Row(
                        children: [
                          AccountIconBase(
                            username: widget.feedItem.author,
                            avatarSize: 10.h,
                            showVerified: true,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: AccountNameBase(
                                username: widget.feedItem.author,
                                width: 50.w,
                                height: 10.h,
                                mainStyle:
                                    Theme.of(context).textTheme.headline4!,
                                subStyle:
                                    Theme.of(context).textTheme.bodyText1!),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 13.h, right: 2.w),
                  child: GestureDetector(
                    onTap: () {
                      if (!widget.feedItem.alreadyVoted!) {
                        setState(() {
                          widget.momentsController.pause();
                          _videoController.pause();
                        });

                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => MultiBlocProvider(
                            providers: [
                              BlocProvider<PostBloc>(
                                  create: (context) => PostBloc(
                                      repository: PostRepositoryImpl())),
                              BlocProvider<UserBloc>(
                                  create: (context) => UserBloc(
                                      repository: UserRepositoryImpl())),
                            ],
                            child: VotingDialog(
                              defaultVote:
                                  double.parse(widget.momentsVotingWeight),
                              defaultTip:
                                  double.parse(widget.defaultPostsVotingTip),
                              author: widget.feedItem.author,
                              link: widget.feedItem.link,
                              downvote: true,
                              postBloc: BlocProvider.of<PostBloc>(context),
                              txBloc: BlocProvider.of<TransactionBloc>(context),

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
                              fixedDownvoteActivated:
                                  widget.fixedDownvoteActivated,
                              fixedDownvoteWeight: widget.fixedDownvoteWeight,
                            ),
                          ),
                        );
                      }
                    },
                    child: ShadowedIcon(
                      visible: globals.keyPermissions.contains(5),
                      icon: FontAwesomeIcons.flag,
                      color: widget.feedItem.alreadyVoted! &&
                              !widget.feedItem.alreadyVotedDirection!
                          ? globalRed
                          : globalAlmostWhite,
                      shadowColor: Colors.black,
                      size: globalIconSizeMedium,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 2.w),
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
                                    defaultVote: double.parse(
                                        widget.momentsVotingWeight),
                                    postBloc:
                                        BlocProvider.of<PostBloc>(context),
                                    txBloc: BlocProvider.of<TransactionBloc>(
                                        context),
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
                                    fixedDownvoteActivated:
                                        widget.fixedDownvoteActivated,
                                    fixedDownvoteWeight:
                                        widget.fixedDownvoteWeight,
                                  ),
                                ),
                              );
                            }
                          },
                          child: ShadowedIcon(
                            visible: globals.keyPermissions.contains(5),
                            icon: FontAwesomeIcons.heart,
                            color: widget.feedItem.alreadyVoted! &&
                                    widget.feedItem.alreadyVotedDirection!
                                ? globalRed
                                : globalAlmostWhite,
                            shadowColor: Colors.black,
                            size: globalIconSizeMedium,
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
                            visible: globals.keyPermissions.contains(4),
                            icon: FontAwesomeIcons.comment,
                            color: globalAlmostWhite,
                            shadowColor: Colors.black,
                            size: globalIconSizeMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // widget.momentsController.pause();
                              // _videoController.pause();
                            });
                            Share.share('https://d.tube/#!/v/' +
                                widget.feedItem.author +
                                '/' +
                                widget.feedItem.link);
                          },
                          child: ShadowedIcon(
                            icon: FontAwesomeIcons.share,
                            color: globalAlmostWhite,
                            shadowColor: Colors.black,
                            size: globalIconSizeMedium,
                          ),
                        ),
                        GestureDetector(
                          child: ShadowedIcon(
                            visible: globals.keyPermissions.contains(5),
                            icon: FontAwesomeIcons.externalLinkAlt,
                            color: globalAlmostWhite,
                            shadowColor: Colors.black,
                            size: globalIconSizeMedium,
                          ),
                          onTap: () {
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 18.h, right: 2.w),
                  child: GestureDetector(
                    child: ShadowedIcon(
                      size: globalIconSizeMedium,
                      icon: _volumeMute
                          ? FontAwesomeIcons.volumeUp
                          : FontAwesomeIcons.volumeMute,
                      color: globalAlmostWhite,
                      shadowColor: Colors.black,
                    ),
                    onTap: () {
                      setState(() {
                        _volumeMute = !_volumeMute;
                        if (_volumeMute) {
                          _videoController.setVolume(0);
                        } else {
                          _videoController.setVolume(1);
                        }
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
