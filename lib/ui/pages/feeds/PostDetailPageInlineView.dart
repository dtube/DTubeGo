import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/ui/widgets/players/YTplayerIframe.dart';
import 'package:dtube_go/ui/widgets/tags/TagChip.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/pages/post/widgets/CollapsedDescription.dart';
import 'package:dtube_go/ui/pages/post/widgets/Comments.dart';
import 'package:dtube_go/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PostDetailPageInlineView extends StatefulWidget {
  String link;
  String author;
  bool recentlyUploaded;
  String directFocus;

  PostDetailPageInlineView(
      {required this.link,
      required this.author,
      required this.recentlyUploaded,
      required this.directFocus});

  @override
  _PostDetailPageInlineViewState createState() =>
      _PostDetailPageInlineViewState();
}

class _PostDetailPageInlineViewState extends State<PostDetailPageInlineView> {
  int reloadCount = 0;
  late PostBloc postBloc = new PostBloc(repository: PostRepositoryImpl());
  late TransactionBloc txBloc =
      new TransactionBloc(repository: TransactionRepositoryImpl());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          key: UniqueKey(),
          create: (BuildContext context) =>
              PostBloc(repository: PostRepositoryImpl())
                ..add(FetchPostEvent(
                    widget.author, widget.link, "PageDetailsPageV2.dart")),
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
      child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        if (state is PostLoadingState) {
          return Center(child: DTubeLogoPulse(size: 20.w));
        } else if (state is PostLoadedState) {
          reloadCount++;
          return
              // Padding(
              //   padding: const EdgeInsets.only(top: 100),
              //   child:
              PostDetails(
            post: state.post,
            directFocus: reloadCount <= 1 ? widget.directFocus : "none",
            postBloc: postBloc,
            txBloc: txBloc,
            //),
          );
        } else {
          return Center(child: DTubeLogoPulse(size: 20.w));
        }
      }),

      //)
    );
  }
}

class PostDetails extends StatefulWidget {
  final Post post;
  final String directFocus;
  final PostBloc postBloc;
  final TransactionBloc txBloc;

  PostDetails(
      {Key? key,
      required this.post,
      required this.directFocus,
      required this.postBloc,
      required this.txBloc})
      : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  late UserBloc _userBloc;
  late VideoPlayerController _videocontroller;
  late double _defaultVoteWeightPosts = 0;
  late double _defaultVoteWeightComments = 0;
  late double _defaultVoteTipPosts = 0;
  late double _defaultVoteTipComments = 0;

  late bool _fixedDownvoteActivated = true;
  late double _fixedDownvoteWeight = 1;

