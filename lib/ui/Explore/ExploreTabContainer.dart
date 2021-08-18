import 'package:dtube_togo/bloc/feed/feed_bloc.dart';
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_togo/bloc/search/search_bloc_full.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/Explore/SearchScreen.dart';
import 'package:dtube_togo/ui/Explore/StaggeredFeed.dart';
import 'package:dtube_togo/ui/pages/feeds/FeedList.dart';

import 'package:dtube_togo/ui/pages/wallet/RewardsPage.dart';
import 'package:dtube_togo/ui/pages/wallet/WalletPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreMainPage extends StatefulWidget {
  ExploreMainPage({Key? key}) : super(key: key);

  @override
  _ExploreMainPageState createState() => _ExploreMainPageState();
}

class _ExploreMainPageState extends State<ExploreMainPage>
    with SingleTickerProviderStateMixin {
  List<String> _tabNames = ["Explore", "Search"];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    BlocProvider<FeedBloc>(
                        create: (context) =>
                            FeedBloc(repository: FeedRepositoryImpl())
                              ..add(FetchFeedEvent(feedType: "HotFeed")),
                        child: StaggeredFeed()),
                    BlocProvider<SearchBloc>(
                        create: (context) =>
                            SearchBloc(repository: SearchRepositoryImpl()),
                        child: SearchScreen()),
                  ],
                  controller: _tabController,
                ),
              ),
              // ),
            ],
          ),

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
                  tabs: [
                    Tab(
                      child: OverlayText(text: _tabNames[0]),
                    ),
                    Tab(
                      child: OverlayText(text: _tabNames[1]),
                    ),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.all(0.0),
                ),
              ),
            ),
          ),
          //),
          // ),
        ],
      ),
    );
  }
}
