import 'dart:async';

import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';
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
        icon: new Icon(
          Icons.add,
          color: Colors.white,
        ),
        title: 'Create',
      ),
      PersistentBottomNavBarItem(
        icon: new Icon(
          Icons.fireplace,
          color: Colors.white,
        ),
        title: 'Hot',
      ),
      // TODO: combine hot + trending
      // PersistentBottomNavBarItem(
      //   icon: new Icon(Icons.trending_up_outlined),
      //   title: 'Trending',
      // ),
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.contact_page_outlined,
            color: Colors.white,
          ),
          title: 'Profile')
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
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: UploaderMainPage(),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: FeedList(
            feedType: 'HotFeed', bigThumbnail: true, showAuthor: false),
      ),
      // TODO: combine Hot + Trending
      // BlocProvider<FeedBloc>(
      //   create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
      //   child: FeedList(
      //       feedType: 'TrendingFeed', bigThumbnail: true, showAuthor: false),
      // ),
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
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
          ],
        ),
        actions: <Widget>[
          BalanceOverview(),
          // TODO: figure out how to display notifications without violating the conbtext of the child tabview
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlocProvider<NotificationBloc>(
                    create: (context) => NotificationBloc(
                        repository: NotificationRepositoryImpl()),
                    child: Notifications());
              }));
            },
          ),
          // TODO: figure out how to display notifications without violating the conbtext of the child tabview
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlocProvider<SettingsBloc>(
                    create: (context) => SettingsBloc(), child: SettingsPage());
              }));
            },
          ),
        ],
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: globalBlue, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: globalAlmostBlack,
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
        //navBarHeight: 60,
        navBarStyle: NavBarStyle.style15,
        // Choose the nav bar style with this property.
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(widget.title),
//           ],
//         ),
//         actions: <Widget>[
//           BalanceOverview(),
//           IconButton(
//             icon: Icon(Icons.info),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return BlocProvider<NotificationBloc>(
//                     create: (context) => NotificationBloc(
//                         repository: NotificationRepositoryImpl()),
//                     child: Notifications());
//               }));
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return BlocProvider<SettingsBloc>(
//                     create: (context) => SettingsBloc(), child: SettingsPage());
//               }));
//             },
//           ),
//         ],
//       ),
//       body: buildPageView(),
//       bottomNavigationBar: BottomNavigationBar(
//         showUnselectedLabels: true,
//         currentIndex: bottomSelectedIndex,
//         selectedIconTheme: IconThemeData(color: globalRed),
//         unselectedIconTheme: IconThemeData(color: globalAlmostWhite),
//         selectedItemColor: globalAlmostWhite,
//         unselectedItemColor: globalAlmostWhite,
//         onTap: (index) {
//           bottomTapped(index);
//         },
//         items: buildBottomNavBarItems(),
//       ),
//     );
//   }
// }
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
          return SizedBox(width: 0, height: 0);
        } else if (state is UserDTCVPLoadingState) {
          return SizedBox(width: 0, height: 0);
        } else if (state is UserDTCVPLoadedState) {
          try {
            return Row(children: [
              Text(
                (state.dtcBalance / 100000).toStringAsFixed(1) + 'K',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "DTC",
              ),
              SizedBox(width: 8),
              Text(
                (state.vtBalance["v"]! / 1000).toStringAsFixed(0) + 'K',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "VP",
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
