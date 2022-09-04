import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/pages/feeds/cards/widets/CollapsedDescription.dart';
import 'package:dtube_go/ui/pages/feeds/cards/widets/ThumbPlayerWidgets.dart';
import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'dart:io';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingDialog/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/Comments/CommentDialog.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/gifts/GiftDialog/GiftDialog.dart';
import 'package:dtube_go/ui/widgets/tags/TagChip.dart';
import 'package:dtube_go/utils/Random/randomGenerator.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

class PostResultCardDesktop extends StatefulWidget {
  const PostResultCardDesktop(
      {Key? key,
      required this.blur,
      required this.defaultCommentVotingWeight,
      required this.defaultPostVotingWeight,
      required this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.autoPauseVideoOnPopup,
      required this.crossAxisCount,
      required this.width,
      required this.author,
      required this.link,
      required this.videoUrl,
      required this.thumbUrl,
      required this.videoSource,
      required this.alreadyVoted,
      required this.dist,
      required this.dur,
      required this.oc,
      required this.tag,
      required this.title,
      required this.ts})
      : super(key: key);

  final bool blur;
  final bool autoPauseVideoOnPopup;

  final String defaultCommentVotingWeight;
  final String defaultPostVotingWeight;
  final String defaultPostVotingTip;

  final String fixedDownvoteActivated;
  final String fixedDownvoteWeight;
  final int crossAxisCount;
  final double width;
  final String author;
  final String link;
  final String videoUrl;
  final String thumbUrl;
  final String videoSource;
  final double dist;
  final int oc;
  final bool alreadyVoted;
  final String dur;
  final int ts;
  final String title;
  final String tag;

  @override
  _PostResultCardDesktopState createState() => _PostResultCardDesktopState();
}

