import 'package:dtube_go/ui/pages/feeds/FeedViewBase.dart';
import 'package:dtube_go/utils/ResponsiveLayout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';

import 'package:dtube_go/style/styledCustomWidgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedMainPage extends StatefulWidget {
  FeedMainPage({Key? key}) : super(key: key);

  @override
  _FeedMainPageState createState() => _FeedMainPageState();
}

class _FeedMainPageState extends State<FeedMainPage>
    with SingleTickerProviderStateMixin {
  List<String> _tabNames = [
    "Fresh Videos",
    "Follow Feed",
    "Hot Videos",
    "Trending Videos"
  ];
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
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        print("Selected Index: " + _tabController.index.toString());
        switch (_selectedIndex) {
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
    BlocProvider.of<FeedBloc>(context)
      ..isFetching = true
      ..add(FetchFeedEvent(feedType: "NewFeed"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _iconSize = 5.w;
    EdgeInsets _paddingTabBarView =
        EdgeInsets.zero; // only used in landscape for now
    if (Device.orientation == Orientation.landscape) {
      _iconSize = 5.h;
    }
    if (Device.orientation == Orientation.landscape) {
      _paddingTabBarView = EdgeInsets.only(left: _iconSize * 2 + 10);
    }
    return Scaffold(
      //appBar: dtubeSubAppBar(true, "", context, null),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Padding(
            padding: _paddingTabBarView,
            child: TabBarView(
              children: [
                FeedViewBase(
                    feedType: 'NewFeed',
                    largeFormat: true,
                    showAuthor: false,
                    scrollCallback: (bool) {}),
                FeedViewBase(
                    feedType: 'MyFeed',
                    largeFormat: true,
                    showAuthor: false,
                    scrollCallback: (bool) {}),
                FeedViewBase(
                    feedType: 'HotFeed',
                    largeFormat: true,
                    showAuthor: false,
                    scrollCallback: (bool) {}),
                FeedViewBase(
                    feedType: 'TrendingFeed',
                    largeFormat: true,
                    showAuthor: false,
                    scrollCallback: (bool) {}),
              ],
              controller: _tabController,
            ),
          ),
          ResponsiveLayout(
            portrait: TabBarWithPosition(
              tabIcons: _tabIcons,
              iconSize: _iconSize,
              tabController: _tabController,
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 11.h, right: 4.w),
              rotation: 0,
              menuSize: 35.w,
            ),
            landscape: TabBarWithPosition(
              tabIcons: _tabIcons,
              iconSize: _iconSize,
              tabController: _tabController,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              rotation: 3,
              menuSize: 80.h,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              //padding: EdgeInsets.only(top: 5.h),
              child: OverlayText(
                text: _tabNames[_selectedIndex],
                sizeMultiply: 1.4,
                bold: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TabBarWithPosition extends StatelessWidget {
  const TabBarWithPosition(
      {Key? key,
      required this.tabIcons,
      required this.iconSize,
      required this.tabController,
      required this.alignment,
      required this.padding,
      required this.rotation,
      required this.menuSize})
      : super(key: key);

  final List<IconData> tabIcons;
  final double iconSize;
  final TabController tabController;
  final Alignment alignment;
  final EdgeInsets padding;
  final int rotation;
  final double menuSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: RotatedBox(
          quarterTurns: rotation,
          child: Container(
            width: menuSize,
            child: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[0],
                        color: Colors.white,
                        shadowColor: Colors.black,
                        size: iconSize),
                  ),
                ),
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[1],
                        color: Colors.white,
                        shadowColor: Colors.black,
                        size: iconSize),
                  ),
                ),
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[2],
                        color: Colors.white,
                        shadowColor: Colors.black,
                        size: iconSize),
                  ),
                ),
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[3],
                        color: Colors.white,
                        shadowColor: Colors.black,
                        size: iconSize),
                  ),
                ),
              ],
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
