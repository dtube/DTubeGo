import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dtube_togo/ui/MainContainer/NavigationContainer.dart';

import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:dtube_togo/ui/pages/post/players/BetterPlayer.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/ui/pages/post/widgets/CollapsedDescription.dart';
import 'package:dtube_togo/ui/pages/post/widgets/Comments.dart';
import 'package:dtube_togo/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_togo/ui/pages/post/widgets/VoteButtons.dart';

import 'package:dtube_togo/utils/secureStorage.dart';

import 'package:dtube_togo/style/dtubeLoading.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PostDetailPage extends StatefulWidget {
  String link;
  String author;
  bool recentlyUploaded;
  String directFocus;

  PostDetailPage(
      {required this.link,
      required this.author,
      required this.recentlyUploaded,
      required this.directFocus});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int reloadCount = 0;
  Future<bool> _onWillPop() async {
    if (widget.recentlyUploaded) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MultiBlocProvider(providers: [
                    BlocProvider<UserBloc>(create: (context) {
                      return UserBloc(repository: UserRepositoryImpl());
                    }),
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(
            create: (BuildContext context) =>
                PostBloc(repository: PostRepositoryImpl())
                  ..add(FetchPostEvent(widget.author, widget.link)),
          ),
          BlocProvider<UserBloc>(
              create: (BuildContext context) =>
                  UserBloc(repository: UserRepositoryImpl())),
          BlocProvider<SettingsBloc>(
            create: (BuildContext context) =>
                SettingsBloc()..add(FetchSettingsEvent()),
          ),
        ],
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? null
                      : AppBar(
                          toolbarHeight: 28,
                          automaticallyImplyLeading: true,

                          // TODO: recently uploaded posts - back button should go to main navigator
                          //https://stackoverflow.com/questions/50452710/catch-android-back-button-event-on-flutter
                        ),
              body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
                if (state is PostLoadingState) {
                  return Center(child: DTubeLogoPulse());
                } else if (state is PostLoadedState) {
                  reloadCount++;
                  return PostDetails(
                    post: state.post,
                    directFocus: reloadCount <= 1 ? widget.directFocus : "none",
                  );
                } else {
                  return Text("failed");
                }
              }),
            )));
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

  late UserBloc _userBloc;

  late double _defaultVoteWeightPosts = 0;
  late double _defaultVoteWeightComments = 0;
  late double _defaultVoteTipPosts = 0;
  late double _defaultVoteTipComments = 0;
  late int _currentVT = 0;

  @override
  void initState() {
    super.initState();

    _userBloc = BlocProvider.of<UserBloc>(context);

    _userBloc.add(FetchAccountDataEvent(widget.post.author));
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
  }

  @override
  void dispose() {
    _controller.close();
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
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
          // Passing controller to widgets below.
          controller: _controller,
          child: SingleChildScrollView(
            //shrinkWrap: true,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    //padding: EdgeInsets.all(5.0),
                    children: <Widget>[
                      MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? SizedBox(height: 0)
                          : Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    widget.post.jsonString!.title,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.all(5.0),
                                  child: InputChip(
                                    label: Container(
                                      width: 100,
                                      height: 40,
                                      child: Center(
                                          child: Text(widget.post.author)),
                                    ),
                                    avatar: BlocProvider<UserBloc>(
                                      create: (BuildContext context) =>
                                          UserBloc(
                                              repository: UserRepositoryImpl()),
                                      child: AccountAvatar(
                                          username: widget.post.author,
                                          size: 40),
                                    ),
                                    onPressed: () {
                                      navigateToUserDetailPage(
                                          context, widget.post.author);
                                    },
                                  ),
                                ),
                              ],
                            ),
                      widget.post.videoSource == "youtube"
                          ? player
                          : ["ipfs", "sia"].contains(widget.post.videoSource)
                              ? BP(
                                  videoUrl: widget.post.videoUrl!,
                                  autoplay: !(widget.directFocus != "none"),
                                  looping: false,
                                  localFile: false,
                                  controls: true,
                                  usedAsPreview: false,
                                  allowFullscreen: true,
                                )
                              : Text("no player detected"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.post.tags.length > 0
                              ? Row(
                                  children: [
                                    widget.post.jsonString!.oc == 1
                                        ? SizedBox(
                                            width: 23,
                                            child:
                                                FaIcon(FontAwesomeIcons.award))
                                        : SizedBox(width: 0),
                                    Container(
                                      width: deviceWidth * 0.6,
                                      height: 50,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: widget.post.tags.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: InputChip(
                                                  label: Text(
                                                widget.post.tags[index]
                                                    .toString(),
                                              )),
                                            );
                                            // return Text(
                                            //   widget.post.tags[index].toString(),
                                            // );
                                          }),
                                    ),
                                  ],
                                )
                              : SizedBox(height: 0),
                          Text(
                            (widget.post.dist / 100).round().toString() +
                                " DTC",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<SettingsBloc, SettingsState>(
                              builder: (context, state) {
                            if (state is SettingsLoadedState) {
                              _defaultVoteWeightPosts = double.parse(state
                                  .settings[settingKey_defaultVotingWeight]!);
                              _defaultVoteTipPosts = double.parse(state
                                  .settings[settingKey_defaultVotingWeight]!);
                              _defaultVoteWeightComments = double.parse(
                                  state.settings[
                                      settingKey_defaultVotingWeightComments]!);
                              return
                                  // BlocProvider(
                                  //   create: (context) =>
                                  //       PostBloc(repository: PostRepositoryImpl()),
                                  //   child:
                                  VotingButtons(
                                      author: widget.post.author,
                                      link: widget.post.link,
                                      alreadyVoted: widget.post.alreadyVoted!,
                                      alreadyVotedDirection:
                                          widget.post.alreadyVotedDirection!,
                                      upvotes: widget.post.upvotes,
                                      downvotes: widget.post.downvotes,
                                      defaultVotingWeight:
                                          _defaultVoteWeightPosts,
                                      defaultVotingTip: _defaultVoteTipPosts,
                                      currentVT: _currentVT,
                                      scale: 1,
                                      isPost: true,
                                      focusVote: widget.directFocus == "vote"
                                      //),
                                      );
                            } else {
                              return SizedBox(height: 0);
                            }
                          }),
                        ],
                      ),
                      CollapsedDescription(
                          description: widget.post.jsonString!.desc != null
                              ? widget.post.jsonString!.desc!
                              : ""),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputChip(
                            label: FaIcon(FontAwesomeIcons.shareAlt),
                            onPressed: () {
                              Share.share('https://d.tube/c/' +
                                  widget.post.author +
                                  '/' +
                                  widget.post.link);
                            },
                          ),
                          SizedBox(width: 10),
                          BlocProvider(
                            create: (context) => TransactionBloc(
                                repository: TransactionRepositoryImpl()),
                            child: ReplyButton(
                              icon: FaIcon(FontAwesomeIcons.comment),
                              author: widget.post.author,
                              link: widget.post.link,
                              parentAuthor: widget.post.author,
                              parentLink: widget.post.link,
                              votingWeight: _defaultVoteWeightComments,
                              scale: 1,
                              focusOnNewComment:
                                  widget.directFocus == "newcomment",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      widget.post.comments != null &&
                              widget.post.comments!.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                height: 300,
                                child: ListView.builder(
                                  key: PageStorageKey('myScrollable'),
                                  itemCount: widget.post.comments!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          CommentDisplay(
                                              widget.post.comments![index],
                                              _defaultVoteWeightComments,
                                              _currentVT,
                                              widget.post.author,
                                              widget.post.link,
                                              _defaultVoteTipComments),
                                ),
                              ),
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 200)
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
