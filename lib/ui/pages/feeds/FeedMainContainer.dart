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
  late TabController _tabController;
  int _selectedIndex = 0;
  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    // BlocProvider.of<FeedBloc>(context).add(FetchFeedEvent(feedType: "NewFeed"));
    //_tabController.addListener(_handleTabSelection);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
      print("Selected Index: " + _tabController.index.toString());
      switch (_tabController.index) {
        case 0:
          BlocProvider.of<FeedBloc>(context)
              .add(FetchFeedEvent(feedType: "NewFeed"));
          break;
        case 1:
          BlocProvider.of<FeedBloc>(context)
              .add(FetchFeedEvent(feedType: "MyFeed"));
          break;

        case 2:
          BlocProvider.of<FeedBloc>(context)
              .add(FetchFeedEvent(feedType: "HotFeed"));
          break;
        case 3:
          BlocProvider.of<FeedBloc>(context)
              .add(FetchFeedEvent(feedType: "TrendingFeed"));
          break;
        default:
      }
    });

    super.initState();
    BlocProvider.of<FeedBloc>(context).add(FetchFeedEvent(feedType: "NewFeed"));
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //appBar: dtubeSubAppBar(true, "", context, null),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child:
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child:
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
                    // BlocProvider<SearchBloc>(
                    //     create: (context) =>
                    //         SearchBloc(repository: SearchRepositoryImpl()),
                    //     child: SearchScreen()),
                  ],
                  controller: _tabController,
                ),
              ),
              // ),
            ],
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child:
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0.0, 30, 0, 0),
          //   child:
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: RotatedBox(
          //     quarterTurns: 3,
          //     child:

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 75.0),
              child: Container(
                width: deviceWidth,
                height: 35,
                child: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  indicatorColor: Colors.white.withAlpha(50),

                  //indicatorPadding: EdgeInsets.zero,
                  // indicator: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10), // Creates border
                  //     color: Colors.white.withAlpha(20)),
                  //indicatorWeight: 6,
                  tabs: [
                    Tab(
                      child: OverlayText(text: _tabNames[0]),
                    ),
                    Tab(
                      child: OverlayText(text: _tabNames[1]),
                    ),
                    Tab(
                      child: OverlayText(text: _tabNames[2]),
                    ),
                    Tab(
                      child: OverlayText(text: _tabNames[3]),
                    ),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.all(0.0),
                ),
              ),
            ),
          ),
          //   ),
          // ),
          //),
          // ),
        ],
      ),
    );
  }
}
