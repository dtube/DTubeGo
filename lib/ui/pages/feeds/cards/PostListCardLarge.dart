import 'package:dtube_go/ui/pages/feeds/cards/widets/CollapsedDescription.dart';
import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'dart:io';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/Comments/CommentDialog.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/gifts/GiftDialog.dart';
import 'package:dtube_go/ui/widgets/tags/TagChip.dart';
import 'package:dtube_go/utils/randomGenerator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/ui/widgets/players/ChewiePlayer.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/ui/widgets/players/YTplayerIframe.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PostListCardLarge extends StatefulWidget {
  const PostListCardLarge(
      {Key? key,
      required this.blur,
      required this.thumbnailUrl,
      required this.title,
      required this.description,
      required this.author,
      required this.link,
      required this.publishDate,
      required this.duration,
      required this.dtcValue,
      required this.videoUrl,
      required this.videoSource,
      required this.alreadyVoted,
      required this.alreadyVotedDirection,
      required this.upvotesCount,
      required this.downvotesCount,
      required this.indexOfList,
      required this.mainTag,
      required this.oc,
      required this.defaultCommentVotingWeight,
      required this.defaultPostVotingWeight,
      required this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight})
      : super(key: key);

  final bool blur;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String author;
  final String link;
  final String publishDate;
  final Duration duration;
  final String dtcValue;
  final String videoUrl;
  final String videoSource;
  final bool alreadyVoted;
  final bool alreadyVotedDirection;
  final int upvotesCount;
  final int downvotesCount;
  final int indexOfList;
  final String mainTag;
  final bool oc;
  final String defaultCommentVotingWeight;
  final String defaultPostVotingWeight;
  final String defaultPostVotingTip;

  final String fixedDownvoteActivated;
  final String fixedDownvoteWeight;

  @override
  _PostListCardLargeState createState() => _PostListCardLargeState();
}

class _PostListCardLargeState extends State<PostListCardLarge> {
  double _avatarSize = 10.w;
  bool _thumbnailTapped = false;
  TextEditingController _replyController = new TextEditingController();
  TextEditingController _giftMemoController = new TextEditingController();
  TextEditingController _giftDTCController = new TextEditingController();

  late bool _showVotingBars;

  late bool _votingDirection; // true = upvote | false = downvote

  late bool _showCommentInput;
  late bool _showGiftInput;

  late UserBloc _userBloc;
  int _currentVp = 0;
  late VideoPlayerController _bpController;
  late YoutubePlayerController _ytController;
  @override
  void initState() {
    super.initState();
    _showVotingBars = false;
    _votingDirection = true;
    _showCommentInput = false;
    _showGiftInput = false;
    _userBloc = BlocProvider.of<UserBloc>(context);
    _bpController = VideoPlayerController.asset('assets/videos/firstpage.mp4');
    _ytController = YoutubePlayerController(
      initialVideoId: widget.videoUrl,
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
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('postlist-large' + widget.link),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;

        if (visiblePercentage < 1) {
          _ytController.pause();
          _bpController.pause();
          print("VISIBILITY OF " +
              widget.author +
              "/" +
              widget.link +
              "CHANGED TO " +
              visiblePercentage.toString());
        }
        if (visiblePercentage > 90) {
          _ytController.play();
          _bpController.play();
          print("VISIBILITY OF " +
              widget.author +
              "/" +
              widget.link +
              "CHANGED TO " +
              visiblePercentage.toString());
        }
      },
      child: kIsWeb
          ? WebPostData(
              thumbnailTapped: _thumbnailTapped,
              widget: widget,
              bpController: _bpController,
              ytController: _ytController,
              showVotingBars: _showVotingBars,
              userBloc: _userBloc,
              votingDirection: _votingDirection,
              showCommentInput: _showCommentInput,
              replyController: _replyController,
              showGiftInput: _showGiftInput,
              giftDTCController: _giftDTCController,
              giftMemoController: _giftMemoController,
              avatarSize: _avatarSize,
              thumbnailTappedCallback: () {
                setState(() {
                  _thumbnailTapped = true;
                });
              },
              votingCancelCallback: () {
                setState(() {
                  _showVotingBars = false;
                });
              },
              commentCancelCallback: () {
                setState(() {
                  _showCommentInput = false;
                  _replyController.text = '';
                });
              },
              giftCancelCallback: () {
                setState(() {
                  _showGiftInput = false;
                });
              },
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: MobilePostData(
                thumbnailTapped: _thumbnailTapped,
                widget: widget,
                bpController: _bpController,
                ytController: _ytController,
                showVotingBars: _showVotingBars,
                userBloc: _userBloc,
                votingDirection: _votingDirection,
                showCommentInput: _showCommentInput,
                replyController: _replyController,
                showGiftInput: _showGiftInput,
                giftDTCController: _giftDTCController,
                giftMemoController: _giftMemoController,
                avatarSize: _avatarSize,
                thumbnailTappedCallback: () {
                  setState(() {
                    _thumbnailTapped = true;
                  });
                },
                votingCancelCallback: () {
                  setState(() {
                    _showVotingBars = false;
                  });
                },
                commentCancelCallback: () {
                  setState(() {
                    _showCommentInput = false;
                    _replyController.text = '';
                  });
                },
                giftCancelCallback: () {
                  setState(() {
                    _showGiftInput = false;
                  });
                },
              ),
            ),
    );
  }
}

