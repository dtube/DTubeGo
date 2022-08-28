import 'package:dtube_go/ui/pages/feeds/cards/widets/CollapsedDescription.dart';
import 'package:dtube_go/ui/pages/feeds/cards/widets/ThumbPlayerWidgets.dart';
import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

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
import 'package:dtube_go/utils/Random/randomGenerator.dart';
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
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PostListCardLarge extends StatefulWidget {
  PostListCardLarge(
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
      required this.fixedDownvoteWeight,
      required this.autoPauseVideoOnPopup,
      this.hideSpeedDial,
      this.disableVideoPlayback,
      required this.width})
      : super(key: key);

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
  bool? hideSpeedDial;
  bool? disableVideoPlayback;
  final double width;

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

  late VideoPlayerController _bpController;
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    _avatarSize = widget.width * 0.1;
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PostData(
          width: widget.width,
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
              if (widget.disableVideoPlayback == null ||
                  !widget.disableVideoPlayback!) {
                _thumbnailTapped = true;
              }
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

class PostData extends StatefulWidget {
  PostData(
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
      required this.blur,
      required this.width})
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
  final VoidCallback thumbnailTappedCallback;
  final VoidCallback votingOpenCallback;
  final VoidCallback commentOpenCallback;
  final VoidCallback giftOpenCallback;
  final String videoSource;
  final String videoUrl;
  final bool blur;
  final String thumbUrl;
  final double width;

  @override
  State<PostData> createState() => _PostDataState();
}

class _PostDataState extends State<PostData> {
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
                placeholderWidth: widget.width,
                placeholderSize: widget.width * 0.4,
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
                child: PostInfoDetailsRow(
                  widget: widget.widget,
                ),
              ),
        SizedBox(height: 1.h),
      ],
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
              width: widget.width * 0.5,
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
                padding: EdgeInsets.only(left: widget.width * 0.01),
                child: DTubeLogoShadowed(size: widget.width * 0.05),
              ),
            ],
          ),
        ),
      ],
    );
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
  final YoutubePlayerController ytController;
  final VideoPlayerController videoController;
  final VoidCallback votingOpenCallback;
  final VoidCallback commentOpenCallback;
  final VoidCallback giftOpenCallback;
  final VoidCallback votingCloseCallback;
  final VoidCallback commentCloseCallback;
  final VoidCallback giftCloseCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            globals.disableAnimations
                ? AccountIconContainer(widget: widget, avatarSize: _avatarSize)
                : FadeIn(
                    preferences: AnimationPreferences(
                        offset: Duration(milliseconds: 500),
                        duration: Duration(seconds: 1)),
                    child: AccountIconContainer(
                        widget: widget, avatarSize: _avatarSize),
                  ),
            SizedBox(width: widget.width * 0.02),
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
          width: widget.width * 0.28,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TagChip(
                        waitBeforeFadeIn: Duration(milliseconds: 600),
                        fadeInFromLeft: false,
                        tagName: widget.mainTag,
                        width: widget.width * 0.14,
                        fontStyle: Theme.of(context).textTheme.caption),
                  ),
                ],
              ),
              globals.keyPermissions.isEmpty ||
                      (widget.hideSpeedDial != null && widget.hideSpeedDial!)
                  ? Container()
                  : Align(
                      alignment: Alignment.centerRight,
                      child: SpeedDial(
                          child: Padding(
                            padding: EdgeInsets.only(left: widget.width * 0.12),
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
                            padding: EdgeInsets.only(left: widget.width * 0.12),
                            child: ShadowedIcon(
                                icon: FontAwesomeIcons.sortDown,
                                color: globalAlmostWhite,
                                shadowColor: Colors.black,
                                size: globalIconSizeMedium),
                          ),
                          // buttonSize:
                          //     Size(globalIconSizeMedium, globalIconSizeMedium),
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
                                  padding: EdgeInsets.only(
                                      left: widget.width * 0.07),
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
                                  padding: EdgeInsets.only(
                                      left: widget.width * 0.07),
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
                                          txBloc:
                                              BlocProvider.of<TransactionBloc>(
                                                  context),
                                          postBloc: BlocProvider.of<PostBloc>(
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
                                  padding: EdgeInsets.only(
                                      left: widget.width * 0.07),
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
                                  padding: EdgeInsets.only(
                                      left: widget.width * 0.07),
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

class AccountIconContainer extends StatelessWidget {
  const AccountIconContainer({
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
          width: widget.width * 0.10,
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
    return FaIcon(
      FontAwesomeIcons.award,
      size: globalIconSizeMedium,
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
      width: widget.width * 0.55,
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
