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
import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer.dart';
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
  const PostListCardLarge({
    Key? key,
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
    required this.fixedDownvoteWeight,
    required this.autoPauseVideoOnPopup,
  }) : super(key: key);

  final bool blur;
  final bool autoPauseVideoOnPopup;
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

        if (visiblePercentage < 95 &&
            !_showCommentInput &&
            !_showGiftInput &&
            !_showVotingBars) {
          _ytController.pause();
          _bpController.pause();
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
              videoController: _bpController,
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
                blur: widget.blur,
                thumbUrl: widget.thumbnailUrl,
                videoSource: widget.videoSource,
                videoUrl: widget.videoUrl,
                thumbnailTappedCallback: () {
                  setState(() {
                    _thumbnailTapped = true;
                  });
                },
                votingOpenCallback: () {
                  setState(() {
                    _showVotingBars = false;
                  });
                },
                commentOpenCallback: () {
                  setState(() {
                    _showCommentInput = false;
                    _replyController.text = '';
                  });
                },
                giftOpenCallback: () {
                  setState(() {
                    _showGiftInput = false;
                  });
                },
              ),
            ),
    );
  }
}

class MobilePostData extends StatefulWidget {
  MobilePostData(
      {Key? key,
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
      required this.votingOpenCallback,
      required this.commentOpenCallback,
      required this.giftOpenCallback,
      required this.videoSource,
      required this.videoUrl,
      required this.thumbUrl,
      required this.blur})
      : _thumbnailTapped = thumbnailTapped,
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
  bool _showVotingBars;
  final UserBloc _userBloc;
  final bool _votingDirection;
  bool _showCommentInput;
  final TextEditingController _replyController;
  bool _showGiftInput;
  final TextEditingController _giftDTCController;
  final TextEditingController _giftMemoController;
  final double _avatarSize;
  VoidCallback thumbnailTappedCallback;
  VoidCallback votingOpenCallback;
  VoidCallback commentOpenCallback;
  VoidCallback giftOpenCallback;
  String videoSource;
  String videoUrl;
  bool blur;
  String thumbUrl;

  @override
  State<MobilePostData> createState() => _MobilePostDataState();
}