class MobilePostData extends StatelessWidget {
  MobilePostData({
    Key? key,
    required bool thumbnailTapped,
    required this.widget,
    required VideoPlayerController bpController,
    required YoutubePlayerController ytController,
    required bool showVotingBars,
    required UserBloc userBloc,
    required bool votingDirection,
    required bool showCommentInput,
    required TextEditingController replyController,
    required bool showGiftInput,
    required TextEditingController giftDTCController,
    required TextEditingController giftMemoController,
    required double avatarSize,
    required this.thumbnailTappedCallback,
    required this.votingCancelCallback,
    required this.commentCancelCallback,
    required this.giftCancelCallback,
  })  : _thumbnailTapped = thumbnailTapped,
        _bpController = bpController,
        _ytController = ytController,
        _showVotingBars = showVotingBars,
        _userBloc = userBloc,
        _votingDirection = votingDirection,
        _showCommentInput = showCommentInput,
        _replyController = replyController,
        _showGiftInput = showGiftInput,
        _giftDTCController = giftDTCController,
        _giftMemoController = giftMemoController,
        _avatarSize = avatarSize,
        super(key: key);

  final bool _thumbnailTapped;
  final PostListCardLarge widget;
  final VideoPlayerController _bpController;

  final YoutubePlayerController _ytController;
  final bool _showVotingBars;
  final UserBloc _userBloc;
  final bool _votingDirection;
  final bool _showCommentInput;
  final TextEditingController _replyController;
  final bool _showGiftInput;
  final TextEditingController _giftDTCController;
  final TextEditingController _giftMemoController;
  final double _avatarSize;
  VoidCallback thumbnailTappedCallback;
  VoidCallback votingCancelCallback;
  VoidCallback commentCancelCallback;
  VoidCallback giftCancelCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            thumbnailTappedCallback();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ThumbnailWidget(
                  thumbnailTapped: _thumbnailTapped, widget: widget),
              PlayerWidget(
                thumbnailTapped: _thumbnailTapped,
                bpController: _bpController,
                widget: widget,
                ytController: _ytController,
                placeholderWidth: 100.w,
                placeholderSize: 40.w,
              ),
              // VOTING DIALOG
              VotingDialogWidget(
                  showVotingBars: _showVotingBars,
                  userBloc: _userBloc,
                  votingDirection: _votingDirection,
                  widget: widget,
                  cancelCallback: () {
                    votingCancelCallback();
                  }),
              // COMMENT DIALOG
              CommentDialogWidget(
                showCommentInput: _showCommentInput,
                replyController: _replyController,
                userBloc: _userBloc,
                widget: widget,
                cancelCallback: () {
                  commentCancelCallback();
                },
              ),
              // GIFT DIALOG
              GiftDialogWidget(
                showGiftInput: _showGiftInput,
                giftDTCController: _giftDTCController,
                giftMemoController: _giftMemoController,
                widget: widget,
                cancelCallback: () {
                  giftCancelCallback();
                },
              ),
            ],
          ),
          //),
        ),
        PostInfoBaseRow(
          avatarSize: _avatarSize,
          widget: widget,
        ),
        FadeInDown(
          preferences:
              AnimationPreferences(offset: Duration(milliseconds: 500)),
          child: Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: PostInfoDetailsRow(
              widget: widget,
            ),
          ),
        ),
        SizedBox(height: 1.h),
      ],
    );
  }
}

// WEB VIEW
class WebPostData extends StatelessWidget {
  WebPostData({
    Key? key,
    required bool thumbnailTapped,
    required this.widget,
    required VideoPlayerController bpController,
    required YoutubePlayerController ytController,
    required bool showVotingBars,
    required UserBloc userBloc,
    required bool votingDirection,
    required bool showCommentInput,
    required TextEditingController replyController,
    required bool showGiftInput,
    required TextEditingController giftDTCController,
    required TextEditingController giftMemoController,
    required double avatarSize,
    required this.thumbnailTappedCallback,
    required this.votingCancelCallback,
    required this.commentCancelCallback,
    required this.giftCancelCallback,
  })  : _thumbnailTapped = thumbnailTapped,
        _bpController = bpController,
        _ytController = ytController,
        _showVotingBars = showVotingBars,
        _userBloc = userBloc,
        _votingDirection = votingDirection,
        _showCommentInput = showCommentInput,
        _replyController = replyController,
        _showGiftInput = showGiftInput,
        _giftDTCController = giftDTCController,
        _giftMemoController = giftMemoController,
        _avatarSize = avatarSize,
        super(key: key);

  final bool _thumbnailTapped;
  final PostListCardLarge widget;
  final VideoPlayerController _bpController;

