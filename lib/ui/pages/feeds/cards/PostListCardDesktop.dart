import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/pages/feeds/cards/widets/ThumbPlayerWidgets.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'dart:io';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingDialog/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/Comments/CommentDialog.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/gifts/GiftDialog/GiftDialog.dart';
import 'package:dtube_go/ui/widgets/tags/TagChip.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PostListCardDesktop extends StatefulWidget {
  PostListCardDesktop(
      {Key? key,
      required this.blur,
      required this.defaultCommentVotingWeight,
      required this.defaultPostVotingWeight,
      required this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.autoPauseVideoOnPopup,
      required this.feedItem,
      required this.crossAxisCount,
      required this.width,
      this.deactivatePlayback,
      this.hideSpeedDial})
      : super(key: key);

  final bool blur;
  final bool autoPauseVideoOnPopup;
  final FeedItem feedItem;
  final String defaultCommentVotingWeight;
  final String defaultPostVotingWeight;
  final String defaultPostVotingTip;

  final String fixedDownvoteActivated;
  final String fixedDownvoteWeight;
  final int crossAxisCount;
  final double width;
  bool? deactivatePlayback;
  bool? hideSpeedDial;

  @override
  _PostListCardDesktopState createState() => _PostListCardDesktopState();
}

class _PostListCardDesktopState extends State<PostListCardDesktop> {
  double _avatarSize = globals.mobileMode ? 10.w : 2.w;
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
    _showVotingBars = false;
    _votingDirection = true;
    _showCommentInput = false;
    _showGiftInput = false;
    _userBloc = BlocProvider.of<UserBloc>(context);
    _bpController = VideoPlayerController.asset('assets/videos/firstpage.mp4');
    _ytController = YoutubePlayerController(
      initialVideoId: widget.feedItem.videoUrl,
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
      key: Key('postlist-large' + widget.feedItem.link),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;

        if (visiblePercentage < 95 &&
            !_showCommentInput &&
            !_showGiftInput &&
            !_showVotingBars) {
          _ytController.pause();
          _bpController.pause();
          print("VISIBILITY OF " +
              widget.feedItem.author +
              "/" +
              widget.feedItem.link +
              "CHANGED TO " +
              visiblePercentage.toString());
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PostData(
          disablePlayback:
              widget.deactivatePlayback != null && widget.deactivatePlayback!
                  ? true
                  : false,
          hideSpeedDial: widget.hideSpeedDial != null && widget.hideSpeedDial!
              ? true
              : false,
          author: widget.feedItem.author,
          link: widget.feedItem.link,
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
          blur: widget.blur,
          thumbUrl: widget.feedItem.thumbUrl,
          videoSource: widget.feedItem.videoSource,
          videoUrl: widget.feedItem.videoUrl,
          width: widget.width,
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
          autoPauseVideoOnPopup: widget.autoPauseVideoOnPopup,
          defaultCommentVotingWeight: widget.defaultCommentVotingWeight,
          defaultPostVotingTip: widget.defaultPostVotingTip,
          defaultPostVotingWeight: widget.defaultPostVotingWeight,
          feedItem: widget.feedItem,
          fixedDownvoteActivated: widget.fixedDownvoteActivated,
          fixedDownvoteWeight: widget.fixedDownvoteWeight,
          parentContext: context,
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
      required this.thumbnailTappedCallback,
      required this.votingOpenCallback,
      required this.commentOpenCallback,
      required this.giftOpenCallback,
      required this.videoSource,
      required this.videoUrl,
      required this.thumbUrl,
      required this.blur,
      required this.feedItem,
      required this.defaultCommentVotingWeight,
      required this.defaultPostVotingWeight,
      required this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.parentContext,
      required this.autoPauseVideoOnPopup,
      required this.width,
      required this.hideSpeedDial,
      required this.disablePlayback,
      required this.author,
      required this.link})
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
        super(key: key);

  final bool _thumbnailTapped;
  final PostListCardDesktop widget;
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

  final VoidCallback thumbnailTappedCallback;
  final VoidCallback votingOpenCallback;
  final VoidCallback commentOpenCallback;
  final VoidCallback giftOpenCallback;
  final String videoSource;
  final String videoUrl;
  final bool blur;
  final String thumbUrl;
  final FeedItem feedItem;
  final String defaultCommentVotingWeight;
  final String defaultPostVotingWeight;
  final String defaultPostVotingTip;

  final String fixedDownvoteActivated;
  final String fixedDownvoteWeight;
  final bool autoPauseVideoOnPopup;

  final BuildContext parentContext;
  final double width;
  bool disablePlayback;
  bool hideSpeedDial;
  final String author;
  final String link;

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
            if (!widget.disablePlayback) {
              widget.thumbnailTappedCallback();
            } else {
              navigateToPostDetailPage(
                  context, widget.author, widget.link, "none", false, () {});
            }
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
                placeholderWidth: widget.width * 0.9,
                placeholderSize: widget.width * 0.9,
              ),
            ],
          ),
        ),
        PostInfoBaseRow(
          hideSpeedDial: widget.hideSpeedDial,
          autoPauseVideoOnPopup: widget.autoPauseVideoOnPopup,
          defaultCommentVotingWeight: widget.defaultCommentVotingWeight,
          defaultPostVotingTip: widget.defaultPostVotingTip,
          defaultPostVotingWeight: widget.defaultPostVotingWeight,
          feedItem: widget.feedItem,
          fixedDownvoteActivated: widget.fixedDownvoteActivated,
          fixedDownvoteWeight: widget.fixedDownvoteWeight,
          parentContext: widget.parentContext,
          videoController: widget._bpController,
          ytController: widget._ytController,
          width: widget.width,
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
                width: widget.width,
                author: widget.feedItem.author,
                dist: widget.feedItem.dist,
                dur: int.tryParse(widget.feedItem.jsonString!.dur) != null
                    ? int.tryParse(widget.feedItem.jsonString!.dur)!
                    : 0,
                oc: widget.feedItem.jsonString!.oc == 1,
                tag: widget.feedItem.jsonString!.tag,
                ts: widget.feedItem.ts,
              )
            : FadeInDown(
                preferences:
                    AnimationPreferences(offset: Duration(milliseconds: 500)),
                child: PostInfoDetailsRow(
                  width: widget.width,
                  author: widget.feedItem.author,
                  dist: widget.feedItem.dist,
                  dur: int.tryParse(widget.feedItem.jsonString!.dur) != null
                      ? int.tryParse(widget.feedItem.jsonString!.dur)!
                      : 0,
                  oc: widget.feedItem.jsonString!.oc == 1,
                  tag: widget.feedItem.jsonString!.tag,
                  ts: widget.feedItem.ts,
                ),
              ),
      ],
    );
  }
}

