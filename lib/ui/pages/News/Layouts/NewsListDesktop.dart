import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/pages/News/Widgets/NewsPostListCard.dart';

import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