  final YoutubePlayerController _ytController;
  final bool _showVotingBars;
  final UserBloc _userBloc;
  final bool _votingDirection;
  final bool _showCommentInput;
  final TextEditingController _replyController;
  final bool _showGiftInput;
  final TextEditingController _giftDTCController;
  final TextEditingController _giftMemoController;
  final double _avatarSize;
  VoidCallback thumbnailTappedCallback;
  VoidCallback votingCancelCallback;
  VoidCallback commentCancelCallback;
  VoidCallback giftCancelCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 80.w,
        height: 50.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                thumbnailTappedCallback();
              },
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  ThumbnailWidget(
                      thumbnailTapped: _thumbnailTapped, widget: widget),
                  PlayerWidget(
                    thumbnailTapped: _thumbnailTapped,
                    bpController: _bpController,
                    widget: widget,
                    ytController: _ytController,
                    placeholderWidth: 30.w,
                    placeholderSize: 20.w,
                  ),
                  // VOTING DIALOG
                  VotingDialogWidget(
                      showVotingBars: _showVotingBars,
                      userBloc: _userBloc,
                      votingDirection: _votingDirection,
                      widget: widget,
                      cancelCallback: () {
                        votingCancelCallback();
                      }),
                  // COMMENT DIALOG
                  CommentDialogWidget(
                    showCommentInput: _showCommentInput,
                    replyController: _replyController,
                    userBloc: _userBloc,
                    widget: widget,
                    cancelCallback: () {
                      commentCancelCallback();
                    },
                  ),
                  // GIFT DIALOG
                  GiftDialogWidget(
                    showGiftInput: _showGiftInput,
                    giftDTCController: _giftDTCController,
                    giftMemoController: _giftMemoController,
                    widget: widget,
                    cancelCallback: () {
                      giftCancelCallback();
                    },
                  ),
                ],
              ),
              //),
            ),
            PostInfoColumn(
              avatarSize: 10.h,
              widget: widget,
            ),
          ],
        ),
      ),
    );
  }
}