class _MobilePostDataState extends State<MobilePostData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            widget.thumbnailTappedCallback();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ThumbnailWidget(
                  thumbnailTapped: widget._thumbnailTapped,
                  blur: widget.blur,
                  thumbUrl: widget.thumbUrl),
              PlayerWidget(
                thumbnailTapped: widget._thumbnailTapped,
                bpController: widget._bpController,
                videoSource: widget.videoSource,
                videoUrl: widget.videoUrl,
                ytController: widget._ytController,
                placeholderWidth: 100.w,
                placeholderSize: 40.w,
              ),
            ],
          ),
        ),
        PostInfoBaseRow(
          avatarSize: widget._avatarSize,
          widget: widget.widget,
          videoController: widget._bpController,
          ytController: widget._ytController,
          commentCloseCallback: () {
            setState(() {
              widget._showCommentInput = false;
            });
          },
          votingCloseCallback: () {
            setState(() {
              widget._showVotingBars = false;
            });
          },
          giftCloseCallback: () {
            setState(() {
              widget._showGiftInput = false;
            });
          },
          commentOpenCallback: () {
            setState(() {
              widget._showCommentInput = true;
            });
          },
          votingOpenCallback: () {
            setState(() {
              widget._showVotingBars = true;
            });
          },
          giftOpenCallback: () {
            setState(() {
              widget._showGiftInput = true;
            });
          },
        ),
        globals.disableAnimations
            ? PostInfoDetailsRow(
                widget: widget.widget,
              )
            : FadeInDown(
                preferences:
                    AnimationPreferences(offset: Duration(milliseconds: 500)),
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: PostInfoDetailsRow(
                    widget: widget.widget,
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
    required VideoPlayerController videoController,
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
        _videoController = videoController,
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
  final VideoPlayerController _videoController;

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
                      thumbnailTapped: _thumbnailTapped,
                      blur: widget.blur,
                      thumbUrl: widget.thumbnailUrl),
                  PlayerWidget(
                    thumbnailTapped: _thumbnailTapped,
                    bpController: _videoController,
                    videoSource: widget.videoSource,
                    videoUrl: widget.videoUrl,
                    ytController: _ytController,
                    placeholderWidth: 30.w,
                    placeholderSize: globalIconSizeMedium,
                  ),
                  // VOTING DIALOG
                  VotingDialogWidget(
                    showVotingBars: _showVotingBars,
                    userBloc: _userBloc,
                    votingDirection: _votingDirection,
                    widget: widget,
                    cancelCallback: () {
                      votingCancelCallback();
                    },
                  ),
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
              videoController: _videoController,
              ytController: _ytController,
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
  PostInfoBaseRow({
    Key? key,
    required this.widget,
    required double avatarSize,
    required this.ytController,
    required this.videoController,
    required this.votingCloseCallback,
    required this.votingOpenCallback,
    required this.commentOpenCallback,
    required this.commentCloseCallback,
    required this.giftOpenCallback,
    required this.giftCloseCallback,
  })  : _avatarSize = avatarSize,
        super(key: key);

  final PostListCardLarge widget;

  final double _avatarSize;
  YoutubePlayerController ytController;
  VideoPlayerController videoController;
  VoidCallback votingOpenCallback;
  VoidCallback commentOpenCallback;
  VoidCallback giftOpenCallback;
  VoidCallback votingCloseCallback;
  VoidCallback commentCloseCallback;
  VoidCallback giftCloseCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            globals.disableAnimations
                ? BaseRowContainer(widget: widget, avatarSize: _avatarSize)
                : FadeIn(
                    preferences: AnimationPreferences(
                        offset: Duration(milliseconds: 500),
                        duration: Duration(seconds: 1)),
                    child: BaseRowContainer(
                        widget: widget, avatarSize: _avatarSize),
                  ),
            SizedBox(width: 2.w),
            globals.disableAnimations
                ? TitleWidgetForRow(widget: widget)
                : FadeInLeftBig(
                    preferences: AnimationPreferences(
                      offset: Duration(milliseconds: 100),
                      duration: Duration(milliseconds: 350),
                    ),
                    child: TitleWidgetForRow(widget: widget),
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
                      ? globals.disableAnimations
                          ? OriginalContentIcon()
                          : FadeIn(
                              preferences: AnimationPreferences(
                                  offset: Duration(milliseconds: 700),
                                  duration: Duration(seconds: 1)),
                              child: OriginalContentIcon(),
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
                            child: globals.disableAnimations
                                ? ShadowedIcon(
                                    icon: FontAwesomeIcons.ellipsisVertical,
                                    color: globalAlmostWhite,
                                    shadowColor: Colors.black,
                                    size: globalIconSizeMedium)
                                : HeartBeat(
                                    preferences: AnimationPreferences(
                                        magnitude: 1.2,
                                        offset: Duration(seconds: 3),
                                        autoPlay: AnimationPlayStates.Loop),
                                    child: ShadowedIcon(
                                        icon: FontAwesomeIcons.ellipsisVertical,
                                        color: globalAlmostWhite,
                                        shadowColor: Colors.black,
                                        size: globalIconSizeMedium),
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
                                  if (widget.autoPauseVideoOnPopup) {
                                    videoController.pause();
                                    ytController.pause();
                                  }
                                  commentOpenCallback();

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
                                        okCallback: () {
                                          commentCloseCallback();
                                          if (widget.autoPauseVideoOnPopup) {
                                            ytController.play();
                                            videoController.play();
                                          }
                                        },
                                        cancelCallback: () {
                                          commentCloseCallback();
                                          if (widget.autoPauseVideoOnPopup) {
                                            ytController.play();
                                            videoController.play();
                                          }
                                        },
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
                                    if (widget.autoPauseVideoOnPopup) {
                                      videoController.pause();
                                      ytController.pause();
                                    }
                                    votingOpenCallback();
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
                                          defaultVote: double.parse(
                                              widget.defaultPostVotingWeight),
                                          defaultTip: double.parse(
                                              widget.defaultPostVotingTip),
                                          postBloc: BlocProvider.of<PostBloc>(
                                              context),
                                          txBloc:
                                              BlocProvider.of<TransactionBloc>(
                                                  context),
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
                                          okCallback: () {
                                            votingCloseCallback();
                                            if (widget.autoPauseVideoOnPopup) {
                                              ytController.play();
                                              videoController.play();
                                            }
                                          },
                                          cancelCallback: () {
                                            votingCloseCallback();
                                            if (widget.autoPauseVideoOnPopup) {
                                              ytController.play();
                                              videoController.play();
                                            }
                                          },
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
                                    votingOpenCallback();
                                    if (widget.autoPauseVideoOnPopup) {
                                      videoController.pause();
                                      ytController.pause();
                                    }

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
                                          defaultVote: double.parse(
                                              widget.defaultPostVotingWeight),
                                          defaultTip: double.parse(
                                              widget.defaultPostVotingTip),
                                          postBloc: BlocProvider.of<PostBloc>(
                                              context),
                                          txBloc:
                                              BlocProvider.of<TransactionBloc>(
                                                  context),
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
                                          okCallback: () {
                                            votingCloseCallback();
                                            if (widget.autoPauseVideoOnPopup) {
                                              ytController.play();
                                              videoController.play();
                                            }
                                          },
                                          cancelCallback: () {
                                            votingCloseCallback();
                                            if (widget.autoPauseVideoOnPopup) {
                                              ytController.play();
                                              videoController.play();
                                            }
                                          },
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
                                  if (widget.autoPauseVideoOnPopup) {
                                    videoController.pause();
                                    ytController.pause();
                                  }
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        GiftDialog(
                                      okCallback: () {
                                        giftCloseCallback();
                                        if (widget.autoPauseVideoOnPopup) {
                                          ytController.play();
                                          videoController.play();
                                        }
                                      },
                                      cancelCallback: () {
                                        giftCloseCallback();
                                        if (widget.autoPauseVideoOnPopup) {
                                          ytController.play();
                                          videoController.play();
                                        }
                                      },
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

class BaseRowContainer extends StatelessWidget {
  const BaseRowContainer({
    Key? key,
    required this.widget,
    required double avatarSize,
  })  : _avatarSize = avatarSize,
        super(key: key);

  final PostListCardLarge widget;
  final double _avatarSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToUserDetailPage(context, widget.author, () {});
      },
      child: SizedBox(
          width: 10.w,
          child: AccountIconBase(
            avatarSize: _avatarSize,
            showVerified: true,
            username: widget.author,
          )),
    );
  }
}

class OriginalContentIcon extends StatelessWidget {
  const OriginalContentIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 2.w),
      child: FaIcon(
        FontAwesomeIcons.award,
        size: globalIconSizeSmall * 0.6,
      ),
    );
  }
}

