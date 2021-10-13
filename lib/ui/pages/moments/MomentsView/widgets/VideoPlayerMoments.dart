import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
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
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Stack(
          children: [
            _videoController.value.isInitialized
                ? GestureDetector(
                    onLongPressStart: (details) {
                      widget.momentsController.pause();
                      _videoController.pause();
                    },
                    onLongPressEnd: (details) {
                      widget.momentsController.play();
                      _videoController.play();
                    },
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                  )
                : Container(),
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
                      navigateToUserDetailPage(context, widget.feedItem.author,
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
                          setState(() {
                            widget.momentsController.pause();
                            _videoController.pause();
                            if (_showVotingBars && _votingDirection) {
                              _showVotingBars = false;
                            } else if (_showVotingBars && !_votingDirection) {
                              _votingDirection = true;
                            } else if (!_showVotingBars) {
                              _showCommentInput = false;
                              _showVotingBars = true;
                              _votingDirection = true;
                            }
                          });
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
                          setState(() {
                            widget.momentsController.pause();
                            _videoController.pause();
                            if (_showVotingBars && _votingDirection) {
                              _votingDirection = false;
                            } else if (!_showVotingBars) {
                              _showCommentInput = false;
                              _showVotingBars = true;
                              _votingDirection = false;
                            } else if (_showVotingBars && !_votingDirection) {
                              _showVotingBars = false;
                            }
                          });
                        },
                        child: ShadowedIcon(
                          icon: FontAwesomeIcons.thumbsDown,
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
                            if (!_showCommentInput) {
                              _showCommentInput = true;
                              _showVotingBars = false;
                            } else {
                              _showCommentInput = false;
                            }
                          });
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
            Visibility(
              visible: _showVotingBars,
              child: AspectRatio(
                aspectRatio: 5 / 8,
                child: Stack(
                  children: [
                    GestureDetector(
                      child: Container(
                        color: Colors.transparent,
                      ),
                      onTap: () {
                        setState(() {
                          _showVotingBars = false;
                          widget.momentsController.play();
                          _videoController.play();
                        });
                      },
                    ),
                    AspectRatio(
                      aspectRatio: 8 / 5,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: Colors.black.withAlpha(85),
                          child: VotingSliderStandalone(
                            defaultVote:
                                double.parse(widget.defaultPostsVotingWeight),
                            defaultTip:
                                double.parse(widget.defaultPostsVotingTip),
                            author: widget.feedItem.author,
                            link: widget.feedItem.link,
                            downvote: !_votingDirection,
                            currentVT: widget.currentVP,
                            isPost: true,
                            sendCallback: () {
                              widget.momentsController.play();
                              _videoController.play();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: _showCommentInput,
                child: AspectRatio(
                  aspectRatio: 5 / 8,
                  child: Stack(
                    children: [
                      GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                        ),
                        onTap: () {
                          setState(() {
                            _showCommentInput = false;
                            widget.momentsController.play();
                            _videoController.play();
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: Colors.black.withAlpha(85),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 80.w, // TODO: make this dynamic
                                child: Padding(
                                  padding: EdgeInsets.all(5.w),
                                  child: TextField(
                                    //key: UniqueKey(),
                                    autofocus: _showCommentInput,
                                    cursorColor: globalRed,
                                    controller: _replyController,
                                    maxLines: 4,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(5.w),
                                  child: InputChip(
                                    onPressed: () {
                                      UploadData _uploadData = new UploadData(
                                        link: "",
                                        parentAuthor: widget.feedItem.author,
                                        parentPermlink: widget.feedItem.link,
                                        title: "",
                                        description:
                                            _replyController.value.text,
                                        tag: "",
                                        vpPercent: double.parse(
                                            widget.defaultCommentsVotingWeight),
                                        vpBalance: widget.currentVP.floor(),
                                        burnDtc: 0,
                                        dtcBalance:
                                            0, // TODO promoted comment implementation missing
                                        isPromoted: false,
                                        duration: "",
                                        thumbnailLocation: "",
                                        localThumbnail: false,
                                        videoLocation: "",
                                        localVideoFile: false,
                                        originalContent: false,
                                        nSFWContent: false,
                                        unlistVideo: false,
                                        isEditing: false,
                                        videoSourceHash: "",
                                        video240pHash: "",
                                        video480pHash: "",
                                        videoSpriteHash: "",
                                        thumbnail640Hash: "",
                                        thumbnail210Hash: "",
                                        uploaded: false,
                                        crossPostToHive: false,
                                      );

                                      BlocProvider.of<TransactionBloc>(context)
                                          .add(SendCommentEvent(_uploadData));
                                      setState(() {
                                        _showCommentInput = false;
                                        _replyController.text = '';
                                        widget.momentsController.play();
                                        _videoController.play();
                                      });
                                    },
                                    label: FaIcon(FontAwesomeIcons.paperPlane),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
