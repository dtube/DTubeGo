import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/News/NewsFeedList.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
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

            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Container(
                height: 80.h,
                width: 100.w,
                child: NewsFeedList(
                  newsList: newsFeed,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 1.h),
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