  String blockedUsers = "";
  late YoutubePlayerController _ytController;
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
    _videocontroller =
        VideoPlayerController.asset('assets/videos/firstpage.mp4');
    _ytController = YoutubePlayerController(initialVideoId: 'tFa7Om3Au8M');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserDTCVPLoadedState) {}
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                widget.post.videoSource == "youtube"
                    ? YTPlayerIFrame(
                        videoUrl: widget.post.videoUrl!,
                        autoplay: false,
                        allowFullscreen: false,
                        controller: _ytController)
                    : ["ipfs", "sia"].contains(widget.post.videoSource)
                        ? ChewiePlayer(
                            videoUrl: widget.post.videoUrl!,
                            autoplay: !(widget.directFocus != "none"),
                            looping: false,
                            localFile: false,
                            controls: true,
                            usedAsPreview: false,
                            allowFullscreen: false,
                            portraitVideoPadding: 50.0,
                            placeholderWidth: 100.w,
                            placeholderSize: 40.w,
                            videocontroller: _videocontroller)
                        : Text("no player detected"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InputChip(
                      label: Row(
                        children: [
                          AccountIconBase(
                            username: widget.post.author,
                            avatarSize: 10.w,
                            showVerified: true,
                            // showName: true,
                            // width: 30.w,
                            // height: 10.h
                          ),
                          AccountNameBase(
                              username: widget.post.author,
                              width: 30.w,
                              height: 10.h,
                              mainStyle: Theme.of(context).textTheme.headline5!,
                              subStyle: Theme.of(context).textTheme.bodyText1!)
                        ],
                      ),
                      onPressed: () {
                        navigateToUserDetailPage(
                            context, widget.post.author, () {});
                      },
                    ),
                    // FullScreenButton(
                    //   videoUrl: widget.post.videoUrl!,
                    //   videoSource: widget.post.videoSource,
                    //   iconSize: 15,
                    // ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 49.w,
                        child: Text(
                          widget.post.jsonString!.title,
                          style: Theme.of(context).textTheme.headline6,
                          maxLines: 4,
                        ),
                      ),
                    ]),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.post.tags.length > 0
                        ? Row(
                            children: [
                              widget.post.jsonString!.oc == 1
                                  ? SizedBox(
                                      width: 23,
                                      child: FaIcon(FontAwesomeIcons.award))
                                  : SizedBox(width: 0),
                              Container(
                                width: 25.w,
                                height: 50,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.post.tags.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: TagChip(
                                          waitBeforeFadeIn:
                                              Duration(milliseconds: 600),
                                          fadeInFromLeft: false,
                                          tagName: widget.post.tags[index],
                                          width: 20.w,
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )
                        : SizedBox(height: 0),
                    Text((widget.post.dist / 100).round().toString() + " DTC",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                      if (state is SettingsLoadedState) {
                        _defaultVoteWeightPosts = double.parse(state
                            .settings[sec.settingKey_defaultVotingWeight]!);
                        _defaultVoteTipPosts = double.parse(state
                            .settings[sec.settingKey_defaultVotingWeight]!);
                        _defaultVoteWeightComments = double.parse(
                            state.settings[
                                sec.settingKey_defaultVotingWeightComments]!);

                        _fixedDownvoteActivated = state.settings[
                                sec.settingKey_FixedDownvoteActivated] ==
                            "true";
                        _fixedDownvoteWeight = double.parse(state
                            .settings[sec.settingKey_FixedDownvoteWeight]!);
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<TransactionBloc>(
                                create: (context) => TransactionBloc(
                                    repository: TransactionRepositoryImpl())),
                            BlocProvider<PostBloc>(
                                create: (context) =>
                                    PostBloc(repository: PostRepositoryImpl())
                                      ..add(FetchPostEvent(
                                          widget.post.author,
                                          widget.post.link,
                                          "PageDetailsPageV2.dart"))),
                            BlocProvider<UserBloc>(
                                create: (BuildContext context) =>
                                    UserBloc(repository: UserRepositoryImpl())),
                          ],
                          child: VotingButtons(
                            defaultVotingWeight: _defaultVoteWeightPosts,
                            defaultVotingTip: _defaultVoteTipPosts,
                            scale: 0.8,
                            isPost: true,
                            iconColor: globalAlmostWhite,
                            focusVote: widget.directFocus,
                            fadeInFromLeft: false,
                            fixedDownvoteActivated: _fixedDownvoteActivated,
                            fixedDownvoteWeight: _fixedDownvoteWeight,
                          ),
                        );
                      } else {
                        return SizedBox(height: 0);
                      }
                    }),
                  ],
                ),
                CollapsedDescription(
                    startCollapsed: false,
                    description: widget.post.jsonString!.desc != null
                        ? widget.post.jsonString!.desc!
                        : ""),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputChip(
                      label: FaIcon(FontAwesomeIcons.shareNodes),
                      onPressed: () {
                        Share.share('https://d.tube/c/' +
                            widget.post.author +
                            '/' +
                            widget.post.link);
                      },
                    ),
                    SizedBox(width: 8),
                    ReplyButton(
                        icon: FaIcon(FontAwesomeIcons.comment),
                        author: widget.post.author,
                        link: widget.post.link,
                        parentAuthor: widget.post.author,
                        parentLink: widget.post.link,
                        votingWeight: _defaultVoteWeightComments,
                        scale: 1,
                        focusOnNewComment: widget.directFocus == "newcomment",
                        isMainPost: true,
                        postBloc: widget.postBloc,
                        txBloc: widget.txBloc),
                  ],
                ),
                // SizedBox(height: 16),
                widget.post.comments != null && widget.post.comments!.length > 0
                    ? Container(
                        height: 200.w,
                        child: ListView.builder(
                          itemCount: widget.post.comments!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) =>
                              CommentDisplay(
                            entry: widget.post.comments![index],
                            defaultVoteWeight: _defaultVoteWeightComments,
                            parentAuthor: widget.post.author,
                            parentLink: widget.post.link,
                            defaultVoteTip: _defaultVoteTipComments,
                            parentContext: context,
                            blockedUsers: blockedUsers.split(","),
                            fixedDownvoteActivated: _fixedDownvoteActivated,
                            fixedDownvoteWeight: _fixedDownvoteWeight,
                            postBloc: widget.postBloc,
                            txBloc: widget.txBloc,
                          ),
                        ),
                      )
                    : SizedBox(height: 0),
                SizedBox(height: 200)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
