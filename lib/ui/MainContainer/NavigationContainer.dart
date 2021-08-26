import 'package:decorated_icon/decorated_icon.dart';

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_togo/bloc/search/search_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/realMain.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/MainContainer/BalanceOverview.dart';
import 'package:dtube_togo/ui/MainContainer/MenuButton.dart';
import 'package:dtube_togo/ui/Explore/ExploreTabContainer.dart';
import 'package:dtube_togo/ui/Explore/SearchScreen.dart';
import 'package:dtube_togo/ui/pages/feeds/FeedMainContainer.dart';
import 'package:dtube_togo/ui/pages/feeds/MomentsList.dart';
import 'package:dtube_togo/ui/pages/notifications/NotificationButton.dart';

import 'package:dtube_togo/ui/pages/feeds/FeedList.dart';

import 'package:dtube_togo/ui/pages/notifications/Notifications.dart';
import 'package:dtube_togo/ui/pages/upload/uploaderTabContainer.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:dtube_togo/ui/pages/wallet/WalletTabContainer.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/ui/widgets/customSnackbar.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavigationContainer extends StatefulWidget {
  NavigationContainer({Key? key}) : super(key: key);

  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  bool _hideNavBar = false;
  ValueNotifier<bool> _notifier = ValueNotifier(false);

  double topBarHeight = 90;
  int bottomSelectedIndex = 0;
  PersistentTabController mainTabController =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        opacity: 0.0,
        icon: Center(
          child: new DecoratedIcon(
            FontAwesomeIcons.alignJustify,
            color: Colors.white,
            size: 24,
            shadows: [
              BoxShadow(
                blurRadius: 24.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      PersistentBottomNavBarItem(
        opacity: 0.0,
        icon: Center(
          child: new DecoratedIcon(
            FontAwesomeIcons.globeAfrica,
            color: Colors.white,
            size: 24,
            shadows: [
              BoxShadow(
                blurRadius: 24.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      PersistentBottomNavBarItem(
        opacity: 0.0,
        icon: Center(
          child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
            if (state is TransactionPreprocessingState) {
              if (state.txType == 13 || state.txType == 4) {
                return DTubeLogoPulseRotating(size: 40.0);
              }
            }
            return Center(
              child: new FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.white,
              ),
            );
          }),
        ),
      ),
      PersistentBottomNavBarItem(
        opacity: 0.0,
        icon: Center(
          child: new DecoratedIcon(
            FontAwesomeIcons.eye,
            color: Colors.white,
            size: 24,
            shadows: [
              BoxShadow(
                blurRadius: 24.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        //  title: 'Hot',
      ),
      PersistentBottomNavBarItem(
          opacity: 0.0,
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
            child: AccountAvatarBase(
                username: "you",
                avatarSize: 25,
                showVerified: false,
                showName: false,
                width: 50),
          )),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void scrollCallback(bool hide) {
    _notifier.value = hide;
  }

  void uploaderCallback() {
    mainTabController.jumpToTab(0);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      FeedMainPage(),
      ExploreMainPage(),
      UploaderMainPage(
        callback: uploaderCallback,
        // key: UniqueKey(),
      ),
      MomentsList(),
      UserPage(
        ownUserpage: true,
      ),
    ];

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    BlocListener<TransactionBloc, TransactionState>(
      bloc: BlocProvider.of<TransactionBloc>(context),
      listener: (context, state) {
        if (state is TransactionSent) {
          print("test test");
          showCustomFlushbarOnSuccess(state, context);
        }
        if (state is TransactionError) {
          showCustomFlushbarOnError(state.message, context);
        }
      },
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                    child: BalanceOverviewBase(),
                    onTap: () {
                      BlocProvider.of<UserBloc>(context).add(FetchDTCVPEvent());
                    }),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocProvider<NotificationBloc>(
                      create: (context) => NotificationBloc(
                          repository: NotificationRepositoryImpl()),
                      child: NotificationButton(),
                    ),
                    buildMainMenuSpeedDial(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        bloc: BlocProvider.of<TransactionBloc>(context),
        listener: (context, state) {
          if (state is TransactionSent) {
            showCustomFlushbarOnSuccess(state, context);
          }
          if (state is TransactionError) {
            showCustomFlushbarOnError(state.message, context);
          }
        },
        child: PersistentTabView(
          context,

          controller: mainTabController,
          screens: screens,
          items: _navBarsItems(),
          bottomScreenMargin: 0.0,
          // hideNavigationBar:
          //     val, // autohide would be cool - but still buggy https://github.com/BilalShahid13/PersistentBottomNavBar/issues/188
          confineInSafeArea: true,
          backgroundColor: Colors.transparent, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.

          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: globalBGColor,
          ),

          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),

          navBarStyle: NavBarStyle.style15,
          onItemSelected: (index) {
            if (index == 2) {
              setState(() {
                screens.removeAt(2);

                screens.insert(
                    2,
                    new UploaderMainPage(
                      callback: uploaderCallback,
                      key: UniqueKey(),
                    )
                    //  index = index;
                    );
              });
            }
          },

          //  );
          //}
        ),
      ),
    );
  }
}
