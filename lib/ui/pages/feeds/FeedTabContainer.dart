import 'package:dtube_go/ui/pages/feeds/Layouts/FeedTabsMobile.dart';
import 'package:dtube_go/ui/pages/feeds/Layouts/FeedTabsDesktop.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/FeedViewBase.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
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
  List<String> _tabNamesUnsignedLogin = [
    "Original DTubers",
    "Fresh Videos",
    // "Follow Feed",
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

  List<IconData> _tabIconsUnsignedLogin = [
    FontAwesomeIcons.circleCheck,
    FontAwesomeIcons.rss,
    // FontAwesomeIcons.userGroup,
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

  late List<FeedViewBase> tabBarFeedItemListUnsignedLogin = [
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
    // FeedViewBase(
    //     feedType: 'MyFeed',
    //     largeFormat: true,
    //     showAuthor: false,
    //     scrollCallback: (bool) {}),
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
    // if (globals.keyPermissions.isEmpty) {
    //   tabBarFeedItemList.removeAt(2); // remove MyFeed (followings) from tabs
    //   _tabNames.removeAt(2);
    // }

    _tabController = new TabController(
        length: globals.keyPermissions.isEmpty
            ? tabBarFeedItemListUnsignedLogin.length
            : tabBarFeedItemList.length,
        vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        print("Selected Index: " + _tabController.index.toString());

        loadFeedByIndex(_selectedIndex);
      }
    });
    BlocProvider.of<FeedBloc>(context)
      ..isFetching = true
      ..add(FetchFeedEvent(feedType: "ODFeed"));

    getMainTagsFromStorage();
    super.initState();
  }

  void loadFeedByIndex(int index) {
    switch (index) {
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
    return ResponsiveLayout(
      tabletBody: FeedTabsDesktop(
        tabBarFeedItemList: tabBarFeedItemList,
        tabBarFeedItemListUnsignedLogin: tabBarFeedItemListUnsignedLogin,
        tabController: _tabController,
        tabIcons: _tabIcons,
        tabIconsUnsignedLogin: _tabIconsUnsignedLogin,
        tabNames: _tabNames,
        tabNamesUnsignedLogin: _tabNamesUnsignedLogin,
        selectedIndex: _selectedIndex,
      ),
      mobileBody: FeedTabs(
        tabBarFeedItemList: tabBarFeedItemList,
        tabBarFeedItemListUnsignedLogin: tabBarFeedItemListUnsignedLogin,
        tabController: _tabController,
        tabIcons: _tabIcons,
        tabIconsUnsignedLogin: _tabIconsUnsignedLogin,
        tabNames: _tabNames,
        tabNamesUnsignedLogin: _tabNamesUnsignedLogin,
        selectedIndex: _selectedIndex,
      ),
      desktopBody: FeedTabsDesktop(
          tabBarFeedItemList: tabBarFeedItemList,
          tabBarFeedItemListUnsignedLogin: tabBarFeedItemListUnsignedLogin,
          tabController: _tabController,
          tabIcons: _tabIcons,
          tabIconsUnsignedLogin: _tabIconsUnsignedLogin,
          tabNames: _tabNames,
          tabNamesUnsignedLogin: _tabNamesUnsignedLogin,
          selectedIndex: _selectedIndex),
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
