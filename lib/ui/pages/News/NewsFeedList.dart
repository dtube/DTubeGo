import 'package:dtube_go/ui/pages/News/NewsPostListCard.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter/material.dart';
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

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return buildNewsList(newsList, true, context);
  }

  Widget buildNewsList(
      List<FeedItem> feed, bool bigThumbnail, BuildContext context) {
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
          blur: false,
          thumbnailUrl: feed[pos].thumbUrl,
          title: feed[pos].jsonString!.title,
          description: feed[pos].jsonString!.desc != null
              ? feed[pos].jsonString!.desc!
              : "",
          author: feed[pos].author,
          link: feed[pos].link,
          publishDate: TimeAgo.timeInAgoTSShort(feed[pos].ts),
          dtcValue: (feed[pos].dist / 100).round().toString(),
          duration: new Duration(
              seconds: int.tryParse(feed[pos].jsonString!.dur) != null
                  ? int.parse(feed[pos].jsonString!.dur)
                  : 0),

          videoUrl: feed[pos].videoUrl,
          videoSource: feed[pos].videoSource,
          alreadyVoted: feed[pos].alreadyVoted!,
          alreadyVotedDirection: feed[pos].alreadyVotedDirection!,
          upvotesCount: feed[pos].upvotes!.length,
          downvotesCount: feed[pos].downvotes!.length,
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
