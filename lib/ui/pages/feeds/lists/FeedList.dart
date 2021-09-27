import 'package:dtube_go/style/ThemeData.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/dtubeLoading.dart';

import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardNarrow.dart';

import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/utils/friendlyTimestamp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef ListOfString2VoidFunc = void Function(List<String>);

class FeedList extends StatelessWidget {
  String feedType;
  String? username;
  bool largeFormat;
  bool showAuthor;
  double? topPaddingForFirstEntry;
  double? sidepadding;
  double? width;
  double? heightPerEntry;
  bool enableNavigation;
  ListOfString2VoidFunc?
      itemSelectedCallback; // only used in landscape mode for now

  Bool2VoidFunc scrollCallback;
  late YoutubePlayerController _youtubePlayerController;

  FeedList({
    required this.feedType,
    this.username,
    required this.largeFormat,
    required this.showAuthor,
    required this.scrollCallback,
    this.topPaddingForFirstEntry,
    this.sidepadding,
    this.width,
    this.heightPerEntry,
    required this.enableNavigation,
    this.itemSelectedCallback,
    Key? key,
  }) : super(key: key);

  late FeedBloc postBloc;
  final ScrollController _scrollController = ScrollController();
  List<FeedItem> _feedItems = [];

  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;
  String? _defaultCommentVotingWeight;
  String? _defaultPostVotingWeight;
  String? _defaultPostVotingTip;

  Future<bool> getSettings() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    _defaultCommentVotingWeight = await sec.getDefaultVoteComments();
    _defaultPostVotingWeight = await sec.getDefaultVote();
    _defaultPostVotingTip = await sec.getDefaultVoteTip();

    if (_nsfwMode == null) {
      _nsfwMode = 'Blur';
    }
    if (_hiddenMode == null) {
      _hiddenMode = 'Hide';
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (topPaddingForFirstEntry == null) {
      topPaddingForFirstEntry = 16.h;
    }

    if (width == null) {
      width = 100.w;
    }

    if (heightPerEntry == null) {
      heightPerEntry = 10.h;
    }

    return FutureBuilder<bool>(
        future: getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return buildLoading(context);
          } else {
            return Container(
              height: 150.h,
              child: BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) {
                  if (state is FeedInitialState ||
                      state is FeedLoadingState && _feedItems.isEmpty) {
                    return buildLoading(context);
                  } else if (state is FeedLoadedState) {
                    if (state.feedType == feedType) {
                      if (_feedItems.isNotEmpty) {
                        if (_feedItems.first.link == state.feed.first.link) {
                          _feedItems.clear();
                        } else {
                          _feedItems.removeLast();
                        }
                      }
                      _feedItems.addAll(state.feed);
                    }
                    BlocProvider.of<FeedBloc>(context).isFetching = false;
                  } else if (state is FeedErrorState) {
                    return buildErrorUi(state.message);
                  }
                  return Container(
                    height: 100.h,
                    width: 120.w,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: sidepadding != null ? sidepadding! : 0.0,
                            right: sidepadding != null ? sidepadding! : 0.0,
                          ),
                          child: buildPostList(
                              _feedItems, largeFormat, true, context, feedType),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: feedType == "UserFeed" ? 35.h : 15.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      Colors.black,
                                      Colors.black.withOpacity(0.0),
                                    ],
                                    stops: [
                                      0.0,
                                      1.0
                                    ])),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        });
  }

  Widget buildLoading(BuildContext context) {
    return Center(
        child: feedType == "UserFeed"
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

  Widget buildPostList(List<FeedItem> feed, bool bigThumbnail, bool showAuthor,
      BuildContext context, String gpostType) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: feed.length,
      controller: _scrollController
        ..addListener(() {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !BlocProvider.of<FeedBloc>(context).isFetching) {
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(feedType != "UserFeed"
                  ? FetchFeedEvent(
                      //feedType: widget.feedType,
                      feedType: feedType,
                      fromAuthor: feed[feed.length - 1].author,
                      fromLink: feed[feed.length - 1].link)
                  : FetchUserFeedEvent(
                      username: username!,
                      fromLink: feed[feed.length - 1].link));
          }
          if (_scrollController.offset <=
                  _scrollController.position.minScrollExtent &&
              !BlocProvider.of<FeedBloc>(context).isFetching) {
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(feedType != "UserFeed"
                  ? FetchFeedEvent(
                      //feedType: widget.feedType,
                      feedType: feedType,
                    )
                  : FetchUserFeedEvent(username: username!));
          }
        }),
      itemBuilder: (ctx, pos) {
        // work on more sources
        if (feed[pos].jsonString!.files?.youtube != null ||
            feed[pos].jsonString!.files?.ipfs != null ||
            feed[pos].jsonString!.files?.sia != null) {
          if ((_nsfwMode == 'Hide' && feed[pos].jsonString?.nsfw == 1) ||
              (_hiddenMode == 'Hide' && feed[pos].summaryOfVotes < 0) ||
              (feed[pos].jsonString!.hide == 1 &&
                  feed[pos].author != _applicationUser)) {
            return Padding(
              padding: EdgeInsets.only(
                  top: pos == 0 ? topPaddingForFirstEntry! : 2.0),
              child: SizedBox(
                height: 0,
              ),
            );
          } else {
            return BlocProvider<UserBloc>(
              create: (context) => UserBloc(repository: UserRepositoryImpl()),
              child: Padding(
                padding: EdgeInsets.only(
                    top: pos == 0 ? topPaddingForFirstEntry! : 2.0),
                child: PostListCard(
                  width: width!,
                  heightPerEntry: heightPerEntry!,
                  largeFormat: largeFormat,
                  showAuthor: showAuthor,
                  blur: (_nsfwMode == 'Blur' &&
                              feed[pos].jsonString?.nsfw == 1) ||
                          (_hiddenMode == 'Blur' &&
                              feed[pos].summaryOfVotes < 0)
                      ? true
                      : false,
                  title: feed[pos].jsonString!.title,
                  description: feed[pos].jsonString!.desc != null
                      ? feed[pos].jsonString!.desc!
                      : "",
                  author: feed[pos].author,
                  link: feed[pos].link,
                  publishDate: TimeAgo.timeInAgoTSShort(feed[pos].ts),
                  dtcValue: (feed[pos].dist / 100).round().toString() + " DTC",
                  duration: new Duration(
                      seconds: int.tryParse(feed[pos].jsonString!.dur) != null
                          ? int.parse(feed[pos].jsonString!.dur)
                          : 0),
                  thumbnailUrl: feed[pos].thumbUrl,
                  videoUrl: feed[pos].videoUrl,
                  videoSource: feed[pos].videoSource,
                  alreadyVoted: feed[pos].alreadyVoted!,
                  alreadyVotedDirection: feed[pos].alreadyVotedDirection!,
                  upvotesCount: feed[pos].upvotes!.length,
                  downvotesCount: feed[pos].downvotes!.length,
                  indexOfList: pos,
                  mainTag: feed[pos].jsonString!.tag,
                  oc: feed[pos].jsonString!.oc == 1 ? true : false,
                  enableNavigation: enableNavigation,
                  itemSelectedCallback: itemSelectedCallback,
                  feedType: feedType,
                  defaultCommentVotingWeight: _defaultCommentVotingWeight,
                  defaultPostVotingWeight: _defaultPostVotingWeight,
                  defaultPostVotingTip: _defaultPostVotingTip,
                ),
                //Text(pos.toString())
              ),
            );
          }
        } else {
          return Padding(
            padding:
                EdgeInsets.only(top: pos == 0 ? topPaddingForFirstEntry! : 0.0),
            child: SizedBox(
              height: 0,
            ),
          );
        }
      },
    );
  }
}

