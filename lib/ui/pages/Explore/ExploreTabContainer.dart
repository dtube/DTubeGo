import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/feed/feed_bloc.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';

import 'package:dtube_go/bloc/search/search_bloc_full.dart';

import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/pages/Explore/SearchScreen.dart';
import 'package:dtube_go/ui/pages/Explore/StaggeredFeed.dart';

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
  late String _exploreTags = "";
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    getExploreTags();
    _tabController.addListener(() {
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
    super.initState();
  }

  Future<String> getExploreTags() async {
    _exploreTags = await sec.getExploreTags();

    return _exploreTags;
  }

  void searchForTag(String tag) {
    setState(() {
      _tabController.index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: getExploreTags(),
        builder: (context, exploreTagsSnapshot) {
          if (exploreTagsSnapshot.connectionState == ConnectionState.none ||
              exploreTagsSnapshot.connectionState == ConnectionState.waiting) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }

          return Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 15.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(0.0),
                          ],
                          stops: [
                            0.0,
                            1.0
                          ])),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        _exploreTags != ""
                            ? BlocProvider<FeedBloc>(
                                create: (context) => FeedBloc(
                                    repository: FeedRepositoryImpl())
                                  ..add(
                                      FetchTagSearchResults(tag: _exploreTags)),
                                child: StaggeredFeed(
                                  searchTags: _exploreTags,
                                ))
                            : BlocProvider<FeedBloc>(
                                create: (context) => FeedBloc(
                                    repository: FeedRepositoryImpl())
                                  ..add(FetchFeedEvent(feedType: "HotFeed")),
                                child: StaggeredFeed(
                                  searchTags: "",
                                )),
                        MultiBlocProvider(providers: [
                          BlocProvider<SearchBloc>(
                              create: (context) => SearchBloc(
                                  repository: SearchRepositoryImpl())),
                          BlocProvider(
                              create: (context) =>
                                  FeedBloc(repository: FeedRepositoryImpl())),
                        ], child: SearchScreen()),
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
                    width: globalIconSizeMedium * 3,
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
                              size: globalIconSizeMedium),
                        ),
                        Tab(
                          child: ShadowedIcon(
                              icon: _tabIcons[1],
                              color: Colors.white,
                              shadowColor: Colors.black,
                              size: globalIconSizeMedium),
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
                    sizeMultiply: 1.4,
                    bold: true,
                  ),
                ),
              ),

              //),
              // ),
            ],
          );
        },
      ),
    );
  }
}
