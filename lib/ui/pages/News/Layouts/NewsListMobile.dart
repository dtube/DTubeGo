import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/pages/News/Widgets/NewsPostListCard.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter/material.dart';

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