class PostInfoDetailsRow extends StatelessWidget {
  const PostInfoDetailsRow({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PostListCardLarge widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50.w,
              child: Text(
                '@${widget.author}',
                style: Theme.of(context).textTheme.bodyText2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Text(
                  '${widget.publishDate}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  ' - ' +
                      (widget.duration.inHours == 0
                          ? widget.duration.toString().substring(2, 7) + ' min'
                          : widget.duration.toString().substring(0, 7) + ' h'),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: 0.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${widget.dtcValue}',
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: EdgeInsets.only(left: 1.w),
                child: DTubeLogoShadowed(size: 5.w),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GiftDialogWidget extends StatelessWidget {
  GiftDialogWidget(
      {Key? key,
      required bool showGiftInput,
      required TextEditingController giftDTCController,
      required TextEditingController giftMemoController,
      required this.widget,
      required this.cancelCallback})
      : _showGiftInput = showGiftInput,
        _giftDTCController = giftDTCController,
        _giftMemoController = giftMemoController,
        super(key: key);

  final bool _showGiftInput;
  final TextEditingController _giftDTCController;
  final TextEditingController _giftMemoController;
  final PostListCardLarge widget;

  VoidCallback cancelCallback;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: _showGiftInput,
        child: AspectRatio(
          aspectRatio: 8 / 5,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              //color: Colors.black.withAlpha(95),
              decoration: BoxDecoration(
                  color: globalAlmostWhite,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withAlpha(95),
                        Colors.black.withAlpha(95),
                        Colors.black.withOpacity(0.0),
                      ],
                      stops: [
                        0.0,
                        0.2,
                        0.8,
                        1.0
                      ])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 5.h),
                      Container(
                        width: 80.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40.w,
                              child: OverlayNumberInput(
                                autoFocus: _showGiftInput,
                                textEditingController: _giftDTCController,
                                label: "your gift",
                              ),
                            ),
                            Text(" DTC",
                                style: Theme.of(context).textTheme.headline5)
                          ],
                        ),
                      ),
                      Container(
                        width: 80.w,
                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: OverlayTextInput(
                              autoFocus: false,
                              textEditingController: _giftMemoController,
                              label: "Add some kind words"),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputChip(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          String _memo = "";

                          if (widget.link != "") {
                            _memo =
                                "Gift sent through https://d.tube/#!/v/${widget.author}/${widget.link}";
                            if (_giftMemoController.value.text != "") {
                              _memo =
                                  _memo + ": ${_giftMemoController.value.text}";
                            }
                          } else {
                            _memo = _giftMemoController.value.text;
                          }
                          TxData txdata = TxData(
                              receiver: widget.author,
                              amount:
                                  (double.parse(_giftDTCController.value.text) *
                                          100)
                                      .floor(),
                              memo: _memo);
                          Transaction newTx =
                              Transaction(type: 3, data: txdata);
                          BlocProvider.of<TransactionBloc>(context)
                              .add(SignAndSendTransactionEvent(tx: newTx));
                          cancelCallback();
                        },
                        backgroundColor: globalRed,
                        label: Padding(
                          padding: EdgeInsets.all(globalIconSizeBig / 4),
                          child: FaIcon(
                            FontAwesomeIcons.paperPlane,
                            size: globalIconSizeBig,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: InputChip(
                          label: Text(
                            "cancel",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onPressed: () {
                            cancelCallback();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class CommentDialogWidget extends StatelessWidget {
  CommentDialogWidget({
    Key? key,
    required bool showCommentInput,
    required TextEditingController replyController,
    required UserBloc userBloc,
    required this.widget,
    required this.cancelCallback,
  })  : _showCommentInput = showCommentInput,
        _replyController = replyController,
        _userBloc = userBloc,
        super(key: key);

  final bool _showCommentInput;
  final TextEditingController _replyController;
  final UserBloc _userBloc;
  final PostListCardLarge widget;
  int _currentVp = 0;
  VoidCallback cancelCallback;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: _showCommentInput,
        child: AspectRatio(
          aspectRatio: 8 / 5,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              //color: Colors.black.withAlpha(95),
              decoration: BoxDecoration(
                  color: globalAlmostWhite,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withAlpha(95),
                        Colors.black.withAlpha(95),
                        Colors.black.withOpacity(0.0),
                      ],
                      stops: [
                        0.0,
                        0.2,
                        0.8,
                        1.0
                      ])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80.w,
                    child: Padding(
                        padding: EdgeInsets.all(5.w),
                        child: OverlayTextInput(
                          autoFocus: _showCommentInput,
                          label: 'Share some feedback',
                          textEditingController: _replyController,
                        )),
                  ),
                  BlocBuilder<UserBloc, UserState>(
                      bloc: _userBloc,
                      builder: (context, state) {
                        if (state is UserDTCVPLoadingState) {
                          return CircularProgressIndicator();
                        }
                        if (state is UserDTCVPLoadedState) {
                          //_currentVp = state.vtBalance["v"]!;
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InputChip(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                UploadData _uploadData = new UploadData(
                                    link: "",
                                    parentAuthor: widget.author,
                                    parentPermlink: widget.link,
                                    title: "",
                                    description: _replyController.value.text,
                                    tag: "",
                                    vpPercent: double.parse(
                                        widget.defaultCommentVotingWeight),
                                    vpBalance: _currentVp,
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
                                    crossPostToHive: false);

                                BlocProvider.of<TransactionBloc>(context)
                                    .add(SendCommentEvent(_uploadData));
                                cancelCallback();
                              },
                              backgroundColor: globalRed,
                              label: Padding(
                                padding: EdgeInsets.all(globalIconSizeBig / 4),
                                child: FaIcon(
                                  FontAwesomeIcons.paperPlane,
                                  size: globalIconSizeBig,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: InputChip(
                                label: Text(
                                  "cancel",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                onPressed: () {
                                  cancelCallback();
                                },
                              ),
                            )
                          ],
                        );
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}

class VotingDialogWidget extends StatelessWidget {
  VotingDialogWidget({
    Key? key,
    required bool showVotingBars,
    required UserBloc userBloc,
    required this.widget,
    required this.cancelCallback,
    required bool votingDirection,
  })  : _showVotingBars = showVotingBars,
        _userBloc = userBloc,
        _votingDirection = votingDirection,
        super(key: key);

  final bool _showVotingBars;
  final UserBloc _userBloc;
  final PostListCardLarge widget;
  final bool _votingDirection;
  int _currentVp = 0;
  VoidCallback cancelCallback;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: _showVotingBars,
        child: AspectRatio(
          aspectRatio: 8 / 5,
          child: Align(
            alignment: Alignment.center,
            child: BlocBuilder<UserBloc, UserState>(
              bloc: _userBloc,
              builder: (context, state) {
                // TODO error handling

                if (state is UserDTCVPLoadingState) {
                  return DtubeLogoPulseWithSubtitle(
                      subtitle: "loading your balances...", size: 30.w);
                }
                if (state is UserDTCVPLoadedState) {
                  // _currentVp = state.vtBalance["v"]!;

                  return AspectRatio(
                    aspectRatio: 8 / 5,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.black.withAlpha(99),
                        child: VotingSliderStandalone(
                          defaultVote:
                              double.parse(widget.defaultPostVotingWeight),
                          defaultTip: double.parse(widget.defaultPostVotingTip),
                          author: widget.author,
                          link: widget.link,
                          downvote: !_votingDirection,
                          currentVT: _currentVp + 0.0,
                          isPost: true,
                          cancelCallback: () {
                            cancelCallback();
                          },
                        ),
                      ),
                    ),
                  );
                }
                return DtubeLogoPulseWithSubtitle(
                    subtitle: "loading your balances...", size: 30.w);
              },
            ),
          ),
        ));
  }
}

class PostInfoBaseRow extends StatelessWidget {
  const PostInfoBaseRow({
    Key? key,
    required this.widget,
    required double avatarSize,
  })  : _avatarSize = avatarSize,
        super(key: key);

  final PostListCardLarge widget;

  final double _avatarSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            FadeIn(
              preferences: AnimationPreferences(
                  offset: Duration(milliseconds: 500),
                  duration: Duration(seconds: 1)),
              child: InkWell(
                onTap: () {
                  navigateToUserDetailPage(context, widget.author, () {});
                },
                child: SizedBox(
                  width: 10.w,
                  child: AccountAvatarBase(
                      username: widget.author,
                      avatarSize: _avatarSize,
                      showVerified: true,
                      showName: false,
                      nameFontSizeMultiply: 1,
                      width: 10.w,
                      height: _avatarSize),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            FadeInLeftBig(
              preferences: AnimationPreferences(
                offset: Duration(milliseconds: 100),
                duration: Duration(milliseconds: 350),
              ),
              child: Container(
                width: 55.w,
                child: InkWell(
                  onTap: () {
                    navigateToPostDetailPage(context, widget.author,
                        widget.link, "none", false, () {});
                  },
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: 28.w,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.oc
                      ? FadeIn(
                          preferences: AnimationPreferences(
                              offset: Duration(milliseconds: 700),
                              duration: Duration(seconds: 1)),
                          child: Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: FaIcon(
                              FontAwesomeIcons.award,
                              size: globalIconSizeSmall * 0.6,
                            ),
                          ),
                        )
                      : SizedBox(width: globalIconSizeSmall),
                  TagChip(
                      waitBeforeFadeIn: Duration(milliseconds: 600),
                      fadeInFromLeft: false,
                      tagName: widget.mainTag,
                      width: 14.w,
                      fontStyle: Theme.of(context).textTheme.caption),
                ],
              ),
              globals.keyPermissions.isEmpty
                  ? Container()
                  : Align(
                      alignment: Alignment.centerRight,
                      child: SpeedDial(
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child:
                                // FadeIn(
                                //   preferences: AnimationPreferences(
                                //       offset: Duration(milliseconds: 700),
                                //       duration: Duration(seconds: 1)),
                                //   child:
                                HeartBeat(
                              preferences: AnimationPreferences(
                                  magnitude: 1.2,
                                  offset: Duration(seconds: 3),
                                  autoPlay: AnimationPlayStates.Loop),
                              child: ShadowedIcon(
                                  icon: FontAwesomeIcons.ellipsisV,
                                  color: globalAlmostWhite,
                                  shadowColor: Colors.black,
                                  size: globalIconSizeSmall),
                            ),
                            // ),
                          ),
                          activeChild: Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child: ShadowedIcon(
                                icon: FontAwesomeIcons.sortDown,
                                color: globalAlmostWhite,
                                shadowColor: Colors.black,
                                size: globalIconSizeSmall),
                          ),
                          buttonSize: Size(
                              globalIconSizeSmall * 2, globalIconSizeSmall * 2),
                          useRotationAnimation: false,
                          direction: SpeedDialDirection.up,
                          visible: true,
                          spacing: 0.0,
                          closeManually: false,
                          curve: Curves.bounceIn,
                          overlayColor: globalAlmostWhite,
                          overlayOpacity: 0,
                          onOpen: () => print('OPENING DIAL'),
                          onClose: () => print('DIAL CLOSED'),
                          tooltip: 'menu',
                          heroTag: 'submenu' + widget.title,
                          backgroundColor: Colors.transparent,
                          foregroundColor: globalAlmostWhite,
                          elevation: 0.0,
                          children: [
                            // COMMENT BUTTON
                            SpeedDialChild(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.w),
                                  child: ShadowedIcon(
                                      visible:
                                          globals.keyPermissions.contains(4),
                                      icon: FontAwesomeIcons.comment,
                                      color: globalAlmostWhite,
                                      shadowColor: Colors.black,
                                      size: globalIconSizeBig),
                                ),
                                foregroundColor: globalAlmostWhite,
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                onTap: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        BlocProvider<UserBloc>(
                                      create: (context) => UserBloc(
                                          repository: UserRepositoryImpl()),
                                      child: CommentDialog(
                                        txBloc:
                                            BlocProvider.of<TransactionBloc>(
                                                context),
                                        originAuthor: widget.author,
                                        originLink: widget.link,
                                        defaultCommentVote: double.parse(
                                            widget.defaultCommentVotingWeight),
                                      ),
                                    ),
                                  );
                                }),
                            // DOWNVOTE BUTTON
                            SpeedDialChild(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.w),
                                  child: ShadowedIcon(
                                      visible:
                                          globals.keyPermissions.contains(5),
                                      icon: FontAwesomeIcons.flag,
                                      color: !widget.alreadyVoted
                                          ? globalAlmostWhite
                                          : globalRed,
                                      shadowColor: Colors.black,
                                      size: globalIconSizeBig),
                                ),
                                foregroundColor: globalAlmostWhite,
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                onTap: () {
                                  if (!widget.alreadyVoted) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          MultiBlocProvider(
                                        providers: [
                                          BlocProvider<PostBloc>(
                                              create: (context) => PostBloc(
                                                  repository:
                                                      PostRepositoryImpl())),
                                          BlocProvider<UserBloc>(
                                              create: (context) => UserBloc(
                                                  repository:
                                                      UserRepositoryImpl())),
                                        ],
                                        child: VotingDialog(
                                          txBloc:
                                              BlocProvider.of<TransactionBloc>(
                                                  context),
                                          defaultVote: double.parse(
                                              widget.defaultPostVotingWeight),
                                          defaultTip: double.parse(
                                              widget.defaultPostVotingTip),
                                          author: widget.author,
                                          link: widget.link,
                                          downvote: true,
                                          //currentVT: state.vtBalance['v']! + 0.0,
                                          isPost: true,
                                          fixedDownvoteActivated:
                                              widget.fixedDownvoteActivated ==
                                                  "true",
                                          fixedDownvoteWeight: double.parse(
                                              widget.fixedDownvoteWeight),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            // UPVOTE BUTTON

                            SpeedDialChild(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.w),
                                  child: ShadowedIcon(
                                      visible:
                                          globals.keyPermissions.contains(5),
                                      icon: FontAwesomeIcons.heart,
                                      color: !widget.alreadyVoted
                                          ? globalAlmostWhite
                                          : globalRed,
                                      shadowColor: Colors.black,
                                      size: globalIconSizeBig),
                                ),
                                foregroundColor: globalAlmostWhite,
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                onTap: () {
                                  if (!widget.alreadyVoted) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          MultiBlocProvider(
                                        providers: [
                                          BlocProvider<PostBloc>(
                                              create: (context) => PostBloc(
                                                  repository:
                                                      PostRepositoryImpl())),
                                          BlocProvider<UserBloc>(
                                              create: (context) => UserBloc(
                                                  repository:
                                                      UserRepositoryImpl())),
                                        ],
                                        child: VotingDialog(
                                          txBloc:
                                              BlocProvider.of<TransactionBloc>(
                                                  context),
                                          defaultVote: double.parse(
                                              widget.defaultPostVotingWeight),
                                          defaultTip: double.parse(
                                              widget.defaultPostVotingTip),
                                          author: widget.author,
                                          link: widget.link,
                                          downvote: false,
                                          //currentVT: state.vtBalance['v']! + 0.0,
                                          isPost: true,
                                          fixedDownvoteActivated:
                                              widget.fixedDownvoteActivated ==
                                                  "true",
                                          fixedDownvoteWeight: double.parse(
                                              widget.fixedDownvoteWeight),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            // GIFT BUTTON
                            SpeedDialChild(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.w),
                                  child: ShadowedIcon(
                                      visible:
                                          globals.keyPermissions.contains(3),
                                      icon: FontAwesomeIcons.gift,
                                      color: globalAlmostWhite,
                                      shadowColor: Colors.black,
                                      size: globalIconSizeBig),
                                ),
                                foregroundColor: globalAlmostWhite,
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                onTap: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        GiftDialog(
                                      txBloc: BlocProvider.of<TransactionBloc>(
                                          context),
                                      receiver: widget.author,
                                      originLink: widget.link,
                                    ),
                                  );
                                }),
                          ]),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class PostInfoColumn extends StatelessWidget {
  const PostInfoColumn({
    Key? key,
    required this.widget,
    required double avatarSize,
  })  : _avatarSize = avatarSize,
        super(key: key);

  final PostListCardLarge widget;

  final double _avatarSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FadeIn(
          preferences: AnimationPreferences(
              offset: Duration(milliseconds: 500),
              duration: Duration(seconds: 1)),
          child: InkWell(
            onTap: () {
              navigateToUserDetailPage(context, widget.author, () {});
            },
            child: AccountAvatarBase(
                username: widget.author,
                avatarSize: _avatarSize,
                showVerified: true,
                showName: true,
                nameFontSizeMultiply: 1.5,
                width: 25.w,
                height: _avatarSize),
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            FadeInLeftBig(
              preferences: AnimationPreferences(
                offset: Duration(milliseconds: 100),
                duration: Duration(milliseconds: 350),
              ),
              child: Container(
                width: 30.w,
                child: InkWell(
                  onTap: () {
                    navigateToPostDetailPage(context, widget.author,
                        widget.link, "none", false, () {});
                  },
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ),
            widget.oc
                ? FadeIn(
                    preferences: AnimationPreferences(
                        offset: Duration(milliseconds: 700),
                        duration: Duration(seconds: 1)),
                    child: Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: FaIcon(
                        FontAwesomeIcons.award,
                        size: globalIconSizeSmall * 0.6,
                      ),
                    ),
                  )
                : SizedBox(width: globalIconSizeSmall),
            TagChip(
                waitBeforeFadeIn: Duration(milliseconds: 600),
                fadeInFromLeft: false,
                tagName: widget.mainTag,
                width: 10.w,
                fontStyle: Theme.of(context).textTheme.caption),
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: CollapsedDescription(description: widget.description),
        ),
        FadeInDown(
            preferences:
                AnimationPreferences(offset: Duration(milliseconds: 500)),
            child: Container(
              width: 42.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${widget.publishDate}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        ' - ' +
                            (widget.duration.inHours == 0
                                ? widget.duration.toString().substring(2, 7) +
                                    ' min'
                                : widget.duration.toString().substring(0, 7) +
                                    ' h'),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.dtcValue}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.5.w),
                        child: DTubeLogoShadowed(size: 1.w),
                      ),
                      globals.keyPermissions.isEmpty
                          ? Container()
                          : SpeedDial(
                              child: HeartBeat(
                                preferences: AnimationPreferences(
                                    magnitude: 1.2,
                                    offset: Duration(seconds: 3),
                                    autoPlay: AnimationPlayStates.Loop),
                                child: ShadowedIcon(
                                    icon: FontAwesomeIcons.ellipsisV,
                                    color: globalAlmostWhite,
                                    shadowColor: Colors.black,
                                    size: globalIconSizeSmall),
                              ),
                              // ),

                              activeChild: ShadowedIcon(
                                  icon: FontAwesomeIcons.sortDown,
                                  color: globalAlmostWhite,
                                  shadowColor: Colors.black,
                                  size: globalIconSizeSmall),
                              buttonSize: Size(globalIconSizeSmall * 2,
                                  globalIconSizeSmall * 2),
                              useRotationAnimation: false,
                              direction: SpeedDialDirection.up,
                              visible: true,
                              spacing: 0.0,
                              closeManually: false,
                              curve: Curves.bounceIn,
                              overlayColor: globalAlmostWhite,
                              overlayOpacity: 0,
                              onOpen: () => print('OPENING DIAL'),
                              onClose: () => print('DIAL CLOSED'),
                              tooltip: 'menu',
                              heroTag: 'submenu' + widget.title,
                              backgroundColor: Colors.transparent,
                              foregroundColor: globalAlmostWhite,
                              elevation: 0.0,
                              children: [
                                  // COMMENT BUTTON
                                  SpeedDialChild(
                                      child: ShadowedIcon(
                                          visible: globals.keyPermissions
                                              .contains(4),
                                          icon: FontAwesomeIcons.comment,
                                          color: globalAlmostWhite,
                                          shadowColor: Colors.black,
                                          size: globalIconSizeSmall),
                                      foregroundColor: globalAlmostWhite,
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      onTap: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              BlocProvider<UserBloc>(
                                            create: (context) => UserBloc(
                                                repository:
                                                    UserRepositoryImpl()),
                                            child: CommentDialog(
                                              txBloc: BlocProvider.of<
                                                  TransactionBloc>(context),
                                              originAuthor: widget.author,
                                              originLink: widget.link,
                                              defaultCommentVote: double.parse(
                                                  widget
                                                      .defaultCommentVotingWeight),
                                            ),
                                          ),
                                        );
                                      }),
                                  // DOWNVOTE BUTTON
                                  SpeedDialChild(
                                      child: ShadowedIcon(
                                          visible: globals.keyPermissions
                                              .contains(5),
                                          icon: FontAwesomeIcons.flag,
                                          color: !widget.alreadyVoted
                                              ? globalAlmostWhite
                                              : globalRed,
                                          shadowColor: Colors.black,
                                          size: globalIconSizeSmall),
                                      foregroundColor: globalAlmostWhite,
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      onTap: () {
                                        if (!widget.alreadyVoted) {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                MultiBlocProvider(
                                              providers: [
                                                BlocProvider<PostBloc>(
                                                    create: (context) => PostBloc(
                                                        repository:
                                                            PostRepositoryImpl())),
                                                BlocProvider<UserBloc>(
                                                    create: (context) => UserBloc(
                                                        repository:
                                                            UserRepositoryImpl())),
                                              ],
                                              child: VotingDialog(
                                                txBloc: BlocProvider.of<
                                                    TransactionBloc>(context),
                                                defaultVote: double.parse(widget
                                                    .defaultPostVotingWeight),
                                                defaultTip: double.parse(widget
                                                    .defaultPostVotingTip),
                                                author: widget.author,
                                                link: widget.link,
                                                downvote: true,
                                                //currentVT: state.vtBalance['v']! + 0.0,
                                                isPost: true,
                                                fixedDownvoteActivated: widget
                                                        .fixedDownvoteActivated ==
                                                    "true",
                                                fixedDownvoteWeight:
                                                    double.parse(widget
                                                        .fixedDownvoteWeight),
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                  // UPVOTE BUTTON

                                  SpeedDialChild(
                                      child: ShadowedIcon(
                                          visible: globals.keyPermissions
                                              .contains(5),
                                          icon: FontAwesomeIcons.heart,
                                          color: !widget.alreadyVoted
                                              ? globalAlmostWhite
                                              : globalRed,
                                          shadowColor: Colors.black,
                                          size: globalIconSizeSmall),
                                      foregroundColor: globalAlmostWhite,
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      onTap: () {
                                        if (!widget.alreadyVoted) {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                MultiBlocProvider(
                                              providers: [
                                                BlocProvider<PostBloc>(
                                                    create: (context) => PostBloc(
                                                        repository:
                                                            PostRepositoryImpl())),
                                                BlocProvider<UserBloc>(
                                                    create: (context) => UserBloc(
                                                        repository:
                                                            UserRepositoryImpl())),
                                              ],
                                              child: VotingDialog(
                                                txBloc: BlocProvider.of<
                                                    TransactionBloc>(context),
                                                defaultVote: double.parse(widget
                                                    .defaultPostVotingWeight),
                                                defaultTip: double.parse(widget
                                                    .defaultPostVotingTip),
                                                author: widget.author,
                                                link: widget.link,
                                                downvote: false,
                                                //currentVT: state.vtBalance['v']! + 0.0,
                                                isPost: true,
                                                fixedDownvoteActivated: widget
                                                        .fixedDownvoteActivated ==
                                                    "true",
                                                fixedDownvoteWeight:
                                                    double.parse(widget
                                                        .fixedDownvoteWeight),
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                  // GIFT BUTTON
                                  SpeedDialChild(
                                      child: ShadowedIcon(
                                          visible: globals.keyPermissions
                                              .contains(3),
                                          icon: FontAwesomeIcons.gift,
                                          color: globalAlmostWhite,
                                          shadowColor: Colors.black,
                                          size: globalIconSizeSmall),
                                      foregroundColor: globalAlmostWhite,
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      onTap: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              GiftDialog(
                                            txBloc: BlocProvider.of<
                                                TransactionBloc>(context),
                                            receiver: widget.author,
                                            originLink: widget.link,
                                          ),
                                        );
                                      }),
                                ]),
                    ],
                  ),
                ],
              ),
            )),
        // SizedBox(height: 1.h),
      ],
    );
  }
}

class PlayerWidget extends StatelessWidget {
  PlayerWidget(
      {Key? key,
      required bool thumbnailTapped,
      required this.widget,
      required VideoPlayerController bpController,
      required YoutubePlayerController ytController,
      required this.placeholderSize,
      required this.placeholderWidth})
      : _thumbnailTapped = thumbnailTapped,
        _bpController = bpController,
        _ytController = ytController,
        super(key: key);

  final bool _thumbnailTapped;
  final PostListCardLarge widget;
  final VideoPlayerController _bpController;
  final YoutubePlayerController _ytController;
  double placeholderWidth;
  double placeholderSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: _thumbnailTapped,
        child: (["sia", "ipfs"].contains(widget.videoSource) &&
                widget.videoUrl != "")
            // ? BP(
            //     videoUrl: widget.videoUrl,
            //     autoplay: true,
            //     looping: false,
            //     localFile: false,
            //     controls: true,
            //     usedAsPreview: false,
            //     allowFullscreen: false,
            //     portraitVideoPadding: 30.w,
            //   )
            ?
            // AspectRatio(
            //     aspectRatio: 16 / 9,
            // child:
            ChewiePlayer(
                videoUrl: widget.videoUrl,
                autoplay: true,
                looping: false,
                localFile: false,
                controls: true,
                usedAsPreview: false,
                allowFullscreen: true,
                portraitVideoPadding: 33.w,
                videocontroller: _bpController,
                placeholderWidth: placeholderWidth,
                placeholderSize: placeholderSize,
                // ),
              )
            : (widget.videoSource == 'youtube' && widget.videoUrl != "")
                ? YTPlayerIFrame(
                    videoUrl: widget.videoUrl,
                    autoplay: true,
                    allowFullscreen: false,
                    controller: _ytController,
                  )
                : Text("no player detected"),
      ),
    );
  }
}

class ThumbnailWidget extends StatelessWidget {
  const ThumbnailWidget({
    Key? key,
    required bool thumbnailTapped,
    required this.widget,
  })  : _thumbnailTapped = thumbnailTapped,
        super(key: key);

  final bool _thumbnailTapped;
  final PostListCardLarge widget;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_thumbnailTapped,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: widget.blur
            ? ClipRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaY: 5,
                    sigmaX: 5,
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: widget.thumbnailUrl,
                    errorWidget: (context, url, error) => DTubeLogo(
                      size: 50,
                    ),
                  ),
                ),
              )
            :
            // shimmer creates a light color cast even if the animation is not present
            Shimmer(
                duration: Duration(seconds: 5),
                interval: Duration(seconds: generateRandom(3, 15)),
                color: globalAlmostWhite,
                colorOpacity: 0.1,
                child: CachedNetworkImage(
                  imageUrl: widget.thumbnailUrl,
                  fit: BoxFit.fitWidth,
                  errorWidget: (context, url, error) => DTubeLogo(
                    size: 50,
                  ),
                ),
              ),
      ),
    );
  }
}