class PostListCard extends StatelessWidget {
  final bool showAuthor;
  final bool largeFormat;
  final bool blur;
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
  final double width;
  final double heightPerEntry;
  final bool enableNavigation;
  ListOfString2VoidFunc? itemSelectedCallback;
  final String feedType; // only used in landscape mode for now
  final String? defaultCommentVotingWeight;
  final String? defaultPostVotingWeight;
  final String? defaultPostVotingTip;

  PostListCard(
      {Key? key,
      required this.showAuthor,
      required this.largeFormat,
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
      required this.width,
      required this.heightPerEntry,
      required this.enableNavigation,
      this.itemSelectedCallback,
      required this.feedType,
      this.defaultCommentVotingWeight,
      this.defaultPostVotingWeight,
      this.defaultPostVotingTip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (largeFormat) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<UserBloc>(
          create: (BuildContext context) =>
              UserBloc(repository: UserRepositoryImpl()),
          child: PostListCardLarge(
            blur: blur,
            thumbnailUrl: thumbnailUrl,
            title: title,
            description: description,
            author: author,
            link: link,
            publishDate: publishDate,
            duration: duration,
            dtcValue: dtcValue,
            videoUrl: videoUrl,
            videoSource: videoSource,
            alreadyVoted: alreadyVoted,
            alreadyVotedDirection: alreadyVotedDirection,
            upvotesCount: upvotesCount,
            downvotesCount: downvotesCount,
            indexOfList: indexOfList,
            mainTag: mainTag,
            oc: oc,
            defaultCommentVotingWeight: defaultCommentVotingWeight!,
            defaultPostVotingWeight: defaultPostVotingWeight!,
            defaultPostVotingTip: defaultPostVotingTip!,
          ),
        ),
      );
    } else {
      return PostListCardNarrow(
        width: width,
        height: heightPerEntry,
        blur: blur,
        thumbnailUrl: thumbnailUrl,
        title: title,
        description: description,
        author: author,
        link: link,
        publishDate: publishDate,
        duration: duration,
        dtcValue: dtcValue,
        indexOfList: indexOfList,
        enableNavigation: enableNavigation,
        itemSelectedCallback: itemSelectedCallback,
        userPage: feedType == "UserFeed",
      );
    }
  }
}
