import 'package:dtube_go/ui/pages/News/Layouts/NewsListDesktop.dart';
import 'package:dtube_go/ui/pages/News/Layouts/NewsListMobile.dart';
import 'package:dtube_go/ui/pages/News/Widgets/NewsPostListCard.dart';
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
