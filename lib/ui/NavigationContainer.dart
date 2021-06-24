import 'dart:async';

import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/feeds/FeedList.dart';

import 'package:dtube_togo/ui/pages/notifications/Notifications.dart';
import 'package:dtube_togo/ui/pages/settings/Settings.dart';
import 'package:dtube_togo/ui/pages/upload/uploaderTabContainer.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavigationContainer extends StatefulWidget {
  NavigationContainer({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int bottomSelectedIndex = 0;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: new Icon(
            Icons.home,
            color: Colors.white,
          ),
          title: 'Feed'),
      PersistentBottomNavBarItem(
        icon: new Icon(
          Icons.watch_later_outlined,
          color: Colors.white,
        ),
        title: 'New',
      ),
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.contact_page_outlined,
            color: Colors.white,
          ),
          title: 'Profile'),
      PersistentBottomNavBarItem(
        icon: new Icon(
          Icons.fireplace,
          color: Colors.white,
        ),
        title: 'Hot',
      ),
      // TODO: combine hot + trending
      PersistentBottomNavBarItem(
        icon: new Icon(
          Icons.trending_up_outlined,
          color: Colors.white,
        ),
        title: 'Trending',
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  List<Widget> _buildScreens() {
    return [
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child:
            FeedList(feedType: 'MyFeed', bigThumbnail: true, showAuthor: false),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: FeedList(
          feedType: 'NewFeed',
          bigThumbnail: true,
          showAuthor: false,
        ),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (BuildContext context) =>
                UserBloc(repository: UserRepositoryImpl()),
          ),
          BlocProvider<TransactionBloc>(
            create: (BuildContext context) =>
                TransactionBloc(repository: TransactionRepositoryImpl()),
          ),
        ],
        child: UserPage(
          ownUserpage: true,
        ),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: FeedList(
            feedType: 'HotFeed', bigThumbnail: true, showAuthor: false),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: FeedList(
            feedType: 'TrendingFeed', bigThumbnail: true, showAuthor: false),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        elevation: 8,
        toolbarHeight: 60,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 130,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundColor: globalRed,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UploaderMainPage();
                            },
                          ),
                        );
                      },
                      child: Icon(
                        Icons.add_box_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Text(widget.title),
              DTubeLogo(size: 60),

              // TODO: figure out how to display notifications without violating the conbtext of the child tabview
              Container(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: globalBlue,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlocProvider<NotificationBloc>(
                                    create: (context) => NotificationBloc(
                                        repository:
                                            NotificationRepositoryImpl()),
                                    child: Notifications());
                              }));
                            },
                            child: Icon(
                              Icons.inbox,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: globalBlue,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlocProvider<SettingsBloc>(
                                    create: (context) => SettingsBloc(),
                                    child: SettingsPage());
                              }));
                            },
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // TODO: find good way to display balances all the time
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 8.0),
                    //   child: BalanceOverview(),
                    // ),
                  ],
                ),
              ),
              // TODO: figure out how to display notifications without violating the conbtext of the child tabview
            ],
          ),
        ),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: globalBGColor, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(25.0),
          colorBehindNavBar: globalBGColor,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.easeOut,
          duration: Duration(milliseconds: 200),
        ),
        // onItemSelected: (index) {
        //   setState(() {
        //     bottomSelectedIndex =
        //         index; // NOTE: THIS IS CRITICAL!! Don't miss it!
        //     _controller.index = index;
        //   });
        // },

        navBarStyle: NavBarStyle.style14,
      ),
    );
  }
}

class BalanceOverview extends StatefulWidget {
  const BalanceOverview({
    Key? key,
  }) : super(key: key);

  @override
  _BalanceOverviewState createState() => _BalanceOverviewState();
}

class _BalanceOverviewState extends State<BalanceOverview> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchDTCVPEvent()); // statements;
    const oneSec = const Duration(seconds: 240);
    new Timer.periodic(oneSec, (Timer t) {
      _userBloc.add(FetchDTCVPEvent());
    });
    // Do something
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBloc,
      builder: (context, state) {
        if (state is UserInitialState) {
          return SizedBox(width: 0, height: 12);
        } else if (state is UserDTCVPLoadingState) {
          return SizedBox(width: 0, height: 12);
        } else if (state is UserDTCVPLoadedState) {
          double _dtcBalanceK = state.dtcBalance / 100000;
          double _vpBalanceK = state.vtBalance["v"]! / 1000;
          try {
            return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                (_dtcBalanceK >= 1000 ? _dtcBalanceK / 1000 : _dtcBalanceK)
                        .toStringAsFixed(1) +
                    (_dtcBalanceK >= 1000 ? 'M' : 'K'),
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Text(
                "DTC",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(width: 4),
              Text(
                (_vpBalanceK >= 1000 ? _vpBalanceK / 1000 : _vpBalanceK)
                        .toStringAsFixed(1) +
                    (_vpBalanceK >= 1000 ? 'M' : 'K'),
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Text(
                "VP",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ]);
          } catch (e) {
            return Icon(Icons.error);
          }
        } else if (state is UserErrorState) {
          return new Icon(Icons.error);
        } else {
          return new Icon(Icons.error);
        }
      },
    );
  }
}
