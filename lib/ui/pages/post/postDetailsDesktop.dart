import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedListSuggested.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedListSuggestedPosts.dart';
import 'package:dtube_go/ui/pages/post/widgets/Comments.dart';
import 'package:dtube_go/ui/pages/post/widgets/DTubeCoinsChip.dart';
import 'package:dtube_go/ui/pages/post/widgets/ShareAndCommentChiips.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingAndGiftingButtons.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc.dart';
import 'package:dtube_go/bloc/feed/feed_event.dart';
import 'package:dtube_go/bloc/feed/feed_repository.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedListCarousel.dart';
import 'package:dtube_go/ui/widgets/Suggestions/SuggestedChannels.dart';
import 'package:dtube_go/ui/MainContainer/NavigationContainer.dart';
import 'package:dtube_go/ui/widgets/tags/TagChip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/pages/post/widgets/CollapsedDescription.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'dart:io' show Platform;

class PostDetailPageDesktop extends StatefulWidget {
  String link;
  String author;
  bool recentlyUploaded;
  String directFocus;
  VoidCallback? onPop;

  PostDetailPageDesktop(
      {required this.link,
      required this.author,
      required this.recentlyUploaded,
      required this.directFocus,
      this.onPop});

  @override
  _PostDetailPageDesktopState createState() => _PostDetailPageDesktopState();
}

class _PostDetailPageDesktopState extends State<PostDetailPageDesktop> {
  int reloadCount = 0;
  bool flagged = false;

  Future<bool> _onWillPop() async {
    if (widget.recentlyUploaded) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MultiBlocProvider(providers: [
                    BlocProvider<UserBloc>(
                      create: (BuildContext context) =>
                          UserBloc(repository: UserRepositoryImpl()),
                    ),
                    BlocProvider<AuthBloc>(
                      create: (BuildContext context) =>
                          AuthBloc(repository: AuthRepositoryImpl()),
                    ),
                  ], child: NavigationContainer())),
          (route) => false);
    } else {
      Navigator.pop(context);
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (BuildContext context) =>
              PostBloc(repository: PostRepositoryImpl())
                ..add(FetchPostEvent(
                    widget.author, widget.link, "PageDetailsPageV2.dart 1")),
        ),
        BlocProvider<UserBloc>(
            create: (BuildContext context) =>
                UserBloc(repository: UserRepositoryImpl())),
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) =>
              SettingsBloc()..add(FetchSettingsEvent()),
        ),
      ],
      // child: WillPopScope(
      //     onWillPop: _onWillPop,
      child: new WillPopScope(
          onWillPop: () async {
            if (widget.onPop != null) {
              widget.onPop!();
              if (flagged) {
                await Future.delayed(Duration(seconds: 3));
                Phoenix.rebirth(context);
              }
            }

            return true;
          },
          child: Scaffold(
            // resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: true,
            // backgroundColor: Colors.transparent,
            appBar: kIsWeb
                ? null
                : AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    toolbarHeight: 28,
                  ),
            body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
              if (state is PostLoadingState) {
                return Center(
                  child: DtubeLogoPulseWithSubtitle(
                    subtitle: "loading post details...",
                    size: 10.w,
                  ),
                );
              } else if (state is PostLoadedState) {
                reloadCount++;
                if (!state.post.isFlaggedByUser) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PostDetails(
                      post: state.post,
                      directFocus:
                          reloadCount <= 1 ? widget.directFocus : "none",
                    ),
                  );
                } else {
                  flagged = true;

                  return Center(
                      child: Text("this post got flagged by you!",
                          style: Theme.of(context).textTheme.headline4));
                }
              } else {
                return Center(
                  child: DtubeLogoPulseWithSubtitle(
                    subtitle: "loading post details...",
                    size: 10.w,
                  ),
                );
              }
            }),
          )
          //)
          ),
    );
  }
}

class PostDetails extends StatefulWidget {
  final Post post;
  final String directFocus;

  const PostDetails({Key? key, required this.post, required this.directFocus})
      : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  late YoutubePlayerController _controller;
  late VideoPlayerController _videocontroller;

  late UserBloc _userBloc;

  double _defaultVoteWeightPosts = 0;
  double _defaultVoteWeightComments = 0;
  double _defaultVoteTipPosts = 0;
  double _defaultVoteTipComments = 0;

  bool _fixedDownvoteActivated = true;
  double _fixedDownvoteWeight = 1;

  int _currentVT = 0;
  String blockedUsers = "";
  late PostBloc postBloc = new PostBloc(repository: PostRepositoryImpl());
  late TransactionBloc txBloc =
      new TransactionBloc(repository: TransactionRepositoryImpl());

  double suggestedSize = 350;

