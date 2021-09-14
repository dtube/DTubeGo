import 'package:dtube_togo/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';

import 'package:dtube_togo/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/ui/pages/moments/widgets/MomentsUpload.dart';
import 'package:dtube_togo/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';

import 'package:story_view/story_view.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_togo/style/dtubeLoading.dart';

import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef ListOfString2VoidFunc = void Function(List<String>);

class MomentsList extends StatefulWidget {
  String feedType;
  late StoryController storyController;

  MomentsList({
    required this.feedType,
    required this.storyController,
    Key? key,
  }) : super(key: key);

  @override
  State<MomentsList> createState() => _MomentsListState();
}

class _MomentsListState extends State<MomentsList> {
  late FeedBloc postBloc;

  final ScrollController _scrollController = ScrollController();

  List<FeedItem> _feedItems = [];
  List<StoryItem> moments = [];
  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;
  String? _defaultVotingWeight;
  String? _defaultVotingTip;

  Future<bool> getConfigValues() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    _defaultVotingWeight = await sec.getDefaultVote();
    _defaultVotingTip = await sec.getDefaultVoteTip();
    if (_nsfwMode == null) {
      _nsfwMode = 'Blur';
    }
    if (_hiddenMode == null) {
      _hiddenMode = 'Hide';
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.storyController.pause();
    widget.storyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getConfigValues(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return buildLoading(context);
          } else {
            return BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedInitialState ||
                    state is FeedLoadingState && _feedItems.isEmpty) {
                  return buildLoading(context);
                } else if (state is FeedLoadedState) {
                  if (state.feedType == widget.feedType) {
                    if (_feedItems.isNotEmpty) {
                      if (_feedItems.first.link == state.feed.first.link) {
                        _feedItems.clear();
                      } else {
                        _feedItems.removeLast();
                      }
                    }
                    _feedItems.addAll(state.feed);

                    for (var f in _feedItems) {
                      moments.add(new StoryItem.pageVideo(
                        f.videoUrl,
                        controller: widget.storyController,
                        duration: Duration(seconds: 2),
                      ));
                    }
                  }
                  BlocProvider.of<FeedBloc>(context).isFetching = false;
                } else if (state is FeedErrorState) {
                  return buildErrorUi(state.message);
                }

                return StoriesView(
                    feed: _feedItems,
                    feedType: widget.feedType,
                    appUser: _applicationUser!,
                    defaultVotingTip: _defaultVotingTip!,
                    defaultVotingWeight: _defaultVotingWeight!,
                    controller: widget.storyController);
              },
            );
          }
        });
  }

  Widget buildLoading(BuildContext context) {
    return Center(
        child: widget.feedType == "UserFeed"
            ? SizedBox(height: 0, width: 0)
            : DTubeLogoPulse(size: 20.w));
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class StoriesView extends StatefulWidget {
  List<FeedItem> feed;
  String defaultVotingWeight;
  String defaultVotingTip;
  String appUser;

  String feedType;
  StoryController controller;

  StoriesView(
      {Key? key,
      required this.feed,
      required this.feedType,
      required this.appUser,
      required this.defaultVotingTip,
      required this.defaultVotingWeight,
      required this.controller})
      : super(key: key);

  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  List<StoryItem> momentItems = [];

  String author = "";
  String title = "";
  int pos = 0;

  @override
  void initState() {
    widget.feed.forEach((f) {
      momentItems.add(StoryItem.pageVideo(f.videoUrl,
          controller: widget.controller,
          duration: Duration(
              seconds: f.jsonString!.dur != ""
                  ? int.parse(f.jsonString!.dur) + 1
                  : 5)));
      author = widget.feed[0].author;
      title = widget.feed[0].jsonString!.title;
      super.initState();
    });
  }

  @override
  void dispose() {
    widget.controller.pause();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (momentItems.length > 0) {
      return Stack(
        children: <Widget>[
          StoryView(
            storyItems: momentItems,
            repeat: true,
            controller: widget.controller,
            inline: false,
            onStoryShow: (storyItem) {
              int _pos = momentItems.indexOf(storyItem);

              // the reason for doing setState only after the first
              // position is becuase by the first iteration, the layout
              // hasn't been laid yet, thus raising some exception
              // (each child need to be laid exactly once)
              if (_pos > 0) {
                setState(() {
                  pos = _pos;
                  //dtc = feed[pos].dist.toString();
                  author = widget.feed[pos].author;
                  title = widget.feed[pos].jsonString!.title;
                });
              }
            },
          ),
          MomentsOverlay(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(left: 10.w),
            width: 120.w,
            height: 20.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: AccountAvatarBase(
                      key: UniqueKey(),
                      username: author,
                      avatarSize: 10.h,
                      showVerified: true,
                      showName: true,
                      width: 40.w),
                  onTap: () {
                    navigateToUserDetailPage(context, author);
                  },
                ),
              ],
            ),
          ),
          MomentsOverlay(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 5.w),
            width: 100.w,
            height: 60.h,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<UserBloc>(
                    create: (context) =>
                        UserBloc(repository: UserRepositoryImpl())),
                BlocProvider<PostBloc>(
                  create: (BuildContext context) =>
                      PostBloc(repository: PostRepositoryImpl()),
                ),
              ],
              child: VotingButtons(
                key: UniqueKey(),
                author: author,
                link: widget.feed[pos].link,
                alreadyVoted: widget.feed[pos].alreadyVoted!,
                alreadyVotedDirection: widget.feed[pos].alreadyVotedDirection!,
                defaultVotingWeight: double.parse(widget.defaultVotingWeight),
                defaultVotingTip: double.parse(widget.defaultVotingTip),
                scale: 1,
                isPost: true,
                focusVote: "none",
                vertical: true,
                verticalModeCallbackVotingButtonsPressed: () {
                  widget.controller.pause();
                },
                verticalModeCallbackVoteSent: () {
                  widget.controller.play();
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Text(
          "no moments found",
          style: Theme.of(context).textTheme.headline3,
        ),
      );
    }
  }
}

class MomentsOverlay extends StatelessWidget {
  Alignment alignment;
  EdgeInsets padding;
  double width;
  double height;
  Widget child;
  Color? debugColor;
  MomentsOverlay(
      {Key? key,
      required this.alignment,
      required this.padding,
      required this.width,
      required this.height,
      required this.child,
      this.debugColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        color: debugColor,
        width: width,
        height: height,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