class PostInfoDetailsRow extends StatelessWidget {
  const PostInfoDetailsRow(
      {Key? key,
      required this.width,
      required this.author,
      required this.dist,
      required this.dur,
      required this.oc,
      required this.tag,
      required this.ts})
      : super(key: key);

  final double width;
  final String author;

  final bool oc;
  final String tag;
  final int ts;
  final int dur;
  final double dist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                globals.disableAnimations
                    ? Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: AccountIconContainer(
                            authorName: author, avatarSize: 40),
                      )
                    : FadeIn(
                        preferences: AnimationPreferences(
                            offset: Duration(milliseconds: 500),
                            duration: Duration(seconds: 1)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: AccountIconContainer(
                              authorName: author, avatarSize: 40),
                        ),
                      ),
                SizedBox(width: width * 0.01),
                Container(
                  width: width * 0.3,
                  child: Text(
                    author,
                    //'@${width}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                oc
                    ? globals.disableAnimations
                        ? OriginalContentIcon()
                        : FadeIn(
                            preferences: AnimationPreferences(
                                offset: Duration(milliseconds: 700),
                                duration: Duration(seconds: 1)),
                            child: OriginalContentIcon(),
                          )
                    : SizedBox(width: globalIconSizeSmall),
                SizedBox(width: width * 0.01),
                TagChip(
                    waitBeforeFadeIn: Duration(milliseconds: 600),
                    fadeInFromLeft: false,
                    tagName: tag,
                    width: width * 0.2,
                    fontStyle: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  TimeAgo.timeInAgoTSShort(ts),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                dur > 0
                    ? Text(
                        ' - ' +
                            (new Duration(seconds: dur).inHours == 0
                                ? (new Duration(seconds: dur).inMinutes)
                                        .toString() +
                                    ' min'
                                : (new Duration(seconds: dur).inHours)
                                        .toString() +
                                    ' h'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : SizedBox(
                        width: 0,
                      ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  (dist / 100).round().toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: DTubeLogoShadowed(size: 20),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class PostInfoBaseRow extends StatelessWidget {
  PostInfoBaseRow(
      {Key? key,
      required this.ytController,
      required this.videoController,
      required this.votingCloseCallback,
      required this.votingOpenCallback,
      required this.commentOpenCallback,
      required this.commentCloseCallback,
      required this.giftOpenCallback,
      required this.giftCloseCallback,
      required this.feedItem,
      required this.defaultCommentVotingWeight,
      required this.defaultPostVotingWeight,
      required this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.parentContext,
      required this.autoPauseVideoOnPopup,
      required this.width,
      required this.hideSpeedDial})
      : super(key: key);

  final YoutubePlayerController ytController;
  final VideoPlayerController videoController;
  final VoidCallback votingOpenCallback;
  final VoidCallback commentOpenCallback;
  final VoidCallback giftOpenCallback;
  final VoidCallback votingCloseCallback;
  final VoidCallback commentCloseCallback;
  final VoidCallback giftCloseCallback;
  final FeedItem feedItem;
  final String defaultCommentVotingWeight;
  final String defaultPostVotingWeight;
  final String defaultPostVotingTip;

  final String fixedDownvoteActivated;
  final String fixedDownvoteWeight;
  final bool autoPauseVideoOnPopup;

  final BuildContext parentContext;
  final double width;
  final bool hideSpeedDial;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        globals.disableAnimations
            ? TitleWidgetForRow(
                author: feedItem.author,
                link: feedItem.link,
                title: feedItem.jsonString!.title,
                width: width * 0.65
                )
            : FadeInLeftBig(
                preferences: AnimationPreferences(
                  offset: Duration(milliseconds: 100),
                  duration: Duration(milliseconds: 350),
                ),
                child: TitleWidgetForRow(
                    author: feedItem.author,
                    link: feedItem.link,
                    title: feedItem.jsonString!.title,
                    width: width * 0.65),
              ),
        Container(
          width: width * 0.1,
          child: globals.keyPermissions.isEmpty || hideSpeedDial
              ? Container()
              : Align(
                  alignment: Alignment.centerRight,
                  child: SpeedDial(
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

                      activeChild: ShadowedIcon(
                          icon: FontAwesomeIcons.sortDown,
                          color: globalAlmostWhite,
                          shadowColor: Colors.black,
                          size: globalIconSizeMedium),

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
                      heroTag: 'submenu' + feedItem.jsonString!.title,
                      backgroundColor: Colors.transparent,
                      foregroundColor: globalAlmostWhite,
                      elevation: 0.0,
                      children: [
                        // DOWNVOTE BUTTON
                        SpeedDialChild(
                            child: ShadowedIcon(
                                visible: globals.keyPermissions.contains(5),
                                icon: FontAwesomeIcons.flag,
                                color: !feedItem.alreadyVoted!
                                    ? globalAlmostWhite
                                    : globalRed,
                                shadowColor: Colors.black,
                                size: globalIconSizeMedium),
                            foregroundColor: globalAlmostWhite,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            onTap: () {
                              if (!feedItem.alreadyVoted!) {
                                if (autoPauseVideoOnPopup) {
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
                                      defaultVote:
                                          double.parse(defaultPostVotingWeight),
                                      defaultTip:
                                          double.parse(defaultPostVotingTip),
                                      postBloc: PostBloc(
                                          repository: PostRepositoryImpl()),
                                      txBloc: BlocProvider.of<TransactionBloc>(
                                          context),
                                      author: feedItem.author,
                                      link: feedItem.link,
                                      downvote: true,
                                      //currentVT: state.vtBalance['v']! + 0.0,
                                      isPost: true,
                                      fixedDownvoteActivated:
                                          fixedDownvoteActivated == "true",
                                      fixedDownvoteWeight:
                                          double.parse(fixedDownvoteWeight),
                                      okCallback: () {
                                        votingCloseCallback();
                                        if (autoPauseVideoOnPopup) {
                                          ytController.play();
                                          videoController.play();
                                        }
                                      },
                                      cancelCallback: () {
                                        votingCloseCallback();
                                        if (autoPauseVideoOnPopup) {
                                          ytController.play();
                                          videoController.play();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }
                            }),

                        // COMMENT BUTTON
                        SpeedDialChild(
                            child: ShadowedIcon(
                                visible: globals.keyPermissions.contains(4),
                                icon: FontAwesomeIcons.comment,
                                color: globalAlmostWhite,
                                shadowColor: Colors.black,
                                size: globalIconSizeMedium),
                            foregroundColor: globalAlmostWhite,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            onTap: () {
                              if (autoPauseVideoOnPopup) {
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
                                    txBloc: BlocProvider.of<TransactionBloc>(
                                        context),
                                    originAuthor: feedItem.author,
                                    originLink: feedItem.link,
                                    defaultCommentVote: double.parse(
                                        defaultCommentVotingWeight),
                                    okCallback: () {
                                      commentCloseCallback();
                                      if (autoPauseVideoOnPopup) {
                                        ytController.play();
                                        videoController.play();
                                      }
                                    },
                                    cancelCallback: () {
                                      commentCloseCallback();
                                      if (autoPauseVideoOnPopup) {
                                        ytController.play();
                                        videoController.play();
                                      }
                                    },
                                  ),
                                ),
                              );
                            }),

                        // UPVOTE BUTTON

                        SpeedDialChild(
                            child: ShadowedIcon(
                                visible: globals.keyPermissions.contains(5),
                                icon: FontAwesomeIcons.heart,
                                color: !feedItem.alreadyVoted!
                                    ? globalAlmostWhite
                                    : globalRed,
                                shadowColor: Colors.black,
                                size: globalIconSizeMedium),
                            foregroundColor: globalAlmostWhite,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            onTap: () {
                              if (!feedItem.alreadyVoted!) {
                                votingOpenCallback();
                                if (autoPauseVideoOnPopup) {
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
                                      defaultVote:
                                          double.parse(defaultPostVotingWeight),
                                      defaultTip:
                                          double.parse(defaultPostVotingTip),
                                      postBloc: PostBloc(
                                          repository: PostRepositoryImpl()),
                                      txBloc: BlocProvider.of<TransactionBloc>(
                                          context),
                                      author: feedItem.author,
                                      link: feedItem.link,
                                      downvote: false,
                                      //currentVT: state.vtBalance['v']! + 0.0,
                                      isPost: true,
                                      fixedDownvoteActivated:
                                          fixedDownvoteActivated == "true",
                                      fixedDownvoteWeight:
                                          double.parse(fixedDownvoteWeight),
                                      okCallback: () {
                                        votingCloseCallback();
                                        if (autoPauseVideoOnPopup) {
                                          ytController.play();
                                          videoController.play();
                                        }
                                      },
                                      cancelCallback: () {
                                        votingCloseCallback();
                                        if (autoPauseVideoOnPopup) {
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
                                visible: globals.keyPermissions.contains(3),
                                icon: FontAwesomeIcons.gift,
                                color: globalAlmostWhite,
                                shadowColor: Colors.black,
                                size: globalIconSizeMedium),
                            foregroundColor: globalAlmostWhite,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            onTap: () {
                              if (autoPauseVideoOnPopup) {
                                videoController.pause();
                                ytController.pause();
                              }
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => GiftDialog(
                                  okCallback: () {
                                    giftCloseCallback();
                                    if (autoPauseVideoOnPopup) {
                                      ytController.play();
                                      videoController.play();
                                    }
                                  },
                                  cancelCallback: () {
                                    giftCloseCallback();
                                    if (autoPauseVideoOnPopup) {
                                      ytController.play();
                                      videoController.play();
                                    }
                                  },
                                  txBloc:
                                      BlocProvider.of<TransactionBloc>(context),
                                  receiver: feedItem.author,
                                  originLink: feedItem.link,
                                ),
                              );
                            }),
                      ]),
                ),
        ),
      ],
    );
  }
}

class AccountIconContainer extends StatelessWidget {
  const AccountIconContainer({
    Key? key,
    required this.authorName,
    required double avatarSize,
  })  : _avatarSize = avatarSize,
        super(key: key);

  final double _avatarSize;
  final String authorName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToUserDetailPage(context, authorName, () {});
      },
      child: SizedBox(
          width: globals.mobileMode ? 10.w : _avatarSize,
          child: AccountIconBase(
            avatarSize: _avatarSize,
            showVerified: true,
            username: authorName,
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
  const TitleWidgetForRow(
      {Key? key,
      required this.author,
      required this.link,
      required this.title,
      required this.width})
      : super(key: key);

  final String author;
  final String link;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 4.5.h,
      child: InkWell(
        onTap: () {
          navigateToPostDetailPage(context, author, link, "none", false, () {});
        },
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
