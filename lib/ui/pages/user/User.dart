import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/user/MenuButton.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
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
  // late ScrollController scrollController;

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
    double iconSize = 10.w;
    if (Device.orientation == Orientation.landscape) {
      iconSize = 6.h;
    }

    return Expanded(
      child: SingleChildScrollView(
          child: Stack(children: [
        //SizedBox(height: 8),
        Align(
          alignment: Alignment.topCenter,
          child: BlocProvider<FeedBloc>(
              create: (context) => FeedBloc(repository: FeedRepositoryImpl())
                ..add(FetchUserFeedEvent(username: user.name)),
              child: FeedList(
                feedType: 'UserFeed',
                username: user.name,
                showAuthor: false,
                largeFormat: false,
                heightPerEntry: 18.h,
                width: 125.w,
                topPaddingForFirstEntry:
                    Device.orientation == Orientation.landscape ? 38.h : 42.h,
                sidepadding: 5.w,
                bottompadding: widget.ownUserpage ? 10.h : 0.h,
                scrollCallback: (bool) {},
                enableNavigation: true,
              )),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            height: 35.h,
            width: 200.w,
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

        Container(
          width: 130.w,
          height: 30.h,
          child: user.jsonString != null &&
                  user.jsonString!.profile != null &&
                  user.jsonString!.profile!.coverImage != null
              ? CachedNetworkImage(
                  imageUrl: user.jsonString!.profile!.coverImage!,
                  fit: BoxFit.fill,
                )
              : Container(color: globalBlueShades[2]),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            height: 35.h,
            width: 200.w,
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
          padding: EdgeInsets.only(top: 9.h, left: 5.w),
          child: FadeIn(
            preferences:
                AnimationPreferences(offset: Duration(milliseconds: 1100)),
            child: Container(
              width: 70.w,
              height: 21.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  ),
                  user.jsonString != null &&
                          user.jsonString!.additionals != null &&
                          user.jsonString!.additionals!.displayName != null
                      ? OverlayText(
                          text: '@' + user.name,
                          sizeMultiply: 1.3,
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox(height: 0),
                  user.jsonString != null &&
                          user.jsonString!.profile != null &&
                          user.jsonString!.profile!.about != null
                      ? OverlayText(
                          text: user.jsonString!.profile!.about!,
                          sizeMultiply: 1.1,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox(height: 0),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 12.h, right: 5.w),
            child: FadeIn(
              preferences:
                  AnimationPreferences(offset: Duration(milliseconds: 1100)),
              child: Container(
                width: 40.w,
                height: 21.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    user.jsonString != null &&
                            user.jsonString!.profile != null &&
                            user.jsonString!.profile!.location != null
                        ? OverlayText(
                            text:
                                'from: ' + user.jsonString!.profile!.location!,
                            sizeMultiply: 1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : SizedBox(height: 0),
                    // user.jsonString!.profile != null &&
                    //         user.jsonString!.profile!.website != null
                    //     ? OpenableHyperlink(
                    //         url: user.jsonString!.profile!.website!,
                    //       )
                    //     : SizedBox(height: 0)
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 19.h, right: 4.w),
            child: FadeIn(
              preferences:
                  AnimationPreferences(offset: Duration(milliseconds: 1100)),
              child: AccountAvatarBase(
                username: user.name,
                avatarSize: 38.w,
                showVerified: true,
                showName: false,
                width: 40.w,
                height: 40.w,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 15.h,
          right: 3.w,
          child: FadeIn(
              preferences: AnimationPreferences(
                  offset: Duration(milliseconds: 1000),
                  duration: Duration(seconds: 1)),
              child: buildUserMenuSpeedDial(
                  context, user, widget.ownUserpage, userBloc)),
        )
      ])),
    );
  }
}
