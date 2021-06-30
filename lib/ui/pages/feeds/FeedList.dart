// TODO: known issue - no lazy loading for now.
// implement this to lazy load more entries:
// https://pub.dev/packages/loadmore
// https://github.com/dtube/javalon/blob/45d47cb38eefde0b84f29ba06be5571faecfa0ab/index.js#L105

import 'dart:ui';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:dtube_togo/ui/pages/feeds/PostListCardMainFeedV2.dart';
import 'package:dtube_togo/ui/pages/feeds/PostListCardUserFeed.dart';

import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/utils/friendlyTimestamp.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatefulWidget {
  String feedType;
  String? username;
  bool bigThumbnail;
  bool showAuthor;

  @override
  _FeedPageState createState() => _FeedPageState();

  FeedPage({
    required this.feedType,
    this.username,
    required this.bigThumbnail,
    required this.showAuthor,
    Key? key,
  }) : super(key: key);
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: globalAlmostBlack,
      body: FeedList(
        feedType: widget.feedType,
        username: widget.username,
        bigThumbnail: widget.bigThumbnail,
        showAuthor: widget.showAuthor,
      ),
    );
  }
}

class FeedList extends StatefulWidget {
  String feedType;
  String? username;
  bool bigThumbnail;
  bool showAuthor;

  @override
  _FeedListState createState() => _FeedListState();

  FeedList({
    required this.feedType,
    this.username,
    required this.bigThumbnail,
    required this.showAuthor,
    Key? key,
  }) : super(key: key);
}

class _FeedListState extends State<FeedList> {
  String? nsfwMode;
  String? hiddenMode;

  late FeedBloc postBloc;

  void getDisplayModes() async {
    hiddenMode = await sec.getShowHidden();
    nsfwMode = await sec.getNSFW();
    if (nsfwMode == null) {
      nsfwMode = 'blur';
    }
    if (hiddenMode == null) {
      hiddenMode = 'hide';
    }
  }

  @override
  void initState() {
    super.initState();
    postBloc = BlocProvider.of<FeedBloc>(context);
    getDisplayModes();
    if (widget.feedType != "UserFeed") {
      postBloc.add(FetchFeedEvent(feedType: widget.feedType));
    } else {
      postBloc.add(FetchUserFeedEvent(widget.username!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      // color: globalAlmostBlack,

      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedInitialState) {
            return buildLoading();
          } else if (state is FeedLoadingState) {
            return buildLoading();
          } else if (state is FeedLoadedState) {
            return buildPostList(state.feed, widget.bigThumbnail, true);
          } else if (state is FeedErrorState) {
            return buildErrorUi(state.message);
          } else {
            return buildErrorUi('test');
          }
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
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

  Widget buildPostList(
      List<FeedItem> feed, bool bigThumbnail, bool showAuthor) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: feed.length,
      itemBuilder: (ctx, pos) {
        // work on more sources
        if (feed[pos].jsonString!.files?.youtube != null ||
            feed[pos].jsonString!.files?.ipfs != null) {
          if ((nsfwMode == 'hide' && feed[pos].jsonString?.nsfw == 1) ||
              (hiddenMode == 'hide' && feed[pos].jsonString?.hide == 1)) {
            return SizedBox(
              height: 0,
            );
          } else {
            return BlocProvider<UserBloc>(
              create: (context) => UserBloc(repository: UserRepositoryImpl()),
              child: Padding(
                padding:
                    EdgeInsets.only(top: pos == 0 && bigThumbnail ? 90.0 : 0.0),
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: PostListCard(
                    bigThumbnail: bigThumbnail,
                    showAuthor: showAuthor,
                    blur: (nsfwMode == 'blur' &&
                                feed[pos].jsonString?.nsfw == 1) ||
                            (hiddenMode == 'blur' &&
                                feed[pos].jsonString?.hide == 1)
                        ? true
                        : false,
                    title: feed[pos].jsonString!.title,
                    description: feed[pos].jsonString!.desc != null
                        ? feed[pos].jsonString!.desc!
                        : "",
                    author: feed[pos].author,
                    link: feed[pos].link,
                    // publishDate: .toString(),
                    // publishDate: DateFormat('yyyy-MM-dd kk:mm').format(
                    //     DateTime.fromMicrosecondsSinceEpoch(feed[pos].ts * 1000)
                    //         .toLocal()),
                    publishDate: TimeAgo.timeInAgoTS(feed[pos].ts),
                    dtcValue:
                        (feed[pos].dist / 100).round().toString() + " DTC",
                    duration: new Duration(
                        seconds: int.tryParse(feed[pos].jsonString!.dur) != null
                            ? int.parse(feed[pos].jsonString!.dur)
                            : 0),
                    thumbnailUrl: feed[pos].thumbUrl,
                    videoUrl: feed[pos].videoUrl,
                    videoSource: feed[pos].videoSource,
                  ),
                ),
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
  final bool bigThumbnail;
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

  const PostListCard({
    Key? key,
    required this.showAuthor,
    required this.bigThumbnail,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bigThumbnail) {
      return Container(
        height: (MediaQuery.of(context).size.width / 16 * 9) + 100,
        child: PostListCardMainFeed(
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
        ),
      );
    } else {
      return PostListCardUserFeed(
          blur: blur,
          thumbnailUrl: thumbnailUrl,
          title: title,
          description: description,
          author: author,
          link: link,
          publishDate: publishDate,
          duration: duration,
          dtcValue: dtcValue);
    }
  }
}
