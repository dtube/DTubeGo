import 'dart:io';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/ui/pages/post/widgets/DTubeCoinsChip.dart';
import 'package:dtube_go/ui/pages/post/widgets/ShareAndCommentChiips.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc.dart';
import 'package:dtube_go/bloc/feed/feed_event.dart';
import 'package:dtube_go/bloc/feed/feed_repository.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedListCarousel.dart';
import 'package:dtube_go/ui/widgets/Suggestions/SuggestedChannels.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/gifts/GiftBoxWidget.dart';
import 'package:dtube_go/ui/widgets/tags/TagChip.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:dtube_go/utils/Strings/shortBalanceStrings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/pages/post/widgets/CollapsedDescription.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_go/utils/GlobalStorage/secureStorage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class WebPostDetails extends StatefulWidget {
  final Post post;
  final String directFocus;

  const WebPostDetails({
    Key? key,
    required this.post,
    required this.directFocus,
  }) : super(key: key);

  @override
  _WebPostDetailsState createState() => _WebPostDetailsState();
}

class _WebPostDetailsState extends State<WebPostDetails> {
  late YoutubePlayerController _controller;
  late VideoPlayerController _videocontroller;

  late UserBloc _userBloc;

  late double _defaultVoteWeightPosts = 0;
  late double _defaultVoteWeightComments = 0;
  late double _defaultVoteTipPosts = 0;
  late double _defaultVoteTipComments = 0;

  late bool _fixedDownvoteActivated = true;
  late double _fixedDownvoteWeight = 1;