class _PostResultCardDesktopState extends State<PostResultCardDesktop> {
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
          thumbUrl: widget.thumbUrl,
          videoSource: widget.videoSource,
          videoUrl: widget.videoUrl,
          width: widget.width,
          alreadyVoted: widget.alreadyVoted,
          author: widget.author,
          dist: widget.dist,
          dur: widget.dur,
          link: widget.link,
          oc: widget.oc,
          tag: widget.tag,
          title: widget.title,
          ts: widget.ts,
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
      required this.defaultCommentVotingWeight,
      required this.defaultPostVotingWeight,
      required this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.parentContext,
      required this.autoPauseVideoOnPopup,
      required this.width,
      required this.author,
      required this.oc,
      required this.dist,
      required this.tag,
      required this.dur,
      required this.alreadyVoted,
      required this.link,
      required this.title,
      required this.ts})
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
  final PostResultCardDesktop widget;
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

  final String defaultCommentVotingWeight;
  final String defaultPostVotingWeight;
  final String defaultPostVotingTip;

  final String fixedDownvoteActivated;
  final String fixedDownvoteWeight;
  final bool autoPauseVideoOnPopup;

  final BuildContext parentContext;
  final double width;
  final String author;
  final double dist;
  final int oc;
  final String tag;
  final int ts;
  final String dur;
  final String link;
  final String title;
  final bool alreadyVoted;

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
                placeholderWidth: widget.width * 0.9,
                placeholderSize: widget.width * 0.9,
              ),
            ],
          ),
        ),
        PostInfoBaseRow(
          autoPauseVideoOnPopup: widget.autoPauseVideoOnPopup,
          defaultCommentVotingWeight: widget.defaultCommentVotingWeight,
          defaultPostVotingTip: widget.defaultPostVotingTip,
          defaultPostVotingWeight: widget.defaultPostVotingWeight,
          fixedDownvoteActivated: widget.fixedDownvoteActivated,
          fixedDownvoteWeight: widget.fixedDownvoteWeight,
          parentContext: widget.parentContext,
          videoController: widget._bpController,
          ytController: widget._ytController,
          alreadyVoted: widget.alreadyVoted,
          author: widget.author,
          link: widget.link,
          title: widget.title,
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
                author: widget.author,
                dist: widget.dist,
                dur: int.tryParse(widget.dur) != null
                    ? int.tryParse(widget.dur)!
                    : 0,
                oc: widget.oc == 1,
                tag: widget.tag,
                ts: widget.ts,
              )
            : FadeInDown(
                preferences:
                    AnimationPreferences(offset: Duration(milliseconds: 500)),
                child: PostInfoDetailsRow(
                  width: widget.width,
                  author: widget.author,
                  dist: widget.dist,
                  dur: int.tryParse(widget.dur) != null
                      ? int.tryParse(widget.dur)!
                      : 0,
                  oc: widget.oc == 1,
                  tag: widget.tag,
                  ts: widget.ts,
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
                    ? AccountIconContainer(authorName: author, avatarSize: 40)
                    : FadeIn(
                        preferences: AnimationPreferences(
                            offset: Duration(milliseconds: 500),
                            duration: Duration(seconds: 1)),
                        child: AccountIconContainer(
                            authorName: author, avatarSize: 40),
                      ),
                SizedBox(width: width * 0.01),
                Container(
                  width: width * 0.3,
                  child: Text(
                    author,
                    //'@${width}',
                    style: Theme.of(context).textTheme.bodyText2,
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
                    fontStyle: Theme.of(context).textTheme.caption),
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
                  style: Theme.of(context).textTheme.bodyText2,
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
                        style: Theme.of(context).textTheme.bodyText2,
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
                  style: Theme.of(context).textTheme.headline5,
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
      required this.defaultCommentVotingWeight,
      required this.defaultPostVotingWeight,
      required this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.parentContext,
      required this.autoPauseVideoOnPopup,
      required this.width,
      required this.alreadyVoted,
      required this.author,
      required this.link,
      required this.title})
      : super(key: key);

  final YoutubePlayerController ytController;
  final VideoPlayerController videoController;
  final VoidCallback votingOpenCallback;
  final VoidCallback commentOpenCallback;
  final VoidCallback giftOpenCallback;
  final VoidCallback votingCloseCallback;
  final VoidCallback commentCloseCallback;
  final VoidCallback giftCloseCallback;

  final String defaultCommentVotingWeight;
  final String defaultPostVotingWeight;
  final String defaultPostVotingTip;

  final String fixedDownvoteActivated;
  final String fixedDownvoteWeight;
  final bool autoPauseVideoOnPopup;

  final BuildContext parentContext;
  final double width;
  final String author;
  final String link;
  final String title;
  final bool alreadyVoted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        globals.disableAnimations
            ? TitleWidgetForRow(
                author: author, link: link, title: title, width: width * 0.8)
            : FadeInLeftBig(
                preferences: AnimationPreferences(
                  offset: Duration(milliseconds: 100),
                  duration: Duration(milliseconds: 350),
                ),
                child: TitleWidgetForRow(
                    author: author,
                    link: link,
                    title: title,
                    width: width * 0.8),
              ),
        Container(
          width: width * 0.1,
          child: globals.keyPermissions.isEmpty
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
                      heroTag: 'submenu' + title,
                      backgroundColor: Colors.transparent,
                      foregroundColor: globalAlmostWhite,
                      elevation: 0.0,
                      children: [
                        // COMMENT BUTTON
                        SpeedDialChild(
                            child: ShadowedIcon(
                                visible: globals.keyPermissions.contains(4),
                                icon: FontAwesomeIcons.comment,
                                color: globalAlmostWhite,
                                shadowColor: Colors.black,
                                size: globalIconSizeBig),
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
                                    originAuthor: author,
                                    originLink: link,
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
                        // DOWNVOTE BUTTON
                        SpeedDialChild(
                            child: ShadowedIcon(
                                visible: globals.keyPermissions.contains(5),
                                icon: FontAwesomeIcons.flag,
                                color: alreadyVoted!
                                    ? globalAlmostWhite
                                    : globalRed,
                                shadowColor: Colors.black,
                                size: globalIconSizeBig),
                            foregroundColor: globalAlmostWhite,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            onTap: () {
                              if (alreadyVoted!) {
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
                                      postBloc:
                                          BlocProvider.of<PostBloc>(context),
                                      txBloc: BlocProvider.of<TransactionBloc>(
                                          context),
                                      author: author,
                                      link: link,
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
                        // UPVOTE BUTTON

                        SpeedDialChild(
                            child: ShadowedIcon(
                                visible: globals.keyPermissions.contains(5),
                                icon: FontAwesomeIcons.heart,
                                color: alreadyVoted
                                    ? globalAlmostWhite
                                    : globalRed,
                                shadowColor: Colors.black,
                                size: globalIconSizeBig),
                            foregroundColor: globalAlmostWhite,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            onTap: () {
                              if (alreadyVoted) {
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
                                      postBloc:
                                          BlocProvider.of<PostBloc>(context),
                                      txBloc: BlocProvider.of<TransactionBloc>(
                                          context),
                                      author: author,
                                      link: link,
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
                                size: globalIconSizeBig),
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
                                  receiver: author,
                                  originLink: link,
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
      child: InkWell(
        onTap: () {
          navigateToPostDetailPage(context, author, link, "none", false, () {});
        },
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}