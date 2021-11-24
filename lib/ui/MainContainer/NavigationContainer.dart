import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/appstate/appstate_bloc.dart';
import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/moments/MomentsTabContainer.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/MainContainer/BalanceOverview.dart';
import 'package:dtube_go/ui/MainContainer/MenuButton.dart';
import 'package:dtube_go/ui/pages/Explore/ExploreTabContainer.dart';
import 'package:dtube_go/ui/pages/feeds/FeedTabContainer.dart';
import 'package:dtube_go/ui/pages/notifications/NotificationButton.dart';
import 'package:dtube_go/ui/pages/upload/uploaderTabContainer.dart';
import 'package:dtube_go/ui/pages/user/User.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationContainer extends StatefulWidget {
  NavigationContainer({Key? key}) : super(key: key);

  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  late List<Widget> _screens;

  int bottomSelectedIndex = 0;
  int _currentIndex = 0;
  bool _firstTimeLogin = true;

  // list of navigation buttons
  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: new ShadowedIcon(
          icon: FontAwesomeIcons.alignJustify,
          color: Colors.white,
          shadowColor: Colors.black,
          size: globalIconSizeMedium,
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
          size: globalIconSizeMedium,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: BlocBuilder<AppStateBloc, AppState>(builder: (context, state) {
          if (state is UploadStartedState) {
            return DTubeLogoPulseWave(size: 10.w, progressPercent: 10);
          } else if (state is UploadProcessingState) {
            return DTubeLogoPulseWave(
                size: 10.w, progressPercent: state.progressPercent);
          } else if (state is UploadFinishedState) {
            return Center(
              child: new ShadowedIcon(
                icon: FontAwesomeIcons.check,
                color: Colors.green,
                shadowColor: Colors.black,
                size: globalIconSizeMedium,
              ),
            );
          } else if (state is UploadFailedState) {
            return Center(
              child: new ShadowedIcon(
                icon: FontAwesomeIcons.times,
                color: globalRed,
                shadowColor: Colors.black,
                size: globalIconSizeMedium,
              ),
            );
          } else {
            return Center(
              child: new ShadowedIcon(
                icon: FontAwesomeIcons.plus,
                color: Colors.white,
                shadowColor: Colors.black,
                size: globalIconSizeMedium,
              ),
            );
          }
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
          size: globalIconSizeMedium,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: CircleAvatar(
        backgroundColor: Colors.white,
        radius: globalIconSizeMedium * 0.6,
        child: AccountAvatarBase(
            username: "you",
            avatarSize: globalIconSizeMedium,
            showVerified: false,
            showName: false,
            width: globalIconSizeMedium,
            height: globalIconSizeMedium),
      ),
    ),
  ];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void uploaderCallback() {
    setState(() {
      _currentIndex = 0;
    });
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => PopUpDialogWithTitleLogo(
            callbackOK: () {},
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Do you really want to exit DTube Go?',
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'If you have an upload running in the background it will get lost if you close the app.',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: 2.h),
                InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: globalRed,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                      ),
                      child: Text(
                        "Yes",
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(true);
                    }),
              ],
            )),
            titleWidget:
                Center(child: FaIcon(FontAwesomeIcons.doorOpen, size: 18.w)),
            titleWidgetPadding: 10.h,
            titleWidgetSize: 20.w,
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void isFirstLogin() async {
    _firstTimeLogin = await sec.getFirstLogin();
  }

  @override
  void initState() {
    super.initState();
    // list of all available screens
    _screens = [
      BlocProvider(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: FeedMainPage(),
      ),
      BlocProvider(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: ExploreMainPage(),
      ),
      UploaderMainPage(
        callback: uploaderCallback,
        key: UniqueKey(),
      ),
      MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) =>
                    FeedBloc(repository: FeedRepositoryImpl())),
            BlocProvider(
                create: (context) =>
                    UserBloc(repository: UserRepositoryImpl())),
          ],
          child: MomentsPage(
              play: _currentIndex ==
                  3)), // start auto play the first moment if this is the current visible screen
      BlocProvider(
        create: (context) => UserBloc(repository: UserRepositoryImpl()),
        child: UserPage(
          ownUserpage: true,
        ),
      ),
    ];
    isFirstLogin();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup, //call function on back button press
      child: Scaffold(
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
                  create: (context) => NotificationBloc(
                      repository: NotificationRepositoryImpl()),
                  child: NotificationButton(iconSize: globalIconSizeMedium),
                ),
                buildMainMenuSpeedDial(context)
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: globalIconSizeMedium * 2.5,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black,
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: navBarItems,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                if (index == 2) {
                  // if the user navigated to the uploader screen
                  // reset uploader page
                  _screens.removeAt(2);
                  _screens.insert(
                      2,
                      new UploaderMainPage(
                        callback: uploaderCallback,
                        key: UniqueKey(),
                      ));
                }
                // if the user navigated to the moments page
                if (index == 3) {
                  // reset moments page and set play = true

                  _screens.removeAt(3);

                  _screens.insert(
                    3,
                    new MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (context) =>
                                  FeedBloc(repository: FeedRepositoryImpl())),
                        ],
                        child: MomentsPage(
                          key: UniqueKey(),
                          play: true,
                        )),
                    //  index = index;
                  );
                } else {
                  // if the user navigated to any other screen than the moments page
                  // reset moments page and set play = false
                  _screens.removeAt(3);

                  _screens.insert(
                      3,
                      MomentsPage(
                        key: UniqueKey(),
                        play: false,
                      ));
                }
                // if pressed menu button is at the upload button position
                if (index == 2) {
                  // if there is a current background upload running
                  //  show snackbar and do not navigate to the upload screen
                  if (BlocProvider.of<AppStateBloc>(context).state
                          is UploadStartedState ||
                      BlocProvider.of<AppStateBloc>(context).state
                          is UploadProcessingState) {
                    showCustomFlushbarOnError(
                        "please wait until upload is finished", context);
                  }
                  // if the most recent background upload task is finished
                  // reset UploadState and navigate to the upload screen
                  if (BlocProvider.of<AppStateBloc>(context).state
                          is UploadFinishedState ||
                      BlocProvider.of<AppStateBloc>(context).state
                          is UploadFailedState) {
                    BlocProvider.of<AppStateBloc>(context).add(
                        UploadStateChangedEvent(
                            uploadState: UploadInitialState()));
                    _currentIndex = index;
                  }
                  // if there is no background upload task running or recently finished
                  if (BlocProvider.of<AppStateBloc>(context).state
                      is UploadInitialState) {
                    // navigate to the uploader screen
                    _currentIndex = index;
                  }
                } else {
                  _currentIndex = index;
                }
              });
            },
          ),
        ),
        body:
            // show global snack bar to notify the user about transactions
            BlocListener<TransactionBloc, TransactionState>(
                bloc: BlocProvider.of<TransactionBloc>(context),
                listener: (context, state) {
                  if (state is TransactionSent) {
                    showCustomFlushbarOnSuccess(state, context);
                  }
                  if (state is TransactionError) {
                    showCustomFlushbarOnError(state.message, context);
                  }
                },
                child:
                    // show all pages as indexedStack to keep the state of every screen
                    IndexedStack(
                  children: _screens,
                  index: _currentIndex,
                )),
      ),
    );
  }
}