  late int _currentVT = 0;
  String blockedUsers = "";
  late PostBloc postBloc = new PostBloc(repository: PostRepositoryImpl());
  late TransactionBloc txBloc =
      new TransactionBloc(repository: TransactionRepositoryImpl());

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
          desktopMode: kIsWeb ? true : !Platform.isIOS,
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
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserDTCVPLoadedState) {
          setState(() {
            _currentVT = state.vtBalance["v"]!;
          });
        }
      },
      child: YoutubePlayerControllerProvider(
          controller: _controller,
          child: Container(
              child: VisibilityDetector(
            key: Key('post-details' + widget.post.link),
            onVisibilityChanged: (visibilityInfo) {
              var visiblePercentage = visibilityInfo.visibleFraction * 100;
              if (visiblePercentage < 1) {
                _controller.pause();
                _videocontroller.pause();
              }
              if (visiblePercentage > 90) {
                _controller.play();
                _videocontroller.play();
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.all(5.0),
                                  child: globals.disableAnimations
                                      ? AccountNavigationChip(
                                          author: widget.post.author)
                                      : SlideInDown(
                                          preferences: AnimationPreferences(
                                              offset:
                                                  Duration(milliseconds: 500)),
                                          child: AccountNavigationChip(
                                              author: widget.post.author))),
                              globals.disableAnimations
                                  ? TitleWidget(
                                      title: widget.post.jsonString!.title)
                                  : FadeInLeft(
                                      preferences: AnimationPreferences(
                                          offset: Duration(milliseconds: 700),
                                          duration: Duration(seconds: 1)),
                                      child: TitleWidget(
                                          title:
                                              widget.post.jsonString!.title)),
                            ],
                          ),
                          Container(
                            height: 50.h,
                            width: 50.w,
                            child: widget.post.videoSource == "youtube"
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
                                        placeholderWidth: 40.w,
                                        placeholderSize: 20.w,
                                      )
                                    : Text("no player detected"),
                          ),
                          FadeIn(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.post.tags.length > 0
                                    ? Row(
                                        children: [
                                          widget.post.jsonString!.oc == 1
                                              ? SizedBox(
                                                  width: globalIconSizeSmall,
                                                  child: FaIcon(
                                                      FontAwesomeIcons.award,
                                                      size:
                                                          globalIconSizeSmall))
                                              : SizedBox(width: 0),
                                          Container(
                                            width: 60.w,
                                            height: 5.h,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    widget.post.tags.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: TagChip(
                                                        waitBeforeFadeIn:
                                                            Duration(
                                                                seconds: 1),
                                                        fadeInFromLeft: true,
                                                        width: 10.w,
                                                        tagName: widget
                                                            .post.tags[index]
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
                                      )
                                    : BounceIn(
                                        preferences: AnimationPreferences(
                                            offset:
                                                Duration(milliseconds: 1200)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DtubeCoinsChip(
                                              dist: widget.post.dist,
                                              post: widget.post,
                                            )),
                                      ),
                              ],
                            ),
                          ),
// refactor twice used code..
                          globals.disableAnimations
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BlocBuilder<SettingsBloc, SettingsState>(
                                        builder: (context, state) {
                                      if (state is SettingsLoadedState) {
                                        _defaultVoteWeightPosts = double.parse(
                                            state.settings[
                                                settingKey_defaultVotingWeight]!);
                                        _defaultVoteTipPosts = double.parse(state
                                                .settings[
                                            settingKey_defaultVotingWeight]!);
                                        _defaultVoteWeightComments =
                                            double.parse(state.settings[
                                                settingKey_defaultVotingWeightComments]!);
                                        _fixedDownvoteActivated = state
                                                    .settings[
                                                settingKey_FixedDownvoteActivated] ==
                                            "true";
                                        _fixedDownvoteWeight = double.parse(state
                                                .settings[
                                            settingKey_FixedDownvoteWeight]!);
                                        return MultiBlocProvider(
                                          providers: [
                                            BlocProvider<TransactionBloc>.value(
                                              value: txBloc,
                                            ),
                                            BlocProvider<PostBloc>.value(
                                                value: postBloc
                                                  ..add(FetchPostEvent(
                                                      widget.post.author,
                                                      widget.post.link,
                                                      "PageDetailsPageV2.dart"))),
                                            BlocProvider<UserBloc>(
                                                create: (BuildContext
                                                        context) =>
                                                    UserBloc(
                                                        repository:
                                                            UserRepositoryImpl())),
                                          ],
                                          child: VotingButtons(
                                            defaultVotingWeight:
                                                _defaultVoteWeightPosts,
                                            defaultVotingTip:
                                                _defaultVoteTipPosts,
                                            scale: 0.8,
                                            isPost: true,
                                            iconColor: globalAlmostWhite,
                                            focusVote: widget.directFocus,
                                            fadeInFromLeft: false,
                                            fixedDownvoteActivated:
                                                _fixedDownvoteActivated,
                                            fixedDownvoteWeight:
                                                _fixedDownvoteWeight,
                                          ),
                                        );
                                      } else {
                                        return SizedBox(height: 0);
                                      }
                                    }),
                                    SizedBox(width: 8),
                                    GiftboxWidget(
                                      receiver: widget.post.author,
                                      link: widget.post.link,
                                      txBloc: txBloc,
                                    ),
                                  ],
                                )
                              : FadeInRight(
                                  preferences: AnimationPreferences(
                                      offset: Duration(milliseconds: 200)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      BlocBuilder<SettingsBloc, SettingsState>(
                                          builder: (context, state) {
                                        if (state is SettingsLoadedState) {
                                          _defaultVoteWeightPosts =
                                              double.parse(state.settings[
                                                  settingKey_defaultVotingWeight]!);
                                          _defaultVoteTipPosts = double.parse(state
                                                  .settings[
                                              settingKey_defaultVotingWeight]!);
                                          _defaultVoteWeightComments =
                                              double.parse(state.settings[
                                                  settingKey_defaultVotingWeightComments]!);
                                          _fixedDownvoteActivated = state
                                                      .settings[
                                                  settingKey_FixedDownvoteActivated] ==
                                              "true";
                                          _fixedDownvoteWeight = double.parse(state
                                                  .settings[
                                              settingKey_FixedDownvoteWeight]!);
                                          return MultiBlocProvider(
                                            providers: [
                                              BlocProvider<
                                                      TransactionBloc>.value(
                                                  value: txBloc),
                                              BlocProvider<PostBloc>.value(
                                                  value: postBloc
                                                    ..add(FetchPostEvent(
                                                        widget.post.author,
                                                        widget.post.link,
                                                        "PageDetailsPageV2.dart"))),
                                              BlocProvider<UserBloc>(
                                                  create: (BuildContext
                                                          context) =>
                                                      UserBloc(
                                                          repository:
                                                              UserRepositoryImpl())),
                                            ],
                                            child: VotingButtons(
                                              defaultVotingWeight:
                                                  _defaultVoteWeightPosts,
                                              defaultVotingTip:
                                                  _defaultVoteTipPosts,
                                              scale: 0.8,
                                              isPost: true,
                                              iconColor: globalAlmostWhite,
                                              focusVote: widget.directFocus,
                                              fadeInFromLeft: false,
                                              fixedDownvoteActivated:
                                                  _fixedDownvoteActivated,
                                              fixedDownvoteWeight:
                                                  _fixedDownvoteWeight,
                                            ),
                                          );
                                        } else {
                                          return SizedBox(height: 0);
                                        }
                                      }),
                                      SizedBox(width: 8),
                                      GiftboxWidget(
                                        receiver: widget.post.author,
                                        link: widget.post.link,
                                        txBloc:
                                            BlocProvider.of<TransactionBloc>(
                                                context),
                                      ),
                                    ],
                                  ),
                                ),
                          globals.disableAnimations
                              ? CollapsedDescription(
                                  startCollapsed: true,
                                  description:
                                      widget.post.jsonString!.desc != null
                                          ? widget.post.jsonString!.desc!
                                          : "")
                              : FadeInDown(
                                  child: CollapsedDescription(
                                      startCollapsed: true,
                                      description:
                                          widget.post.jsonString!.desc != null
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
                                      txBloc: txBloc)),
                          // // SizedBox(height: 16),
                          // widget.post.comments != null &&
                          //         widget.post.comments!.length > 0
                          //     ? globals.disableAnimations
                          //         ? CommentContainer(
                          //             defaultVoteWeightComments:
                          //                 _defaultVoteWeightComments,
                          //             currentVT: _currentVT,
                          //             defaultVoteTipComments:
                          //                 _defaultVoteTipComments,
                          //             blockedUsers: blockedUsers,
                          //             fixedDownvoteActivated:
                          //                 _fixedDownvoteActivated,
                          //             fixedDownvoteWeight: _fixedDownvoteWeight,
                          //             postBloc: new PostBloc(
                          //                 repository: PostRepositoryImpl())
                          //               ..add(FetchPostEvent(widget.post.author,
                          //                   widget.post.link)),
                          //             txBloc: new TransactionBloc(
                          //                 repository:
                          //                     TransactionRepositoryImpl()),
                          //           )
                          //         : SlideInLeft(
                          //             child: CommentContainer(
                          //             defaultVoteWeightComments:
                          //                 _defaultVoteWeightComments,
                          //             currentVT: _currentVT,
                          //             defaultVoteTipComments:
                          //                 _defaultVoteTipComments,
                          //             blockedUsers: blockedUsers,
                          //             fixedDownvoteActivated:
                          //                 _fixedDownvoteActivated,
                          //             fixedDownvoteWeight: _fixedDownvoteWeight,
                          //             postBloc: new PostBloc(
                          //                 repository: PostRepositoryImpl())
                          //               ..add(FetchPostEvent(widget.post.author,
                          //                   widget.post.link)),
                          //             txBloc: new TransactionBloc(
                          //                 repository:
                          //                     TransactionRepositoryImpl()),
                          //           ))
                          //     : SizedBox(height: 0),

                          BlocProvider<FeedBloc>(
                            create: (context) =>
                                FeedBloc(repository: FeedRepositoryImpl())
                                  ..add(FetchSuggestedUsersForPost(
                                    currentUsername: widget.post.author,
                                    tags: widget.post.tags,
                                  )),
                            child: SuggestedChannels(
                              avatarSize: 5.w,
                            ),
                          ),
                          BlocProvider<FeedBloc>(
                            create: (context) =>
                                FeedBloc(repository: FeedRepositoryImpl())
                                  ..add(FetchSuggestedPostsForPost(
                                      currentUsername: widget.post.author,
                                      tags: widget.post.tags)),
                            child: FeedListCarousel(
                                feedType: 'SuggestedPosts',
                                username: widget.post.author,
                                showAuthor: true,
                                largeFormat: false,
                                heightPerEntry: 30.h,
                                width: 150.w,
                                topPaddingForFirstEntry: 0,
                                sidepadding: 5.w,
                                bottompadding: 0.h,
                                scrollCallback: (bool) {},
                                enableNavigation: true,
                                header: "Suggested Videos"),
                          ),
                          SizedBox(height: 200)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}

