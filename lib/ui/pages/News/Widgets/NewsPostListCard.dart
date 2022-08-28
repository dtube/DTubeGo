import 'package:dtube_go/ui/pages/feeds/cards/widets/ThumbPlayerWidgets.dart';
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
  const NewsPostListCard(
      {Key? key,
      required this.thumbnailUrl,
      required this.title,
      required this.description,
      required this.author,
      required this.link,
      required this.publishDate,
      required this.videoUrl,
      required this.videoSource,
      required this.indexOfList,
      required this.mainTag,
      required this.oc,
      required this.autoPauseVideoOnPopup,
      required this.crossAxisCount})
      : super(key: key);

  final bool autoPauseVideoOnPopup;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String author;
  final String link;
  final String publishDate;

  final String videoUrl;
  final String videoSource;

  final int indexOfList;
  final String mainTag;
  final bool oc;
  final int crossAxisCount;

  @override
  _NewsPostListCardState createState() => _NewsPostListCardState();
}

class _NewsPostListCardState extends State<NewsPostListCard> {
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
          author: widget.author,
          link: widget.link,
          publishDate: widget.publishDate,
          title: widget.title,
          bpController: _bpController,
          ytController: _ytController,
          userBloc: _userBloc,
          thumbUrl: widget.thumbnailUrl,
          videoSource: widget.videoSource,
          videoUrl: widget.videoUrl,
          crossAxisCount: widget.crossAxisCount,
          thumbnailTappedCallback: () {
            setState(() {
              _thumbnailTapped = true;
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
      required VideoPlayerController bpController,
      required YoutubePlayerController ytController,
      required UserBloc userBloc,
      required this.thumbnailTappedCallback,
      required this.author,
      required this.link,
      required this.title,
      required this.publishDate,
      required this.videoSource,
      required this.videoUrl,
      required this.thumbUrl,
      required this.crossAxisCount})
      : _thumbnailTapped = thumbnailTapped,
        _bpController = bpController,
        _ytController = ytController,
        super(key: key);

  final bool _thumbnailTapped;
  final VideoPlayerController _bpController;

  final YoutubePlayerController _ytController;

  final String author;
  final String link;
  final String publishDate;
  final String title;

  final VoidCallback thumbnailTappedCallback;

  final String videoSource;
  final String videoUrl;

  final String thumbUrl;
  final int crossAxisCount;

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
            if (widget.videoSource != "") {
              widget.thumbnailTappedCallback();
            }
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ThumbnailWidget(
                  thumbnailTapped: widget._thumbnailTapped,
                  blur: false,
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
          videoController: widget._bpController,
          ytController: widget._ytController,
          author: widget.author,
          link: widget.link,
          title: widget.title,
          crossAxisCount: widget.crossAxisCount,
        ),
        globals.disableAnimations
            ? PostInfoDetailsRow(
                author: widget.author,
                publishDate: widget.publishDate,
              )
            : FadeInDown(
                preferences:
                    AnimationPreferences(offset: Duration(milliseconds: 500)),
                child: PostInfoDetailsRow(
                  author: widget.author,
                  publishDate: widget.publishDate,
                ),
              ),
        SizedBox(height: 1.h),
      ],
    );
  }
}

class PostInfoDetailsRow extends StatelessWidget {
  const PostInfoDetailsRow(
      {Key? key, required this.author, required this.publishDate})
      : super(key: key);

  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '@${author}',
          style: Theme.of(context).textTheme.bodyText2,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [
            Text(
              publishDate,
              style: Theme.of(context).textTheme.bodyText2,
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
      required this.author,
      required this.link,
      required this.title,
      required this.crossAxisCount})
      : super(key: key);

  YoutubePlayerController ytController;
  VideoPlayerController videoController;
  final String author;
  final String link;
  final String title;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            globals.disableAnimations
                ? AuthorContainer(
                    author: author,
                    avatarSize: crossAxisCount == 1 ? 10.w : 3.w,
                  )
                : FadeIn(
                    preferences: AnimationPreferences(
                        offset: Duration(milliseconds: 500),
                        duration: Duration(seconds: 1)),
                    child: AuthorContainer(
                      author: author,
                      avatarSize: crossAxisCount == 1 ? 10.w : 3.w,
                    )),
            // SizedBox(width: 1.w),
            globals.disableAnimations
                ? TitleContainer(
                    author: author,
                    link: link,
                    title: title,
                    crossAxisCount: crossAxisCount,
                  )
                : FadeInLeftBig(
                    preferences: AnimationPreferences(
                      offset: Duration(milliseconds: 100),
                      duration: Duration(milliseconds: 350),
                    ),
                    child: TitleContainer(
                      author: author,
                      link: link,
                      title: title,
                      crossAxisCount: crossAxisCount,
                    )),
          ],
        ),
      ],
    );
  }
}

class AuthorContainer extends StatelessWidget {
  const AuthorContainer({
    Key? key,
    required this.author,
    required double avatarSize,
  })  : _avatarSize = avatarSize,
        super(key: key);

  final double _avatarSize;
  final String author;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToUserDetailPage(context, author, () {});
      },
      child: AccountIconBase(
        avatarSize: _avatarSize,
        showVerified: true,
        username: author,
      ),
    );
  }
}

class TitleContainer extends StatelessWidget {
  const TitleContainer({
    Key? key,
    required this.author,
    required this.link,
    required this.title,
    required this.crossAxisCount,
  }) : super(key: key);

  final String author;
  final String link;
  final String title;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: crossAxisCount == 1
          ? 70.w
          : crossAxisCount == 2
              ? 35.w
              : 18.w,
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
