import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedListCarousel.dart';
import 'package:dtube_go/ui/pages/user/MenuButton.dart';
import 'package:dtube_go/ui/pages/user/TopBarCustomClipper.dart';
import 'package:dtube_go/ui/pages/user/TopBarCustomPainter.dart';
import 'package:dtube_go/ui/pages/user/Widgets/UsersBlockButton.dart';
import 'package:dtube_go/ui/widgets/Suggestions/OtherUsersAvatar.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserList.dart';
import 'package:dtube_go/ui/pages/user/Widgets/UsersMoreInfoButton.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/ui/widgets/Suggestions/SuggestedChannels.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:dtube_go/utils/shortBalanceStrings.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_go/bloc/auth/auth_bloc.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/pages/accountHistory/AccountHistory.dart';
import 'package:dtube_go/ui/pages/user/ProfileSettings.dart';
import 'package:dtube_go/ui/pages/wallet/transferDialog.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:flutter/rendering.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feeds/lists/FeedList.dart';

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

  Widget buildUserPage(User user, bool ownUsername) {
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
                        header: "Fresh Uploads"),
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
                        header: "Fresh Moments"),
                  ),
                  BlocProvider<FeedBloc>(
                    create: (context) =>
                        FeedBloc(repository: FeedRepositoryImpl())
                          ..add(FetchSuggestedUsersForUserHistory(
                              username: user.name)),
                    child: SuggestedChannels(),
                  ),
                  user.followers != null
                      ? UserList(
                          userlist: user.followers!,
                          title: "Followers",
                          showCount: true,
                        )
                      : SizedBox(height: 0),
                  user.follows != null
                      ? UserList(
                          userlist: user.follows!,
                          title: "Following",
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
                  color: Colors.white,
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
                  color: Colors.white,
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        user.jsonString != null &&
                                user.jsonString!.additionals != null &&
                                user.jsonString!.additionals!.displayName !=
                                    null
                            ? OverlayText(
                                text: '@' + user.name,
                                sizeMultiply: 1.2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : SizedBox(height: 0),
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
                child: AccountAvatarBase(
                  username: user.name,
                  avatarSize: 30.w,
                  showVerified: true,
                  showName: false,
                  width: 32.w,
                  height: 32.w,
                ),
              ),
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
