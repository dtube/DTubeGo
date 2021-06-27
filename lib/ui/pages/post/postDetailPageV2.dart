import 'package:dtube_togo/bloc/settings/settings_bloc.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:dtube_togo/ui/pages/post/players/BetterPlayer.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/ui/pages/post/widgets/CollapsedDescription.dart';
import 'package:dtube_togo/ui/pages/post/widgets/Comments.dart';
import 'package:dtube_togo/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_togo/ui/pages/post/widgets/VoteButtons.dart';

import 'package:dtube_togo/utils/secureStorage.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/bloc/postdetails/postdetails_bloc_full.dart';

import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PostDetailPage extends StatelessWidget {
  String link;
  String author;

  PostDetailPage({required this.link, required this.author});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(
            create: (BuildContext context) =>
                PostBloc(repository: PostRepositoryImpl())
                  ..add(FetchPostEvent(author, link)),
          ),
          BlocProvider<UserBloc>(
              create: (BuildContext context) =>
                  UserBloc(repository: UserRepositoryImpl())),
          BlocProvider<SettingsBloc>(
            create: (BuildContext context) =>
                SettingsBloc()..add(FetchSettingsEvent()),
          ),
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MediaQuery.of(context).orientation == Orientation.landscape
              ? null
              : AppBar(
                  toolbarHeight: 28,
                ),
          body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
            if (state is PostLoadingState) {
              return Center(child: DTubeLogoPulse());
            } else if (state is PostLoadedState) {
              return PostDetails(post: state.post);
            } else {
              return Text("failed");
            }
          }),
        ));
  }
}

class PostDetails extends StatefulWidget {
  final Post post;

  const PostDetails({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  late YoutubePlayerController _controller;

  late UserBloc _userBloc;

  late double _defaultVoteWeightPosts = 0;
  late double _defaultVoteWeightComments = 0;
  late int _currentVT = 0;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);

    _userBloc.add(FetchAccountDataEvent(widget.post.author));
    _userBloc.add(FetchDTCVPEvent());

    _controller = YoutubePlayerController(
      initialVideoId: widget.post.videoUrl!,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: true,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
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
                                    label: Text(widget.post.author),
                                    avatar: BlocProvider<UserBloc>(
                                      create: (BuildContext context) =>
                                          UserBloc(
                                              repository: UserRepositoryImpl()),
                                      child: AccountAvatar(
                                          username: widget.post.author),
                                    ),
                                    onPressed: () {
                                      navigateToUserDetailPage(
                                          context, widget.post.author);
                                    },
                                  ),
                                ),
                              ],
                            ),
                      widget.post.jsonString!.files!.youtube != null
                          ? player
                          : widget.post.jsonString!.files?.ipfs != null
                              ? BP(
                                  videoUrl: widget.post.videoUrl!,
                                  autoplay: true,
                                  looping: false,
                                  localFile: false,
                                )
                              : Text("no player detected"),
                      Text(
                        (widget.post.dist / 100).round().toString() + " DTC",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      BlocBuilder<SettingsBloc, SettingsState>(
                          builder: (context, state) {
                        if (state is SettingsLoadedState) {
                          _defaultVoteWeightPosts = double.parse(
                              state.settings[settingKey_defaultVotingWeight]!);
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
                                  defaultVotingWeight: _defaultVoteWeightPosts,
                                  currentVT: _currentVT,
                                  scale: 1
                                  //),
                                  );
                        } else {
                          return SizedBox(height: 0);
                        }
                      }),
                      CollapsedDescription(
                          description: widget.post.jsonString!.desc!),
                      Divider(),
                      Align(
                        alignment: Alignment.topRight,
                        child: ReplyButton(
                          title: "reply video",
                          author: widget.post.author,
                          link: widget.post.link,
                          votingWeight: _defaultVoteWeightComments,
                          scale: 1,
                        ),
                      ),
                      SizedBox(height: 16),
                      widget.post.comments != null &&
                              widget.post.comments!.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                height: 500,
                                child: ListView.builder(
                                  key: PageStorageKey('myScrollable'),
                                  itemCount: widget.post.comments!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          CommentDisplay(
                                              widget.post.comments![index],
                                              _defaultVoteWeightComments,
                                              _currentVT),
                                ),
                              ),
                            )
                          : SizedBox(height: 0),
                      // return Text(widget.post.comments![pos].author);
                    ],
                  ),
                ),
              ],
            ),
          )),
    );

    // });
  }

  void navigateToUserDetailPage(BuildContext context, String username) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      // return BlocProvider<UserBloc>(
      //   create: (context) {
      //     return UserBloc(repository: UserRepositoryImpl())

      //   },
      //   child:
      return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (BuildContext context) =>
                UserBloc(repository: UserRepositoryImpl())
                  ..add(FetchAccountDataEvent(username)),
          ),
          BlocProvider<TransactionBloc>(
            create: (BuildContext context) =>
                TransactionBloc(repository: TransactionRepositoryImpl()),
          ),
        ],
        child: UserPage(
          username: username,
          ownUserpage: false,
        ),
      );
    }));
  }
}
