import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedList.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedListCarousel.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedListSuggested.dart';
import 'package:dtube_go/ui/pages/user/Widgets/MenuButton.dart';
import 'package:dtube_go/ui/pages/user/Widgets/TopBarCustomClipper.dart';
import 'package:dtube_go/ui/pages/user/Widgets/TopBarCustomPainter.dart';
import 'package:dtube_go/ui/pages/user/Widgets/UsersBlockButton.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserList.dart';
import 'package:dtube_go/ui/pages/user/Widgets/UsersMoreInfoButton.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/ui/widgets/Suggestions/SuggestedChannels.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:flutter/rendering.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPageTablet extends StatefulWidget {
  final String? username;
  final bool ownUserpage;
  bool? alreadyFollowing;
  final VoidCallback? onPop;
  @override
  _UserPageTabletState createState() => _UserPageTabletState();

  UserPageTablet(
      {Key? key, this.username, required this.ownUserpage, this.onPop})
      : super(key: key);
}

class _UserPageTabletState extends State<UserPageTablet> {
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();

    userBloc = BlocProvider.of<UserBloc>(context);
    if (widget.ownUserpage) {
      userBloc.add(FetchMyAccountDataEvent());
    } else {
      userBloc.add(FetchAccountDataEvent(username: widget.username!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        if (widget.onPop != null) {
          widget.onPop!();
        }

        return true;
      },
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: widget.ownUserpage
            ? null
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 28,
              ),
        body: Container(
          child: BlocListener<UserBloc, UserState>(
            bloc: userBloc,
            listener: (context, state) {
              if (state is UserErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            child: BlocBuilder<UserBloc, UserState>(
              bloc: userBloc,
              builder: (context, state) {
                if (state is UserInitialState) {
                  return buildLoading();
                } else if (state is UserLoadingState) {
                  return buildLoading();
                } else if (state is UserLoadedState) {
                  return buildUserPage(state.user, widget.ownUserpage);
                } else if (state is UserErrorState) {
                  return buildErrorUi(state.message);
                } else {
                  return buildErrorUi('test');
                }
              },
            ),
          ),
        ),
        //),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: SizedBox(height: 0, width: 0),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildUserPage(User user, bool ownUsername) {
    double _headerHight = 200;
    ScrollController _scrollControllerMoments = new ScrollController();
    ScrollController _scrollControllerPosts = new ScrollController();
    return
        // Expanded(
        //   child:

        Stack(
      children: [
        SingleChildScrollView(
            child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Uploads",
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  BlocProvider<FeedBloc>(
                    create: (context) =>
                        FeedBloc(repository: FeedRepositoryImpl())
                          ..add(FetchUserFeedEvent(username: user.name)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50.h,
                        child: FeedList(
                          desktopCrossAxisCount: 4,
                          tabletCrossAxisCount: 2,
                          feedType: 'UserFeed',
                          username: user.name,
                          showAuthor: false,
                          largeFormat: false,
                          heightPerEntry: 30.h,
                          width: 80.w,
                          topPaddingForFirstEntry: 0,
                          sidepadding: 5.w,
                          bottompadding: 0.h,
                          scrollCallback: (bool) {},
                          enableNavigation: true,
                          showBorder: true,
                          disablePlayback: true,
                          hideSpeedDial: true,
                          // header: "Regular Uploads"
                        ),
                      ),
                    ),
                  ),
                  BlocProvider<FeedBloc>(
                      create: (context) =>
                          FeedBloc(repository: FeedRepositoryImpl())
                            ..add(FetchMomentsOfUserEvent(
                                feedType: "NewUserMoments",
                                username: user.name)),
                      child: BlocBuilder<FeedBloc, FeedState>(
                          builder: (context, state) {
                        if (state is FeedLoadedState) {
                          if (state.feed.length == 0) {
                            return Container(
                              width: 0,
                              height: 0,
                            );
                          } else {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Moments",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.h,
                                    child: FeedList(
                                      desktopCrossAxisCount: 4,
                                      tabletCrossAxisCount: 2,
                                      feedType: 'NewUserMoments',
                                      username: user.name,
                                      showAuthor: false,
                                      largeFormat: false,
                                      heightPerEntry: 30.h,
                                      width: 80.w,
                                      topPaddingForFirstEntry: 0,
                                      sidepadding: 5.w,
                                      bottompadding: 0.h,
                                      scrollCallback: (bool) {},
                                      enableNavigation: true,
                                      showBorder: true,
                                      disablePlayback: true,
                                      hideSpeedDial: true,
                                      //header: "Moments"
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }

                        return DtubeLogoPulseWithSubtitle(
                            subtitle: "loading moments..", size: 10.w);
                      })),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocProvider<FeedBloc>(
                        create: (context) =>
                            FeedBloc(repository: FeedRepositoryImpl())
                              ..add(FetchSuggestedUsersForUserHistory(
                                  username: user.name)),
                        child: SuggestedChannels(
                          avatarSize: 80,
                          crossAxisCount: 4,
                        ),
                      ),
                      user.followers != null
                          ? UserList(
                              userlist: user.followers!,
                              crossAxisCount: 4,
                              title: "Followers",
                              avatarSize: 80,
                              showCount: true,
                            )
                          : SizedBox(height: 0),
                      user.follows != null
                          ? UserList(
                              crossAxisCount: 4,
                              userlist: user.follows!,
                              title: "Following",
                              avatarSize: 80,
                              showCount: true,
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 10.h)
                    ],
                  ),
                  Container(height: 100)
                ],
              )),
            ),
          ),
          user.jsonString != null &&
                  user.jsonString!.profile != null &&
                  user.jsonString!.profile!.coverImage != null &&
                  user.jsonString!.profile!.coverImage != ""
              ? ClipPath(
                  clipper: TopBarCustomClipper(),
                  child: Align(
                      alignment: Alignment.center,
                      // heightFactor: 5,
                      // // widthFactor: 0.5,
                      child: CachedNetworkImage(
                        imageUrl: user.jsonString!.profile!.coverImage!
                            .replaceAll("http:", "https:"),
                        imageBuilder: (context, imageProvider) => Container(
                          height: _headerHight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          height: _headerHight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/appicon.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: _headerHight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/appicon.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      )),
                )
              : CustomPaint(
                  painter: TopBarCustomPainter(),
                ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.only(top: 0, left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      globals.disableAnimations
                          ? Container(
                              height: 150,
                              width: 150,
                              child: AccountIconBase(
                                avatarSize: 150,
                                showVerified: true,
                                username: user.name,
                                showBorder: true,
                              ),
                            )
                          : FadeIn(
                              preferences: AnimationPreferences(
                                  offset: Duration(milliseconds: 500)),
                              child: Container(
                                  height: 150,
                                  width: 150,
                                  child: AccountIconBase(
                                    avatarSize: 150,
                                    showVerified: true,
                                    username: user.name,
                                    showBorder: true,
                                  ))),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: globals.disableAnimations
                            ? AccountNameBase(
                                username: user.name,
                                width: 300,
                                height: 200,
                                mainStyle: user.name.length > 10
                                    ? Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 30)
                                    : Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 40),
                                subStyle:
                                    Theme.of(context).textTheme.headline1!,
                                withShadow: true,
                              )
                            : FadeIn(
                                preferences: AnimationPreferences(
                                    offset: Duration(milliseconds: 1100)),
                                child: AccountNameBase(
                                  username: user.name,
                                  width: 300,
                                  height: 200,
                                  mainStyle: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(fontSize: 50),
                                  subStyle:
                                      Theme.of(context).textTheme.headline1!,
                                  withShadow: true,
                                )),
                      ),
                    ]),
                    Container(
                      height: _headerHight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          !widget.ownUserpage
                              ? BlocProvider(
                                  create: (context) => UserBloc(
                                      repository: UserRepositoryImpl()),
                                  child: UserBlockButton(
                                    user: user,
                                  ),
                                )
                              : Container(),
                          UserMoreInfoButton(
                              context: context, user: user, size: 50),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ])),
        Positioned(
          bottom: 50,
          right: 50,
          child: globals.disableAnimations
              ? buildUserMenuSpeedDial(
                  context, user, widget.ownUserpage, userBloc)
              : FadeIn(
                  preferences: AnimationPreferences(
                      offset: Duration(milliseconds: 1000),
                      duration: Duration(seconds: 1)),
                  child: buildUserMenuSpeedDial(
                      context, user, widget.ownUserpage, userBloc)),
        ),
      ],
      //   ),
    );
  }
}

class NameDisplayNameContainer extends StatelessWidget {
  const NameDisplayNameContainer(
      {Key? key,
      required this.context,
      required this.user,
      required this.ownUserpage})
      : super(key: key);

  final BuildContext context;
  final User user;
  final bool ownUserpage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 45.w,
          height: 20.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OverlayText(
                text: user.jsonString != null &&
                        user.jsonString!.additionals != null &&
                        user.jsonString!.additionals!.displayName != null
                    ? user.jsonString!.additionals!.displayName!
                    : user.name,
                sizeMultiply: 1.6,
                bold: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              OverlayText(
                text: user.jsonString != null &&
                        user.jsonString!.additionals != null &&
                        user.jsonString!.additionals!.displayName != null
                    ? '@' + user.name
                    : "",
                sizeMultiply: 1.2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            !ownUserpage
                ? BlocProvider(
                    create: (context) =>
                        UserBloc(repository: UserRepositoryImpl()),
                    child: UserBlockButton(
                      user: user,
                    ),
                  )
                : Container(),
            UserMoreInfoButton(
              context: context,
              user: user,
            ),
          ],
        )
      ],
    );
  }
}
