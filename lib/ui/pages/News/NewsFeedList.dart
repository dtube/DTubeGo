import 'package:dtube_go/ui/pages/News/NewsPostListCard.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef ListOfString2VoidFunc = void Function(List<String>);

class NewsFeedList extends StatelessWidget {
  List<FeedItem> newsList;

  late YoutubePlayerController _youtubePlayerController;

  NewsFeedList({
    required this.newsList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        desktopBody: NewsListDesktop(
            feed: newsList,
            bigThumbnail: true,
            context: context,
            crossAxisCount: 4),
        mobileBody: NewsListMobile(
            feed: newsList, bigThumbnail: true, context: context),
        tabletBody: NewsListDesktop(
            feed: newsList,
            bigThumbnail: true,
            context: context,
            crossAxisCount: 2));
  }
}

class NewsListDesktop extends StatelessWidget {
  NewsListDesktop(
      {Key? key,
      required this.feed,
      required this.bigThumbnail,
      required this.context,
      required this.crossAxisCount})
      : super(key: key);

  final ScrollController _scrollController = ScrollController();
  final List<FeedItem> feed;
  final bool bigThumbnail;
  final BuildContext context;

  final int crossAxisCount;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MasonryGridView.count(
        key: new PageStorageKey("news" + 'listview'),
        addAutomaticKeepAlives: true,
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: feed.length,
        controller: _scrollController,
        itemBuilder: (ctx, pos) {
          return NewsPostListCard(
            thumbnailUrl: feed[pos].thumbUrl,
            title: feed[pos].jsonString!.title,
            description: feed[pos].jsonString!.desc != null
                ? feed[pos].jsonString!.desc!
                : "",
            author: feed[pos].author,
            link: feed[pos].link,
            publishDate: TimeAgo.timeInAgoTSShort(feed[pos].ts),

            videoUrl: feed[pos].videoUrl,
            videoSource: feed[pos].videoSource,
            crossAxisCount: crossAxisCount,
            indexOfList: pos,
            mainTag: feed[pos].jsonString!.tag,
            oc: feed[pos].jsonString!.oc == 1 ? true : false,

            autoPauseVideoOnPopup: false,

            //Text(pos.toString())
          );
        },
      ),
    );
  }
}

class NewsListMobile extends StatelessWidget {
  NewsListMobile({
    Key? key,
    required this.feed,
    required this.bigThumbnail,
    required this.context,
  }) : super(key: key);

  final ScrollController _scrollController = ScrollController();
  final List<FeedItem> feed;
  final bool bigThumbnail;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: new PageStorageKey("news" + 'listview'),
      addAutomaticKeepAlives: true,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: feed.length,
      controller: _scrollController,
      itemBuilder: (ctx, pos) {
        return NewsPostListCard(
          thumbnailUrl: feed[pos].thumbUrl,
          title: feed[pos].jsonString!.title,
          description: feed[pos].jsonString!.desc != null
              ? feed[pos].jsonString!.desc!
              : "",
          author: feed[pos].author,
          link: feed[pos].link,
          publishDate: TimeAgo.timeInAgoTSShort(feed[pos].ts),

          videoUrl: feed[pos].videoUrl,
          videoSource: feed[pos].videoSource,
          crossAxisCount: 1,
          indexOfList: pos,
          mainTag: feed[pos].jsonString!.tag,
          oc: feed[pos].jsonString!.oc == 1 ? true : false,

          autoPauseVideoOnPopup: false,

          //Text(pos.toString())
        );
      },
    );
  }
}
