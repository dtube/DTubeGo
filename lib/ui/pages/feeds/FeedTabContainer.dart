import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/FeedViewBase.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
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
    "Original DTubers",
    "Fresh Videos",
    "Follow Feed",
    "Hot Videos",
    "Trending Videos"
  ];
  List<IconData> _tabIcons = [
    FontAwesomeIcons.circleCheck,
    FontAwesomeIcons.rss,
    FontAwesomeIcons.userGroup,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.chartLine,
  ];
  late TabController _tabController;
  int _selectedIndex = 0;
  List<FilterTag> mockResults = [];
  String selectedTagsString = "";
  List<FilterTag> selectedMainTags = [];
  bool showTagFilter = false;
  FocusNode tagSearch = new FocusNode();
  late List<FeedViewBase> tabBarFeedItemList = [
    FeedViewBase(
        feedType: 'ODFeed',
        largeFormat: true,
        showAuthor: false,
        scrollCallback: (bool) {}),
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
  ];
  @override
  void initState() {
    if (globals.keyPermissions.isEmpty) {
      tabBarFeedItemList.removeAt(2); // remove MyFeed (followings) from tabs
      _tabNames.removeAt(2);
    }

    _tabController =
        new TabController(length: tabBarFeedItemList.length, vsync: this);
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
              ..add(FetchFeedEvent(feedType: "ODFeed"));
            break;
          case 1:
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(feedType: "NewFeed"));
            break;

          case 2:
            if (globals.keyPermissions.isEmpty) {
              BlocProvider.of<FeedBloc>(context)
                ..isFetching = true
                ..add(FetchFeedEvent(feedType: "HotFeed"));
            } else {
              BlocProvider.of<FeedBloc>(context)
                ..isFetching = true
                ..add(FetchFeedEvent(feedType: "MyFeed"));
            }
            break;

          case 3:
            if (globals.keyPermissions.isEmpty) {
              BlocProvider.of<FeedBloc>(context)
                ..isFetching = true
                ..add(FetchFeedEvent(feedType: "TrendingFeed"));
            } else {
              BlocProvider.of<FeedBloc>(context)
                ..isFetching = true
                ..add(FetchFeedEvent(feedType: "HotFeed"));
            }
            break;

          case 4:
            if (!globals.keyPermissions.isEmpty) {
              BlocProvider.of<FeedBloc>(context)
                ..isFetching = true
                ..add(FetchFeedEvent(feedType: "TrendingFeed"));
            }
            break;

          default:
        }
      }
    });
    BlocProvider.of<FeedBloc>(context)
      ..isFetching = true
      ..add(FetchFeedEvent(feedType: "ODFeed"));

    getMainTagsFromStorage();
    super.initState();
  }

  void getMainTagsFromStorage() async {
    String _selectedSubTags = "";
    String _mainTagsString = await sec.getGenreTags();
    List<String> _mainTags = _mainTagsString.split(',');
    selectedMainTags = [];
  }

  void pushMainTagsToStorage(String tags) async {
    await sec.persistGenreTags(tags);
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets _paddingTabBarView =
        EdgeInsets.zero; // only used in landscape for now

    return Scaffold(
      //appBar: dtubeSubAppBar(true, "", context, null),
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          Padding(
            padding: _paddingTabBarView,
            child: TabBarView(
              children: tabBarFeedItemList,
              controller: _tabController,
            ),
          ),
          TabBarWithPosition(
            tabIcons: _tabIcons,
            iconSize: globalIconSizeMedium,
            tabController: _tabController,
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(top: 11.h, right: 4.w),
            rotation: 0,
            menuSize: globals.keyPermissions.isEmpty
                ? globalIconSizeMedium * 6
                : globalIconSizeMedium * 8,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, left: 4.w),
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

class TabBarWithPosition extends StatefulWidget {
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
  State<TabBarWithPosition> createState() => _TabBarWithPositionState();
}

class _TabBarWithPositionState extends State<TabBarWithPosition> {
  late List<Tab> tabs;

  @override
  void initState() {
    tabs = [
      Tab(
        child: RotatedBox(
          quarterTurns: widget.rotation == 3 ? 1 : 0,
          child: ShadowedIcon(
              icon: widget.tabIcons[0],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
      ),
      Tab(
        child: RotatedBox(
          quarterTurns: widget.rotation == 3 ? 1 : 0,
          child: ShadowedIcon(
              icon: widget.tabIcons[1],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
      ),
      Tab(
        child: RotatedBox(
          quarterTurns: widget.rotation == 3 ? 1 : 0,
          child: ShadowedIcon(
              icon: widget.tabIcons[2],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
      ),
      Tab(
        child: RotatedBox(
          quarterTurns: widget.rotation == 3 ? 1 : 0,
          child: ShadowedIcon(
              icon: widget.tabIcons[3],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
      ),
      Tab(
        child: RotatedBox(
          quarterTurns: widget.rotation == 3 ? 1 : 0,
          child: ShadowedIcon(
              icon: widget.tabIcons[4],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
      ),
    ];
    if (globals.keyPermissions.isEmpty) {
      tabs.removeAt(2);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: widget.padding,
        child: RotatedBox(
          quarterTurns: widget.rotation,
          child: Container(
            width: widget.menuSize,
            child: TabBar(
              unselectedLabelColor: globalAlmostWhite,
              labelColor: globalAlmostWhite,
              indicatorColor: globalAlmostWhite,
              tabs: tabs,
              controller: widget.tabController,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}

class FilterTag {
  final String name;
  final String subtags;

  const FilterTag(this.name, this.subtags);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterTag &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
