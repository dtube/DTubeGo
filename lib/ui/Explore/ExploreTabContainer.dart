import 'package:sizer/sizer.dart';

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
import 'package:dtube_togo/ui/pages/feeds/lists/FeedList.dart';

import 'package:dtube_togo/ui/pages/wallet/RewardsPage.dart';
import 'package:dtube_togo/ui/pages/wallet/WalletPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExploreMainPage extends StatefulWidget {
  ExploreMainPage({Key? key}) : super(key: key);

  @override
  _ExploreMainPageState createState() => _ExploreMainPageState();
}

class _ExploreMainPageState extends State<ExploreMainPage>
    with SingleTickerProviderStateMixin {
  List<String> _tabNames = ["Explore Videos", "Search Users/Videos"];
  List<IconData> _tabIcons = [
    FontAwesomeIcons.compass,
    FontAwesomeIcons.search
  ];
  late TabController _tabController;
  int _selectedIndex = 0;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        super.initState();
      }
    });
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
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 11.h, right: 4.w),
              //padding: EdgeInsets.only(top: 5.h),
              child: Container(
                width: 17.w,
                //color: Colors.black.withAlpha(20),
                child: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: ShadowedIcon(
                        icon: _tabIcons[0],
                        color: Colors.white,
                        shadowColor: Colors.black,
                        size: 5.w,
                      ),
                    ),
                    Tab(
                      child: ShadowedIcon(
                        icon: _tabIcons[1],
                        color: Colors.white,
                        shadowColor: Colors.black,
                        size: 5.w,
                      ),
                    ),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h, left: 4.w),
              //padding: EdgeInsets.only(top: 5.h),
              child: OverlayText(
                text: _tabNames[_selectedIndex],
                sizeMultiply: 1.2,
              ),
            ),
          )
          //),
          // ),
        ],
      ),
    );
  }
}
