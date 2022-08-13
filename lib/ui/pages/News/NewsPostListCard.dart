import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'dart:io';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/Random/randomGenerator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/ui/widgets/players/YTplayerIframe.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class NewsPostListCard extends StatefulWidget {
  const NewsPostListCard({
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

  @override
  _NewsPostListCardState createState() => _NewsPostListCardState();
}

class _NewsPostListCardState extends State<NewsPostListCard> {
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
      key: Key('newslist-large' + widget.link),
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
  final NewsPostListCard widget;
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
    return DTubeFormCard(
      avoidAnimation: true,
      waitBeforeFadeIn: Duration(seconds: 0),
      childs: [
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

class PostInfoDetailsRow extends StatelessWidget {
  const PostInfoDetailsRow({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final NewsPostListCard widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '@${widget.author}',
          style: Theme.of(context).textTheme.bodyText2,
          overflow: TextOverflow.ellipsis,
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
  })  : _avatarSize = avatarSize,
        super(key: key);

  final NewsPostListCard widget;

  final double _avatarSize;
  YoutubePlayerController ytController;
  VideoPlayerController videoController;

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

  final NewsPostListCard widget;
  final double _avatarSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToUserDetailPage(context, widget.author, () {});
      },
      child: AccountIconBase(
        avatarSize: _avatarSize,
        showVerified: true,
        username: widget.author,
      ),
    );
  }
}

class TitleWidgetForRow extends StatelessWidget {
  const TitleWidgetForRow({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final NewsPostListCard widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
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
