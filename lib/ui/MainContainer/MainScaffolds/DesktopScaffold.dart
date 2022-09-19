import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/bloc/search/search_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/ui/MainContainer/Widgets/AboutDialog/AboutDialog.dart';
import 'package:dtube_go/ui/pages/News/NewsPage.dart';
import 'package:dtube_go/ui/pages/search/SearchScreen.dart';
import 'package:dtube_go/ui/pages/settings/HiveSignerForm.dart';
import 'package:dtube_go/ui/pages/settings/SettingsTabContainer.dart';
import 'package:dtube_go/ui/pages/Governance/GovernanceTabContainer.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/ui/pages/Explore/GenreBase/GenreBase.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/UploadPresetSelection.dart';
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
import 'package:url_launcher/url_launcher.dart';

class DesktopScaffold extends StatefulWidget {
  DesktopScaffold({Key? key}) : super(key: key);

  @override
  _DesktopScaffoldState createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  late List<Widget> _screens;
  late FeedBloc _newsFeedBloc = new FeedBloc(repository: FeedRepositoryImpl());
  bool exitNewsScreen = false;

  int bottomSelectedIndex = 0;
  int _currentIndex = 0;
  bool _firstTimeLogin = false;

  //
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void uploaderCallback() {
    setState(() {
      _currentIndex = 0;
    });
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
    return BlocBuilder<FeedBloc, FeedState>(
        bloc: _newsFeedBloc,
        builder: (context, state) {
          if (state is FeedLoadingState) {
            return NewsScreenLoading(crossAxisCount: 4);
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
                drawer: Drawer(
                  elevation: 1,
                  width: 200,
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: globalBGColor,
                        ),
                        child: Image.asset('assets/images/dtube_logo_white.png',
                            width: 30),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: globalIconSizeBig,
                            ),
                            Text('Search',
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                        onTap: () {
                          openSearchScreen(context);
                        },
                      ),
                      ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.alignJustify,
                                size: globalIconSizeBig,
                              ),
                              Text('Feed',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ]),
                        onTap: () {
                          openFeedPage();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.earthAfrica,
                                size: globalIconSizeBig,
                              ),
                              Text('Explore',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ]),
                        onTap: () {
                          openExplorePage();
                          Navigator.pop(context);
                        },
                      ),
                      globals.keyPermissions.isNotEmpty
                          ? ListTile(
                              title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    UploadButton(iconSize: globalIconSizeBig),
                                    Text(
                                      'Upload',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: !globals.keyPermissions
                                                      .contains(4)
                                                  ? Colors.grey
                                                  : globalAlmostWhite),
                                    ),
                                  ]),
                              onTap: () {
                                if (globals.keyPermissions.contains(4)) {
                                  openUploadPage(context);
                                }
                                Navigator.pop(context);
                              },
                            )
                          : Container(),
                      ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.podcast,
                                size: globalIconSizeBig,
                              ),
                              Text('Moments',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ]),
                        onTap: () {
                          openMomentsPage();
                          Navigator.pop(context);
                        },
                      ),
                      globals.keyPermissions.isNotEmpty
                          ? ListTile(
                              title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.hotel,
                                      size: globalIconSizeBig,
                                    ),
                                    Text('Governance',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ]),
                              onTap: () {
                                openGovernancePage(context);
                              },
                            )
                          : Container(),
                      ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.gears,
                                size: globalIconSizeBig,
                              ),
                              Text('Settings',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ]),
                        onTap: () {
                          openSettingsPage(context);
                        },
                      ),
                      globals.keyPermissions.isNotEmpty
                          ? ListTile(
                              title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AccountIconBase(
                                      avatarSize: globalIconSizeBig,
                                      showVerified: false,
                                      username: "you",
                                      showBorder: false,
                                    ),
                                    Text('Profile',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ]),
                              onTap: () {
                                openProfilePage(context);
                                Navigator.pop(context);
                              },
                            )
                          : Container(),
                      ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.question,
                                size: globalIconSizeBig,
                              ),
                              Text('About & FAQ',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ]),
                        onTap: () {
                          openAboutDialog(context);
                        },
                      ),
                      SizedBox(height: 100),
                      ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.android,
                                size: globalIconSizeBig,
                              ),
                              Text('App on Android',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ]),
                        onTap: () {
                          launchUrl(Uri.parse(
                              "https://github.com/dtube/DTubeGo/releases"));
                        },
                      ),
                      ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.apple,
                                size: globalIconSizeBig,
                              ),
                              Text('App on iOS',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ]),
                        onTap: () {
                          launchUrl(Uri.parse(
                              "https://testflight.apple.com/join/C1RKgxlM"));
                        },
                      ),
                    ],
                  ),
                ),
                appBar: AppBar(
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  //automaticallyImplyLeading: false,
                  elevation: 1,
                  titleSpacing: 0,

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      globals.keyPermissions.isNotEmpty
                          ? Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: InkWell(
                                    child: UploadButton(iconSize: 24),
                                    onTap: () {
                                      openUploadPage(context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: InkWell(
                                    child: FaIcon(
                                      FontAwesomeIcons.hotel,
                                      color: globalAlmostWhite,
                                    ),
                                    onTap: () {
                                      openGovernancePage(context);
                                    },
                                  ),
                                ),
                                globals.keyPermissions.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: InkWell(
                                          child: AccountIconBase(
                                            avatarSize: globalIconSizeBig,
                                            showVerified: false,
                                            username: "you",
                                            showBorder: false,
                                          ),
                                          onTap: () {
                                            openProfilePage(context);
                                          },
                                        ),
                                      )
                                    : Container()
                              ],
                            )
                          : SizedBox(
                              width: 0,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          globals.keyPermissions.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        BlocProvider.of<AuthBloc>(context).add(
                                            SignOutEvent(context: context));
                                        //do stuff
                                      },
                                      child: Text(
                                        "Join / Login",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
                                      child: NotificationButton(iconSize: 24),
                                    ),
                                  ],
                                ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: globalAlmostWhite,
                              ),
                              onPressed: () {
                                openSearchScreen(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
                            Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: IndexedStack(
                            children: _screens,
                            index: _currentIndex,
                          ),
                        )),
              );
            }
          }

          return NewsScreenLoading(crossAxisCount: 4);
        });
  }

  void openFeedPage() {
    _screens.removeAt(3);

    _screens.insert(
        3,
        MomentsPage(
          key: UniqueKey(),
          play: false,
        ));
    setState(() {
      _currentIndex = 0;
    });
  }

  void openExplorePage() {
    _screens.removeAt(3);

    _screens.insert(
        3,
        MomentsPage(
          key: UniqueKey(),
          play: false,
        ));

    setState(() {
      _currentIndex = 1;
    });
  }

  void openAboutDialog(BuildContext context) {
    _screens.removeAt(3);

    _screens.insert(
        3,
        MomentsPage(
          key: UniqueKey(),
          play: false,
        ));
    showDialog(
        context: context,
        builder: (context) {
          return AboutAppDialog();
        });
  }

  void openProfilePage(BuildContext context) {
    if (globals.keyPermissions.isEmpty) {
      showCustomFlushbarOnError(
          "you need to be signed in to access your profile", context);
    } else {
      _screens.removeAt(3);

      _screens.insert(
          3,
          MomentsPage(
            key: UniqueKey(),
            play: false,
          ));
      _screens.removeAt(4);
      _screens.insert(
        4,
        BlocProvider(
          create: (context) => UserBloc(repository: UserRepositoryImpl()),
          child: UserPage(
            ownUserpage: true,
            //key: UniqueKey(),
          ),
        ),
      );
      setState(() {
        _currentIndex = 4;
      });
    }
  }

  void openSettingsPage(BuildContext context) {
    _screens.removeAt(3);

    _screens.insert(
        3,
        MomentsPage(
          key: UniqueKey(),
          play: false,
        ));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(), child: SettingsTabContainer());
    }));
  }

  void openGovernancePage(BuildContext context) {
    if (globals.keyPermissions.isNotEmpty) {
      _screens.removeAt(3);

      _screens.insert(
          3,
          MomentsPage(
            key: UniqueKey(),
            play: false,
          ));
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return GovernanceMainPage();
      }));
    }
  }

  void openMomentsPage() {
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
    );
    setState(() {
      _currentIndex = 3;
    });
  }

  void openUploadPage(BuildContext context) {
    _screens.removeAt(3);

    _screens.insert(
        3,
        MomentsPage(
          key: UniqueKey(),
          play: false,
        ));
    if (globals.keyPermissions.contains(4)) {
      // if there is a current background upload running
      //  show snackbar and do not navigate to the upload screen
      if (BlocProvider.of<AppStateBloc>(context).state is UploadStartedState ||
          BlocProvider.of<AppStateBloc>(context).state
              is UploadProcessingState) {
        showCustomFlushbarOnError(
            "please wait until upload is finished", context);
      }
      // if the most recent background upload task is finished
      // reset UploadState and navigate to the upload screen
      if (BlocProvider.of<AppStateBloc>(context).state is UploadFinishedState ||
          BlocProvider.of<AppStateBloc>(context).state is UploadFailedState) {
        BlocProvider.of<AppStateBloc>(context)
            .add(UploadStateChangedEvent(uploadState: UploadInitialState()));
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
      }
      // if there is no background upload task running or recently finished
      if (BlocProvider.of<AppStateBloc>(context).state is UploadInitialState) {
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
      }
      setState(() {
        _currentIndex = 2;
      });
    } else {
      showCustomFlushbarOnError(
          "you need to be signed in to upload content", context);
    }
  }

  void openSearchScreen(BuildContext context) {
    _screens.removeAt(3);

    _screens.insert(
        3,
        MomentsPage(
          key: UniqueKey(),
          play: false,
        ));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(providers: [
        BlocProvider<SearchBloc>(
            create: (context) =>
                SearchBloc(repository: SearchRepositoryImpl())),
        BlocProvider(
            create: (context) => FeedBloc(repository: FeedRepositoryImpl())),
      ], child: SearchScreen());
    }));
  }
}

class UploadButton extends StatelessWidget {
  UploadButton({Key? key, required this.iconSize}) : super(key: key);

  double iconSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStateBloc, AppState>(builder: (context, state) {
      if (state is UploadStartedState) {
        return DTubeLogoPulseWave(size: globalIconSizeBig, progressPercent: 10);
      } else if (state is UploadProcessingState) {
        return DTubeLogoPulseWave(
            size: globalIconSizeBig, progressPercent: state.progressPercent);
      } else if (state is UploadFinishedState) {
        return Center(
          child: new BorderedIcon(
              icon: FontAwesomeIcons.check,
              color: Colors.green,
              borderColor: Colors.black,
              size: iconSize),
        );
      } else if (state is UploadFailedState) {
        return Center(
          child: new BorderedIcon(
            icon: FontAwesomeIcons.xmark,
            color: globalRed,
            borderColor: Colors.black,
            size: iconSize,
          ),
        );
      } else {
        return Center(
          child: new BorderedIcon(
            icon: FontAwesomeIcons.arrowUpFromBracket,
            color: globals.keyPermissions.contains(4)
                ? globalAlmostWhite
                : Colors.grey,
            borderColor: Colors.black,
            size: iconSize,
          ),
        );
      }
    });
  }
}