class TitleWidgetForRow extends StatelessWidget {
  const TitleWidgetForRow({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PostListCardLarge widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.w,
      child: InkWell(
        onTap: () {
          navigateToPostDetailPage(
              context, widget.author, widget.link, "none", false, () {});
        },
        child: Text(
          widget.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}

class PostInfoColumn extends StatelessWidget {
  const PostInfoColumn({
    Key? key,
    required this.widget,
    required this.videoController,
    required this.ytController,
    required double avatarSize,
  })  : _avatarSize = avatarSize,
        super(key: key);

  final PostListCardLarge widget;

  final double _avatarSize;
  final VideoPlayerController videoController;
  final YoutubePlayerController ytController;

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
            child: AccountIconBase(
              username: widget.author,
              avatarSize: _avatarSize,
              showVerified: true,
              // showName: true,
              // nameFontSizeMultiply: 1.5,
              // width: 25.w,
              // height: _avatarSize
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            globals.disableAnimations
                ? TitleWidgetForColumn(widget: widget)
                : FadeInLeftBig(
                    preferences: AnimationPreferences(
                      offset: Duration(milliseconds: 100),
                      duration: Duration(milliseconds: 350),
                    ),
                    child: TitleWidgetForColumn(widget: widget),
                  ),
            widget.oc
                ? globals.disableAnimations
                    ? OriginalContentIcon()
                    : FadeIn(
                        preferences: AnimationPreferences(
                            offset: Duration(milliseconds: 700),
                            duration: Duration(seconds: 1)),
                        child: OriginalContentIcon())
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
                              child: globals.disableAnimations
                                  ? ShadowedIcon(
                                      icon: FontAwesomeIcons.ellipsisVertical,
                                      color: globalAlmostWhite,
                                      shadowColor: Colors.black,
                                      size: globalIconSizeMedium)
                                  : HeartBeat(
                                      preferences: AnimationPreferences(
                                          magnitude: 1.2,
                                          offset: Duration(seconds: 3),
                                          autoPlay: AnimationPlayStates.Loop),
                                      child: ShadowedIcon(
                                          icon:
                                              FontAwesomeIcons.ellipsisVertical,
                                          color: globalAlmostWhite,
                                          shadowColor: Colors.black,
                                          size: globalIconSizeMedium),
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
                                        if (widget.autoPauseVideoOnPopup) {
                                          videoController.pause();
                                          ytController.pause();
                                        }
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
                                              okCallback: () {
                                                if (widget
                                                    .autoPauseVideoOnPopup) {
                                                  ytController.play();
                                                  videoController.play();
                                                }
                                              },
                                              cancelCallback: () {
                                                if (widget
                                                    .autoPauseVideoOnPopup) {
                                                  ytController.play();
                                                  videoController.play();
                                                }
                                              },
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
                                          if (widget.autoPauseVideoOnPopup) {
                                            videoController.pause();
                                            ytController.pause();
                                          }
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
                                                defaultVote: double.parse(widget
                                                    .defaultPostVotingWeight),
                                                defaultTip: double.parse(widget
                                                    .defaultPostVotingTip),
                                                author: widget.author,

                                                link: widget.link,
                                                downvote: true,
                                                postBloc:
                                                    BlocProvider.of<PostBloc>(
                                                        context),
                                                txBloc: BlocProvider.of<
                                                    TransactionBloc>(context),
                                                //currentVT: state.vtBalance['v']! + 0.0,
                                                isPost: true,
                                                fixedDownvoteActivated: widget
                                                        .fixedDownvoteActivated ==
                                                    "true",
                                                fixedDownvoteWeight:
                                                    double.parse(widget
                                                        .fixedDownvoteWeight),
                                                okCallback: () {
                                                  if (widget
                                                      .autoPauseVideoOnPopup) {
                                                    ytController.play();
                                                    videoController.play();
                                                  }
                                                },
                                                cancelCallback: () {
                                                  if (widget
                                                      .autoPauseVideoOnPopup) {
                                                    ytController.play();
                                                    videoController.play();
                                                  }
                                                },
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
                                          if (widget.autoPauseVideoOnPopup) {
                                            videoController.pause();
                                            ytController.pause();
                                          }
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
                                                defaultVote: double.parse(widget
                                                    .defaultPostVotingWeight),
                                                defaultTip: double.parse(widget
                                                    .defaultPostVotingTip),
                                                postBloc:
                                                    BlocProvider.of<PostBloc>(
                                                        context),
                                                txBloc: BlocProvider.of<
                                                    TransactionBloc>(context),
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
                                                okCallback: () {
                                                  if (widget
                                                      .autoPauseVideoOnPopup) {
                                                    ytController.play();
                                                    videoController.play();
                                                  }
                                                },
                                                cancelCallback: () {
                                                  if (widget
                                                      .autoPauseVideoOnPopup) {
                                                    ytController.play();
                                                    videoController.play();
                                                  }
                                                },
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
                                            okCallback: () {
                                              if (widget
                                                  .autoPauseVideoOnPopup) {
                                                ytController.play();
                                                videoController.play();
                                              }
                                            },
                                            cancelCallback: () {
                                              if (widget
                                                  .autoPauseVideoOnPopup) {
                                                ytController.play();
                                                videoController.play();
                                              }
                                            },
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

class TitleWidgetForColumn extends StatelessWidget {
  const TitleWidgetForColumn({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PostListCardLarge widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      child: InkWell(
        onTap: () {
          navigateToPostDetailPage(
              context, widget.author, widget.link, "none", false, () {});
        },
        child: Text(
          widget.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  PlayerWidget(
      {Key? key,
      required bool thumbnailTapped,
      required this.videoSource,
      required this.videoUrl,
      required VideoPlayerController bpController,
      required YoutubePlayerController ytController,
      required this.placeholderSize,
      required this.placeholderWidth})
      : _thumbnailTapped = thumbnailTapped,
        _bpController = bpController,
        _ytController = ytController,
        super(key: key);

  final bool _thumbnailTapped;
  String videoSource;
  String videoUrl;
  final VideoPlayerController _bpController;
  final YoutubePlayerController _ytController;
  double placeholderWidth;
  double placeholderSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: _thumbnailTapped,
        child: (["sia", "ipfs"].contains(videoSource) && videoUrl != "")
            ?
            // AspectRatio(
            //     aspectRatio: 16 / 9,
            // child:
            ChewiePlayer(
                videoUrl: videoUrl,
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
            : (videoSource == 'youtube' && videoUrl != "")
                ? YTPlayerIFrame(
                    videoUrl: videoUrl,
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
    required this.blur,
    required this.thumbUrl,
  })  : _thumbnailTapped = thumbnailTapped,
        super(key: key);

  final bool _thumbnailTapped;
  final bool blur;
  final String thumbUrl;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_thumbnailTapped,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: blur
            ? ClipRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaY: 5,
                    sigmaX: 5,
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: thumbUrl,
                    errorWidget: (context, url, error) => DTubeLogo(
                      size: 50,
                    ),
                  ),
                ),
              )
            : globals.disableAnimations
                ? ThumbnailContainer(thumbUrl: thumbUrl)
                : Shimmer(
                    duration: Duration(seconds: 5),
                    interval: Duration(seconds: generateRandom(3, 15)),
                    color: globalAlmostWhite,
                    colorOpacity: 0.1,
                    child: ThumbnailContainer(thumbUrl: thumbUrl)),
      ),
    );
  }
}

class ThumbnailContainer extends StatelessWidget {
  const ThumbnailContainer({
    Key? key,
    required this.thumbUrl,
  }) : super(key: key);

  final String thumbUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: thumbUrl,
      fit: BoxFit.fitWidth,
      errorWidget: (context, url, error) => DTubeLogo(
        size: 50,
      ),
    );
  }
}