  void fetchBlockedUsers() async {
    blockedUsers = await sec.getBlockedUsers();
  }

  @override
  void initState() {
    super.initState();
    fetchBlockedUsers();

    _userBloc = BlocProvider.of<UserBloc>(context);

    _userBloc.add(FetchAccountDataEvent(username: widget.post.author));
    _userBloc.add(FetchDTCVPEvent());

    _controller = YoutubePlayerController(
      initialVideoId: widget.post.videoUrl!,
      params: YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          desktopMode: true,
          privacyEnhanced: true,
          useHybridComposition: true,
          autoPlay: !(widget.directFocus != "none")),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      print('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      print('Exited Fullscreen');
    };
    _videocontroller =
        VideoPlayerController.asset('assets/videos/firstpage.mp4');
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return BlocListener<TransactionBloc, TransactionState>(
      bloc: txBloc,
      listener: (context, state) {
        if (state is TransactionSent) {
          postBloc.add(FetchPostEvent(widget.post.author, widget.post.link,
              "PostDetailPageV2.dart listener 1"));
        }
      },
      child: YoutubePlayerControllerProvider(
          controller: _controller,
          child: Container(
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Container(
                              width: 100.w - suggestedSize,
                              alignment: Alignment.centerLeft,
                              child: globals.disableAnimations
                                  ? TitleWidget(
                                      title: widget.post.jsonString!.title,
                                      author: widget.post.author,
                                      width: 100.w - suggestedSize,
                                    )
                                  : FadeInLeft(
                                      preferences: AnimationPreferences(
                                          offset: Duration(milliseconds: 700),
                                          duration: Duration(seconds: 1)),
                                      child: TitleWidget(
                                          title: widget.post.jsonString!.title,
                                          author: widget.post.author,
                                          width: 100.w - suggestedSize),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.w - suggestedSize,
                            child: Column(
                              children: [
                                //player /thumbnail
                                widget.post.videoSource == "youtube"
                                    ? player
                                    : ["ipfs", "sia"]
                                            .contains(widget.post.videoSource)
                                        ? ChewiePlayer(
                                            videoUrl: widget.post.videoUrl!,
                                            autoplay:
                                                !(widget.directFocus != "none"),
                                            looping: false,
                                            localFile: false,
                                            controls: true,
                                            usedAsPreview: false,
                                            allowFullscreen: true,
                                            portraitVideoPadding: 5.w,
                                            videocontroller: _videocontroller,
                                            placeholderWidth: 100.w,
                                            placeholderSize: 40.w,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: widget.post.thumbUrl!),

                                SizedBox(
                                  height: 2.h,
                                ),
                                FadeIn(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.post.tags.length > 0
                                          ? Row(
                                              children: [
                                                widget.post.jsonString!.oc == 1
                                                    ? SizedBox(
                                                        width:
                                                            globalIconSizeMedium,
                                                        child: FaIcon(
                                                            FontAwesomeIcons
                                                                .award,
                                                            size:
                                                                globalIconSizeMedium))
                                                    : SizedBox(width: 0),
                                                Container(
                                                  width:
                                                      (100.w - suggestedSize) *
                                                          0.6,
                                                  height: 5.h,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: widget
                                                          .post.tags.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0),
                                                          child: TagChip(
                                                              waitBeforeFadeIn:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              fadeInFromLeft:
                                                                  true,
                                                              width: 10.w,
                                                              tagName: widget
                                                                  .post
                                                                  .tags[index]
                                                                  .toString()),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            )
                                          : SizedBox(height: 0),
                                      globals.disableAnimations
                                          ? DtubeCoinsChip(
                                              dist: widget.post.dist,
                                              post: widget.post,
                                              width: 2.w,
                                            )
                                          : BounceIn(
                                              preferences: AnimationPreferences(
                                                  offset: Duration(
                                                      milliseconds: 1200)),
                                              child: DtubeCoinsChip(
                                                dist: widget.post.dist,
                                                post: widget.post,
                                                width: 2.w,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                globals.disableAnimations
                                    ? VotingAndGiftBButtons(
                                        author: widget.post.author,
                                        link: widget.post.link,
                                      )
                                    : FadeInRight(
                                        preferences: AnimationPreferences(
                                            offset:
                                                Duration(milliseconds: 200)),
                                        child: VotingAndGiftBButtons(
                                          author: widget.post.author,
                                          link: widget.post.link,
                                        )),
                                globals.disableAnimations
                                    ? CollapsedDescription(
                                        startCollapsed: false,
                                        description:
                                            widget.post.jsonString!.desc != null
                                                ? widget.post.jsonString!.desc!
                                                : "")
                                    : FadeInDown(
                                        child: CollapsedDescription(
                                            startCollapsed: false,
                                            description: widget.post.jsonString!
                                                        .desc !=
                                                    null
                                                ? widget.post.jsonString!.desc!
                                                : ""),
                                      ),
                                globals.disableAnimations
                                    ? ShareAndCommentChips(
                                        author: widget.post.author,
                                        link: widget.post.link,
                                        directFocus: widget.directFocus,
                                        defaultVoteWeightComments:
                                            _defaultVoteWeightComments,
                                        postBloc: postBloc,
                                        txBloc: txBloc)
                                    : FadeInUp(
                                        child: ShareAndCommentChips(
                                            author: widget.post.author,
                                            link: widget.post.link,
                                            directFocus: widget.directFocus,
                                            defaultVoteWeightComments:
                                                _defaultVoteWeightComments,
                                            postBloc: postBloc,
                                            txBloc: txBloc),
                                      ),
                                SizedBox(height: 16),
                                MultiBlocProvider(
                                    providers: [
                                      BlocProvider<TransactionBloc>.value(
                                          value: txBloc),
                                      BlocProvider<UserBloc>(
                                          create: (BuildContext context) =>
                                              UserBloc(
                                                  repository:
                                                      UserRepositoryImpl())),
                                    ],
                                    child: widget.post.comments != null &&
                                            widget.post.comments!.length > 0
                                        ? globals.disableAnimations
                                            ? CommentContainer(
                                                shrinkButtons: false,
                                                avatarSize: 3.w,
                                                height: (14.h *
                                                            (widget.post.comments == null
                                                                ? 1
                                                                : widget
                                                                    .post
                                                                    .comments!
                                                                    .length)) >
                                                        42.h
                                                    ? 42.h
                                                    : 14.h *
                                                        (widget.post.comments ==
                                                                null
                                                            ? 1
                                                            : widget.post.comments!
                                                                .length),
                                                defaultVoteWeightComments:
                                                    _defaultVoteWeightComments,
                                                defaultVoteTipComments:
                                                    _defaultVoteTipComments,
                                                blockedUsers: blockedUsers,
                                                fixedDownvoteActivated:
                                                    _fixedDownvoteActivated,
                                                fixedDownvoteWeight:
                                                    _fixedDownvoteWeight,
                                                postBloc: postBloc
                                                  ..add(FetchPostEvent(
                                                      widget.post.author,
                                                      widget.post.link,
                                                      "PageDetailsPageV2.dart 2")),
                                                txBloc: txBloc)
                                            : SlideInLeft(
                                                child: CommentContainer(
                                                    shrinkButtons: false,
                                                    height: (14.h *
                                                                (widget.post.comments ==
                                                                        null
                                                                    ? 1
                                                                    : widget
                                                                        .post.comments!.length)) >
                                                            42.h
                                                        ? 42.h
                                                        : 14.h *
                                                            (widget.post.comments ==
                                                                    null
                                                                ? 1
                                                                : widget
                                                                    .post
                                                                    .comments!
                                                                    .length),
                                                    avatarSize: 3.w,
                                                    defaultVoteWeightComments:
                                                        _defaultVoteWeightComments,
                                                    defaultVoteTipComments:
                                                        _defaultVoteTipComments,
                                                    blockedUsers: blockedUsers,
                                                    fixedDownvoteActivated:
                                                        _fixedDownvoteActivated,
                                                    fixedDownvoteWeight:
                                                        _fixedDownvoteWeight,
                                                    postBloc: postBloc
                                                      ..add(FetchPostEvent(
                                                          widget.post.author,
                                                          widget.post.link,
                                                          "PageDetailsPageV2.dart 3")),
                                                    txBloc: txBloc),
                                              )
                                        : SizedBox(height: 0)),

                                SizedBox(height: 200)
                              ],
                            ),
                          ),
                          BlocProvider<FeedBloc>(
                            create: (context) =>
                                FeedBloc(repository: FeedRepositoryImpl())
                                  ..add(FetchSuggestedPostsForPost(
                                      currentUsername: widget.post.author,
                                      tags: widget.post.tags)),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FeedListSuggestedPosts(
                                feedType: 'SuggestedPosts',
                                width: suggestedSize * 0.9,
                                scrollCallback: (bool) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget(
      {Key? key,
      required this.title,
      required this.author,
      required this.width})
      : super(key: key);

  final String title;
  final String author;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width * 0.7,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline3,
            maxLines: 3,
          ),
        ),
        Container(
          child: globals.disableAnimations
              ? AccountNavigationChip(
                  author: author,
                  size: width * 0.2,
                )
              : SlideInDown(
                  preferences:
                      AnimationPreferences(offset: Duration(milliseconds: 500)),
                  child: AccountNavigationChip(author: author, size: 20.w),
                ),
        ),
      ],
    );
  }
}
