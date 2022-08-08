import 'package:dtube_go/utils/globalVariables.dart' as globals;

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

class UserPage extends StatefulWidget {
  String? username;
  bool ownUserpage;
  bool? alreadyFollowing;
  VoidCallback? onPop;
  @override
  _UserState createState() => _UserState();

  UserPage({Key? key, this.username, required this.ownUserpage, this.onPop})
      : super(key: key);
}

class _UserState extends State<UserPage> {
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
                  return kIsWeb
                      ? buildUserPageWeb(state.user, widget.ownUserpage)
                      : buildUserPageMobile(state.user, widget.ownUserpage);
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
      //child: CircularProgressIndicator(),
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

  Widget buildUserPageMobile(User user, bool ownUsername) {
    return
        // Expanded(
        //   child:

        Stack(
      children: [
        SingleChildScrollView(
            child: Stack(children: [
          //SizedBox(height: 8),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 26.h),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  BlocProvider<FeedBloc>(
                    create: (context) =>
                        FeedBloc(repository: FeedRepositoryImpl())
                          ..add(FetchUserFeedEvent(username: user.name)),
                    child: FeedListCarousel(
                        feedType: 'UserFeed',
                        username: user.name,
                        showAuthor: false,
                        largeFormat: false,
                        heightPerEntry: 30.h,
                        width: 150.w,
                        topPaddingForFirstEntry: 0,
                        sidepadding: 5.w,
                        bottompadding: 0.h,
                        scrollCallback: (bool) {},
                        enableNavigation: true,
                        header: "Regular Uploads"),
                  ),
                  BlocProvider<FeedBloc>(
                    create: (context) =>
                        FeedBloc(repository: FeedRepositoryImpl())
                          ..add(FetchMomentsOfUserEvent(
                              feedType: "NewUserMoments", username: user.name)),
                    child: FeedListCarousel(
                        feedType: 'NewUserMoments',
                        username: user.name,
                        showAuthor: false,
                        largeFormat: false,
                        heightPerEntry: 30.h,
                        width: 150.w,
                        topPaddingForFirstEntry: 0,
                        sidepadding: 5.w,
                        bottompadding: 0.h,
                        scrollCallback: (bool) {},
                        enableNavigation: true,
                        header: "Moments"),
                  ),
                  BlocProvider<FeedBloc>(
                    create: (context) =>
                        FeedBloc(repository: FeedRepositoryImpl())
                          ..add(FetchSuggestedUsersForUserHistory(
                              username: user.name)),
                    child: SuggestedChannels(avatarSize: 18.w),
                  ),
                  user.followers != null
                      ? UserList(
                          userlist: user.followers!,
                          title: "Followers",
                          avatarSize: 18.w,
                          showCount: true,
                        )
                      : SizedBox(height: 0),
                  user.follows != null
                      ? UserList(
                          userlist: user.follows!,
                          title: "Following",
                          avatarSize: 18.w,
                          showCount: true,
                        )
                      : SizedBox(height: 0),
                  SizedBox(height: 10.h)
                ],
              )),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 15.h,
              width: 100.w,
              decoration: BoxDecoration(
                  color: globalAlmostWhite,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.0),
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
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
                      child: Container(
                        height: 25.h,
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(
                            user.jsonString!.profile!.coverImage!,
                            //  fit: BoxFit.fitWidth,
                            // fit: BoxFit.fitHeight,
                          ),
                        ),
                      )),
                )
              : CustomPaint(
                  painter: TopBarCustomPainter(),
                ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 35.h,
              width: 100.w,
              decoration: BoxDecoration(
                  color: globalAlmostWhite,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.0),
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 5.h, left: 40.w),
            child: globals.disableAnimations
                ? NameDisplayNameContainer(
                    context: context,
                    ownUserpage: widget.ownUserpage,
                    user: user,
                  )
                : FadeIn(
                    preferences: AnimationPreferences(
                        offset: Duration(milliseconds: 1100)),
                    child: NameDisplayNameContainer(
                      context: context,
                      ownUserpage: widget.ownUserpage,
                      user: user,
                    ),
                  ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 7.h, left: 4.w),
              child: globals.disableAnimations
                  ? Container(
                      height: 31.w,
                      width: 31.w,
                      child: AccountIconBase(
                        avatarSize: 30.w,
                        showVerified: true,
                        username: user.name,
                        showBorder: true,
                      ),
                    )
                  : FadeIn(
                      preferences: AnimationPreferences(
                          offset: Duration(milliseconds: 500)),
                      child: Container(
                          height: 31.w,
                          width: 31.w,
                          child: AccountIconBase(
                            avatarSize: 30.w,
                            showVerified: true,
                            username: user.name,
                            showBorder: true,
                          ))),
            ),
          ),
        ])),
        Positioned(
          bottom: 10.h,
          right: 3.w,
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

  Widget buildUserPageWeb(User user, bool ownUsername) {
    return
        // Expanded(
        //   child:

        Stack(
      children: [
        SingleChildScrollView(
            child: Stack(children: [
          //SizedBox(height: 8),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 28.h),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  BlocProvider<FeedBloc>(
                    create: (context) =>
                        FeedBloc(repository: FeedRepositoryImpl())
                          ..add(FetchUserFeedEvent(username: user.name)),
                    child: FeedListSuggested(
                      feedType: 'UserFeed',
                      username: user.name,
                      showAuthor: false,
                      largeFormat: false,
                      heightPerEntry: 30.h,
                      width: 50.w,
                      sidepadding: 5.w,
                      scrollCallback: (bool) {},
                      enableNavigation: true,
                      // header: "Fresh Uploads"
                    ),
                  ),
                  BlocProvider<FeedBloc>(
                    create: (context) =>
                        FeedBloc(repository: FeedRepositoryImpl())
                          ..add(FetchMomentsOfUserEvent(
                              feedType: "NewUserMoments", username: user.name)),
                    child: FeedListSuggested(
                      feedType: 'NewUserMoments',
                      username: user.name,
                      showAuthor: false,
                      largeFormat: false,
                      heightPerEntry: 30.h,
                      width: 50.w,
                      sidepadding: 5.w,
                      scrollCallback: (bool) {},
                      enableNavigation: true,
                      // header: "Fresh Moments"
                    ),
                  ),
                  BlocProvider<FeedBloc>(
                    create: (context) =>
                        FeedBloc(repository: FeedRepositoryImpl())
                          ..add(FetchSuggestedUsersForUserHistory(
                              username: user.name)),
                    child: SuggestedChannels(avatarSize: 5.w),
                  ),
                  user.followers != null
                      ? UserList(
                          userlist: user.followers!,
                          title: "Followers",
                          avatarSize: 5.w,
                          showCount: true,
                        )
                      : SizedBox(height: 0),
                  user.follows != null
                      ? UserList(
                          userlist: user.follows!,
                          title: "Following",
                          avatarSize: 5.w,
                          showCount: true,
                        )
                      : SizedBox(height: 0),
                  SizedBox(height: 10.h)
                ],
              )),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 15.h,
              width: 100.w,
              decoration: BoxDecoration(
                  color: globalAlmostWhite,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.0),
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
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
                      child: Container(
                        height: 25.h,
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(
                            user.jsonString!.profile!.coverImage!,
                            //  fit: BoxFit.fitWidth,
                            // fit: BoxFit.fitHeight,
                          ),
                        ),
                      )),
                )
              : CustomPaint(
                  painter: TopBarCustomPainter(),
                ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 35.h,
              width: 100.w,
              decoration: BoxDecoration(
                  color: globalAlmostWhite,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.0),
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h, left: 40.w),
            child: FadeIn(
              preferences:
                  AnimationPreferences(offset: Duration(milliseconds: 1100)),
              child: Row(
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
                                  user.jsonString!.additionals!.displayName !=
                                      null
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
                                  user.jsonString!.additionals!.displayName !=
                                      null
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
                      !widget.ownUserpage
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
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 7.h, left: 4.w),
              child: FadeIn(
                  preferences:
                      AnimationPreferences(offset: Duration(milliseconds: 500)),
                  child: AccountIconBase(
                    avatarSize: 15.w,
                    showVerified: true,
                    username: user.name,
                  )),
            ),
          ),
        ])),
        Positioned(
          bottom: 10.h,
          right: 3.w,
          child: FadeIn(
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
