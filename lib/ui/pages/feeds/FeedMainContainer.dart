import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_togo/bloc/search/search_bloc_full.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/Explore/SearchScreen.dart';
import 'package:dtube_togo/ui/pages/feeds/FeedList.dart';

import 'package:dtube_togo/ui/pages/wallet/RewardsPage.dart';
import 'package:dtube_togo/ui/pages/wallet/WalletPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedMainPage extends StatefulWidget {
  FeedMainPage({Key? key}) : super(key: key);

  @override
  _FeedMainPageState createState() => _FeedMainPageState();
}

class _FeedMainPageState extends State<FeedMainPage>
    with SingleTickerProviderStateMixin {
  List<String> _tabNames = ["New", "Follow", "Hot", "Trending"];
  List<IconData> _tabIcons = [
    FontAwesomeIcons.rss,
    FontAwesomeIcons.userFriends,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.chartLine
  ];
  late TabController _tabController;
  int _selectedIndex = 0;
  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        print("Selected Index: " + _tabController.index.toString());
        switch (_tabController.index) {
          case 0:
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(feedType: "NewFeed"));
            break;
          case 1:
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(feedType: "MyFeed"));
            break;

          case 2:
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(feedType: "HotFeed"));
            break;
          case 3:
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(feedType: "TrendingFeed"));
            break;
          default:
        }
      }
    });

    super.initState();
    BlocProvider.of<FeedBloc>(context)
      ..isFetching = true
      ..add(FetchFeedEvent(feedType: "NewFeed"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: dtubeSubAppBar(true, "", context, null),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          TabBarView(
            children: [
              FeedList(
                  feedType: 'NewFeed',
                  bigThumbnail: true,
                  showAuthor: false,
                  scrollCallback: (bool) {}),
              FeedList(
                  feedType: 'MyFeed',
                  bigThumbnail: true,
                  showAuthor: false,
                  scrollCallback: (bool) {}),
              FeedList(
                  feedType: 'HotFeed',
                  bigThumbnail: true,
                  showAuthor: false,
                  scrollCallback: (bool) {}),
              FeedList(
                  feedType: 'TrendingFeed',
                  bigThumbnail: true,
                  showAuthor: false,
                  scrollCallback: (bool) {}),
            ],
            controller: _tabController,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 13.h, right: 4.w),
              child: Container(
                width: 35.w,
                child: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  indicatorColor: Colors.white.withAlpha(50),
                  tabs: [
                    Tab(
                      child: ShadowedIcon(
                          icon: _tabIcons[0],
                          color: Colors.white,
                          shadowColor: Colors.black,
                          size: 5.w),
                    ),
                    Tab(
                      child: ShadowedIcon(
                          icon: _tabIcons[1],
                          color: Colors.white,
                          shadowColor: Colors.black,
                          size: 5.w),
                    ),
                    Tab(
                      child: ShadowedIcon(
                          icon: _tabIcons[2],
                          color: Colors.white,
                          shadowColor: Colors.black,
                          size: 5.w),
                    ),
                    Tab(
                      child: ShadowedIcon(
                          icon: _tabIcons[3],
                          color: Colors.white,
                          shadowColor: Colors.black,
                          size: 5.w),
                    ),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.all(0.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
