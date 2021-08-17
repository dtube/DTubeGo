import 'package:dtube_togo/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_togo/bloc/search/search_bloc_full.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/Search/SearchScreen.dart';
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
  List<String> _tabNames = ["Hot", "Trending", "Search"];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        feedType: 'HotFeed',
                        bigThumbnail: true,
                        showAuthor: false,
                        paddingTop: 0,
                        scrollCallback: (bool) {}),
                    FeedList(
                        feedType: 'TrendingFeed',
                        bigThumbnail: true,
                        showAuthor: false,
                        paddingTop: 0,
                        scrollCallback: (bool) {}),
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
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30, 0, 0),
                child: Container(
                  width: 150,
                  height: 50,
                  child: TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: globalAlmostWhite,
                    indicatorColor: globalRed,
                    tabs: [
                      Tab(
                        text: 'Hot',
                      ),
                      Tab(
                        text: 'Trends',
                      ),
                      Tab(
                        text: 'Search',
                      ),
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.all(0.0),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
