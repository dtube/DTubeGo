import 'package:sizer/sizer.dart';

import 'dart:ui';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';

import 'package:dtube_togo/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_togo/ui/pages/feeds/cards/PostListCardNarrow.dart';

import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/utils/friendlyTimestamp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);

class FeedList extends StatelessWidget {
  String feedType;
  String? username;
  bool largeFormat;
  bool showAuthor;

  Bool2VoidFunc scrollCallback;
  late YoutubePlayerController _youtubePlayerController;

  FeedList({
    required this.feedType,
    this.username,
    required this.largeFormat,
    required this.showAuthor,
    required this.scrollCallback,
    Key? key,
  }) : super(key: key);

  late FeedBloc postBloc;
  final ScrollController _scrollController = ScrollController();
  List<FeedItem> _feedItems = [];

  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;

  Future<bool> getDisplayModes() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
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
    return FutureBuilder<bool>(
        future: getDisplayModes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return buildLoading(context);
          } else {
            return Container(
              height: 100.h,
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
                  return buildPostList(
                      _feedItems, largeFormat, true, context, feedType);
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
            : DTubeLogoPulse(size: 33.w));
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
              padding: EdgeInsets.only(top: pos == 0 ? 16.h : 8.0),
              child: SizedBox(
                height: 0,
              ),
            );
          } else {
            return BlocProvider<UserBloc>(
              create: (context) => UserBloc(repository: UserRepositoryImpl()),
              child: Padding(
                padding: EdgeInsets.only(top: pos == 0 ? 16.h : 8.0),
                child: PostListCard(
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
                  publishDate: TimeAgo.timeInAgoTS(feed[pos].ts),
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
                ),
                //Text(pos.toString())
              ),
            );
          }
        } else {
          return SizedBox(
            height: 0,
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

  const PostListCard({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (largeFormat) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
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
        ),
      );
    } else {
      return PostListCardNarrow(
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
      );
    }
  }
}
