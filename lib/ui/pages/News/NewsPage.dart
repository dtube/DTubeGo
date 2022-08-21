import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/News/NewsFeedList.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({Key? key, required this.newsFeed, required this.okCallback})
      : super(key: key);
  List<FeedItem> newsFeed;
  VoidCallback okCallback;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: NewsPageMobile(newsFeed: newsFeed, okCallback: okCallback),
      desktopBody: NewsPageDesktop(newsFeed: newsFeed, okCallback: okCallback),
      tabletBody: NewsPageDesktop(newsFeed: newsFeed, okCallback: okCallback),
    );
  }
}

class NewsPageMobile extends StatelessWidget {
  const NewsPageMobile({
    Key? key,
    required this.newsFeed,
    required this.okCallback,
  }) : super(key: key);

  final List<FeedItem> newsFeed;
  final VoidCallback okCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Color(0x00ffffff),
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DTubeLogo(size: 10.w),
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(
                  "News",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ],
          ),
        ),
        body: //buildPostList

            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: 80.h,
            width: 100.w,
            child: NewsFeedList(
              newsList: newsFeed,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: InputChip(
                avatar: FaIcon(FontAwesomeIcons.check),
                label: Text(
                  "okay thanks!",
                  style: Theme.of(context).textTheme.headline4,
                ),
                backgroundColor: globalRed,
                onSelected: (value) async {
                  okCallback();
                }),
          ),
        ]));
  }
}

class NewsPageDesktop extends StatelessWidget {
  const NewsPageDesktop({
    Key? key,
    required this.newsFeed,
    required this.okCallback,
  }) : super(key: key);

  final List<FeedItem> newsFeed;
  final VoidCallback okCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                DTubeLogo(size: 50),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "News",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ],
            ),
            InputChip(
                avatar: FaIcon(FontAwesomeIcons.check),
                label: Text(
                  "okay thanks! Let me in",
                  style: Theme.of(context).textTheme.headline4,
                ),
                backgroundColor: globalRed,
                onSelected: (value) async {
                  okCallback();
                }),
          ],
        ),
      ),
      Expanded(
        child: NewsFeedList(
          newsList: newsFeed,
        ),
      ),
    ]));
  }
}

class NewsScreenLoading extends StatelessWidget {
  NewsScreenLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalBlue,
      body: Center(
        child: DtubeLogoPulseWithSubtitle(
          subtitle:
              "Checking recent news about DTube and the Avalon blockchain...",
          size: 40.w,
        ),
      ),
    );
  }
}
