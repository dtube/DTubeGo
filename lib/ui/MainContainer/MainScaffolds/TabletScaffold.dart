import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/ui/pages/News/NewsPage.dart';
import 'package:dtube_go/ui/pages/settings/HiveSignerForm.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/ui/pages/Explore/GenreBase.dart';
import 'package:dtube_go/ui/pages/upload/UploadPresetSelection.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
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
import 'package:dtube_go/ui/MainContainer/Widgets/BalanceOverview.dart';
import 'package:dtube_go/ui/MainContainer/Widgets/MenuButton.dart';
import 'package:dtube_go/ui/pages/feeds/FeedTabContainer.dart';
import 'package:dtube_go/ui/pages/notifications/NotificationButton.dart';
import 'package:dtube_go/ui/pages/user/User.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabletScaffold extends StatefulWidget {
  TabletScaffold({Key? key}) : super(key: key);

  @override
  _TabletScaffoldState createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  late List<Widget> _screens;
  late FeedBloc _newsFeedBloc = new FeedBloc(repository: FeedRepositoryImpl());
  bool exitNewsScreen = false;

  int bottomSelectedIndex = 0;
  int _currentIndex = 0;
  bool _firstTimeLogin = false;

  // list of navigation buttons
  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
      label: 'Feeds',
      icon: Center(
        child: new BorderedIcon(
          icon: FontAwesomeIcons.alignJustify,
          color: globalAlmostWhite,
          borderColor: Colors.black,
          size: globalIconSizeBig,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: 'Explore',
      icon: Center(
        child: new BorderedIcon(
          icon: FontAwesomeIcons.earthAfrica,
          color: globalAlmostWhite,
          borderColor: Colors.black,
          size: globalIconSizeBig,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: 'Create',
      icon: Center(
        child: BlocBuilder<AppStateBloc, AppState>(builder: (context, state) {
          if (state is UploadStartedState) {
            return DTubeLogoPulseWave(
                size: globalIconSizeBig, progressPercent: 10);
          } else if (state is UploadProcessingState) {
            return DTubeLogoPulseWave(
                size: globalIconSizeBig,
                progressPercent: state.progressPercent);
          } else if (state is UploadFinishedState) {
            return Center(
              child: new BorderedIcon(
                icon: FontAwesomeIcons.check,
                color: Colors.green,
                borderColor: Colors.black,
                size: globalIconSizeBig,
              ),
            );
          } else if (state is UploadFailedState) {
            return Center(
              child: new BorderedIcon(
                icon: FontAwesomeIcons.xmark,
                color: globalRed,
                borderColor: Colors.black,
                size: globalIconSizeBig,
              ),
            );
          } else {
            return Center(
              child: new BorderedIcon(
                icon: FontAwesomeIcons.plus,
                color: globals.keyPermissions.contains(4)
                    ? globalAlmostWhite
                    : Colors.grey,
                borderColor: Colors.black,
                size: globalIconSizeBig,
              ),
            );
          }
        }),
      ),
    ),
    BottomNavigationBarItem(
      label: 'Moments',
      icon: Center(
        child: new BorderedIcon(
          icon: FontAwesomeIcons.podcast,
          color: globalAlmostWhite,
          borderColor: Colors.black,
          size: globalIconSizeBig,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: 'Profile',
      icon: globals.keyPermissions.isEmpty
          ? FaIcon(FontAwesomeIcons.userSecret)
          : AccountIconBase(
              avatarSize: globalIconSizeBig + 2.w,
              showVerified: false,
              username: "you",
              showBorder: true,
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
            showTitleWidget: true,
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

  void revalidateHiveSigner() async {
    String _hivesignerUsername = await sec.getHiveSignerUsername();
    String _hivesignerAccessToken = await sec.getHiveSignerAccessToken();
    String _hivesignerAccessTokenExpiresIn =
        await sec.getHiveSignerAccessTokenExpiresIn();
    String _hivesignerAccessTokenRequestedOn =
        await sec.getHiveSignerAccessTokenRequestedOn();
    // uncomment to invalidate hivesigner connection
    // await sec.persistHiveSignerData(
    //     _hivesignerAccessToken,
    //     _hivesignerAccessTokenExpiresIn,
    //     "2022-01-26 00:02:37.965113",
    //     _hivesignerUsername);
    // check if set
    if (_hivesignerAccessToken != '') {
      DateTime requestDate = DateTime.parse(_hivesignerAccessTokenRequestedOn);
      if (DateTime.now().isAfter(requestDate.add(
          Duration(seconds: int.parse(_hivesignerAccessTokenExpiresIn))))) {
        showDialog(
            context: context,
            builder: (context) => PopUpDialogWithTitleLogo(
                  showTitleWidget: true,
                  titleWidget: Center(
                      child: FaIcon(
                    FontAwesomeIcons.hive,
                    size: 18.w,
                    color: globalRed,
                  )),
                  titleWidgetPadding: 10.h,
                  titleWidgetSize: 20.w,
                  callbackOK: () {},
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Hivesigner outdated",
                              style: Theme.of(context).textTheme.headline4),
                          Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(
                                "The authorization for your hive account is not valid anymore. This happens automatically after 7 days for security reasons. Please renew the authorization by clicking on the button below.",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          BlocProvider<HivesignerBloc>(
                            create: (BuildContext context) => HivesignerBloc(
                                repository: HivesignerRepositoryImpl()),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: HiveSignerForm(
                                username: _hivesignerUsername,
                                validCallback: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
      }
    }
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
        child: GenreBase(),
      ),
      // UploaderMainPage(
      UploadPresetSelection(
        //callback: uploaderCallback,
        uploaderCallback: uploaderCallback,
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
    revalidateHiveSigner();
    _newsFeedBloc.add(FetchFeedEvent(feedType: "NewsFeed"));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: showExitPopup, //call function on back button press
        child: BlocBuilder<FeedBloc, FeedState>(
            bloc: _newsFeedBloc,
            builder: (context, state) {
              if (state is FeedLoadingState) {
                return NewsScreenLoading(
                  crossAxisCount: 2,
                );
              }

              if (state is FeedLoadedState) {
                if (state.feed.isNotEmpty && !exitNewsScreen) {
                  return NewsScreen(
                    newsFeed: state.feed,
                    okCallback: () async {
                      await sec.persistCurrenNewsTS();
                      setState(() {
                        exitNewsScreen = true;
                      });
                    },
                  );
                }

                if (state.feed.isEmpty || exitNewsScreen) {
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
                        child: globals.keyPermissions.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      BlocProvider.of<AuthBloc>(context)
                                          .add(SignOutEvent(context: context));
                                      //do stuff
                                    },
                                    child: Text(
                                      "Join / Login",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      child: BalanceOverviewBase(),
                                      onTap: () {
                                        BlocProvider.of<UserBloc>(context)
                                            .add(FetchDTCVPEvent());
                                      }),
                                  BlocProvider<NotificationBloc>(
                                    create: (context) => NotificationBloc(
                                        repository:
                                            NotificationRepositoryImpl()),
                                    child: NotificationButton(
                                        iconSize: globalIconSizeMedium),
                                  ),
                                  buildMainMenuSpeedDial(context)
                                ],
                              ),
                      ),
                    ),
                    bottomNavigationBar: Container(
                      height: globalIconSizeBig * 2.4,
                      decoration: BoxDecoration(
                          color: globalAlmostWhite,
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
                      child: Center(
                        child: BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          showUnselectedLabels: false,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          items: navBarItems,
                          selectedItemColor: globalAlmostWhite,

                          // iconSize: globalIconSizeBig,
                          currentIndex: _currentIndex,
                          onTap: (index) {
                            setState(() {
                              // if the user navigated to the moments page
                              if (index == 3) {
                                // reset moments page and set play = true

                                _screens.removeAt(3);

                                _screens.insert(
                                  3,
                                  new MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                            create: (context) => FeedBloc(
                                                repository:
                                                    FeedRepositoryImpl())),
                                      ],
                                      child: MomentsPage(
                                        key: UniqueKey(),
                                        play: true,
                                      )),
                                  //  index = index;
                                );
                              } else {
                                // if the key allows to upload OR it is not the posting screen
                                if (globals.keyPermissions.contains(4) ||
                                    index != 2) {
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
                              }
                              // if pressed menu button is at the upload button position
                              if (index == 2) {
                                if (globals.keyPermissions.contains(4)) {
                                  // if there is a current background upload running
                                  //  show snackbar and do not navigate to the upload screen
                                  if (BlocProvider.of<AppStateBloc>(context)
                                          .state is UploadStartedState ||
                                      BlocProvider.of<AppStateBloc>(context)
                                          .state is UploadProcessingState) {
                                    showCustomFlushbarOnError(
                                        "please wait until upload is finished",
                                        context);
                                  }
                                  // if the most recent background upload task is finished
                                  // reset UploadState and navigate to the upload screen
                                  if (BlocProvider.of<AppStateBloc>(context)
                                          .state is UploadFinishedState ||
                                      BlocProvider.of<AppStateBloc>(context)
                                          .state is UploadFailedState) {
                                    BlocProvider.of<AppStateBloc>(context).add(
                                        UploadStateChangedEvent(
                                            uploadState: UploadInitialState()));
                                    _screens.removeAt(2);
                                    _screens.insert(
                                        2,
                                        new
                                        //UploaderMainPage(
                                        //callback: uploaderCallback,
                                        UploadPresetSelection(
                                          uploaderCallback: uploaderCallback,
                                          key: UniqueKey(),
                                        ));
                                    _currentIndex = index;
                                  }
                                  // if there is no background upload task running or recently finished
                                  if (BlocProvider.of<AppStateBloc>(context)
                                      .state is UploadInitialState) {
                                    // navigate to the uploader screen
                                    // if the user navigated to the uploader screen
                                    // reset uploader page
                                    _screens.removeAt(2);
                                    _screens.insert(
                                        2,
                                        new
                                        //UploaderMainPage(
                                        //callback: uploaderCallback,
                                        UploadPresetSelection(
                                          uploaderCallback: uploaderCallback,
                                          key: UniqueKey(),
                                        ));

                                    _currentIndex = index;
                                  }
                                } else {
                                  showCustomFlushbarOnError(
                                      "you need to be signed in to upload content",
                                      context);
                                }
                              } else {
                                if (index == 4) {
                                  // if the selected page is the profile page
                                  if (globals.keyPermissions.isEmpty) {
                                    showCustomFlushbarOnError(
                                        "you need to be signed in to access your profile",
                                        context);
                                  } else {
                                    _screens.removeAt(4);
                                    _screens.insert(
                                      4,
                                      BlocProvider(
                                        create: (context) => UserBloc(
                                            repository: UserRepositoryImpl()),
                                        child: UserPage(
                                          ownUserpage: true,
                                          //key: UniqueKey(),
                                        ),
                                      ),
                                    );
                                    _currentIndex = index;
                                  }
                                } else {
                                  _currentIndex = index;
                                }
                              }
                            });
                          },
                        ),
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
                                showCustomFlushbarOnError(
                                    state.message, context);
                              }
                            },
                            child:
                                // show all pages as indexedStack to keep the state of every screen
                                IndexedStack(
                              children: _screens,
                              index: _currentIndex,
                            )),
                  );
                }
              }

              return NewsScreenLoading(
                crossAxisCount: 2,
              );
            }));
  }
}
