import 'package:dtube_togo/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_togo/ui/pages/moments/MomentsTabContainer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/MainContainer/BalanceOverview.dart';
import 'package:dtube_togo/ui/MainContainer/MenuButton.dart';
import 'package:dtube_togo/ui/pages/Explore/ExploreTabContainer.dart';

import 'package:dtube_togo/ui/pages/feeds/FeedTabContainer.dart';
import 'package:dtube_togo/ui/pages/notifications/NotificationButton.dart';

import 'package:dtube_togo/ui/pages/upload/uploaderTabContainer.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';

import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/ui/widgets/customSnackbar.dart';

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
  double iconSize = 10.w;

  int bottomSelectedIndex = 0;
  int _currentIndex = 0;
  PersistentTabController mainTabController =
      PersistentTabController(initialIndex: 0);

  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: new ShadowedIcon(
          icon: FontAwesomeIcons.alignJustify,
          color: Colors.white,
          shadowColor: Colors.black,
          size: 5.w,
        ),
      ),
    ),

    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: new ShadowedIcon(
          icon: FontAwesomeIcons.globeAfrica,
          color: Colors.white,
          shadowColor: Colors.black,
          size: 5.w,
        ),
      ),
    ),

    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
          if (state is TransactionPreprocessingState) {
            if (state.txType == 13 || state.txType == 4) {
              return DTubeLogoPulseRotating(size: 10.w * 2);
            }
          }
          return Center(
            child: new ShadowedIcon(
              icon: FontAwesomeIcons.plus,
              color: Colors.white,
              shadowColor: Colors.black,
              size: 5.w,
            ),
          );
        }),
      ),
    ),

    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: new ShadowedIcon(
          icon: FontAwesomeIcons.eye,
          color: Colors.white,
          shadowColor: Colors.black,
          size: 5.w,
        ),
      ),
    ),
    //  title: 'Hot',

    BottomNavigationBarItem(
      label: '',
      icon: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 5.w,
        child: AccountAvatarBase(
            username: "you",
            avatarSize: 8.w,
            showVerified: false,
            showName: false,
            width: 8.w),
      ),
    ),
  ];

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
    double iconSize = 5.w;
    if (Device.orientation == Orientation.landscape) {
      iconSize = 5.h;
    }

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
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Color(0x00ffffff),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  child: BalanceOverviewBase(),
                  onTap: () {
                    BlocProvider.of<UserBloc>(context).add(FetchDTCVPEvent());
                  }),
              BlocProvider<NotificationBloc>(
                create: (context) =>
                    NotificationBloc(repository: NotificationRepositoryImpl()),
                child: NotificationButton(iconSize: iconSize),
              ),
              buildMainMenuSpeedDial(context, iconSize)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: navBarItems,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
          child: IndexedStack(children: [
            FeedMainPage(),
            ExploreMainPage(),
            UploaderMainPage(
              callback: uploaderCallback,
              // key: UniqueKey(),
            ),
            MultiBlocProvider(providers: [
              BlocProvider(
                  create: (context) =>
                      FeedBloc(repository: FeedRepositoryImpl())),
              BlocProvider(
                  create: (context) =>
                      IPFSUploadBloc(repository: IPFSUploadRepositoryImpl())),
              BlocProvider<ThirdPartyUploaderBloc>(
                create: (BuildContext context) => ThirdPartyUploaderBloc(
                    repository: ThirdPartyUploaderRepositoryImpl()),
              ),
            ], child: MomentsPage(play: _currentIndex == 3)),
            UserPage(
              ownUserpage: true,
            ),
          ], index: _currentIndex)),
    );
  }
}