class VotesOverview extends StatefulWidget {
  VotesOverview({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;

  @override
  _VotesOverviewState createState() => _VotesOverviewState();
}

class _VotesOverviewState extends State<VotesOverview> {
  List<Votes> _allVotes = [];

  @override
  void initState() {
    super.initState();
    _allVotes = widget.post.upvotes!;
    if (widget.post.downvotes != null) {
      _allVotes = _allVotes + widget.post.downvotes!;
    }
    // sorting the list would be perhaps useful
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      backgroundColor: globalAlmostBlack,
      content: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: 45.h,
              width: 90.w,
              child: ListView.builder(
                itemCount: _allVotes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 10.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              navigateToUserDetailPage(
                                  context, _allVotes[index].u, () {});
                            },
                            child: Row(
                              children: [
                                Container(
                                    height: 10.w,
                                    width: 10.w,
                                    child: AccountIconBase(
                                      avatarSize: 10.w,
                                      showVerified: true,
                                      username: _allVotes[index].u,
                                    )),
                                SizedBox(width: 2.w),
                                Container(
                                  width: 30.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _allVotes[index].u,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Text(
                                        TimeAgo.timeInAgoTSShort(
                                            _allVotes[index].ts),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FaIcon(_allVotes[index].vt > 0
                              ? FontAwesomeIcons.heart
                              : FontAwesomeIcons.flag),
                          Container(
                            width: 20.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          (_allVotes[index].claimable != null
                                              ? shortDTC(_allVotes[index]
                                                  .claimable!
                                                  .floor())
                                              : "0"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Container(
                                          width: 5.w,
                                          child: Center(
                                            child: DTubeLogoShadowed(size: 5.w),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          shortVP(_allVotes[index].vt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Container(
                                          width: 5.w,
                                          child: Center(
                                            child: ShadowedIcon(
                                              icon: FontAwesomeIcons.bolt,
                                              shadowColor: Colors.black,
                                              color: globalAlmostWhite,
                                              size: 5.w,
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
                        ],
                      ));
                },
              ),
            ),
            // ),
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        InputChip(
          backgroundColor: globalRed,
          onPressed: () async {
            Navigator.of(context).pop();
          },
          label: Text(
            'Close',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }
}
