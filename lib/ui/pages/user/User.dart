import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:async';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:dtube_togo/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_togo/bloc/auth/auth_bloc.dart';
import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/style/OpenableHyperlink.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/accountHistory/AccountHistory.dart';
import 'package:dtube_togo/ui/pages/user/ProfileSettings.dart';
import 'package:dtube_togo/ui/pages/wallet/transferDialog.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/ui/widgets/customSnackbar.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feeds/lists/FeedList.dart';

class UserPage extends StatefulWidget {
  String? username;
  bool ownUserpage;
  bool? alreadyFollowing;
  @override
  _UserState createState() => _UserState();

  UserPage({Key? key, this.username, required this.ownUserpage})
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
    return Scaffold(
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
    double iconSize = 5.w;
    if (Device.orientation == Orientation.landscape) {
      iconSize = 5.h;
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Stack(children: [
            //SizedBox(height: 8),
            BlocProvider<FeedBloc>(
                create: (context) => FeedBloc(repository: FeedRepositoryImpl())
                  ..add(FetchUserFeedEvent(username: user.name)),
                child: FeedList(
                  feedType: 'UserFeed',
                  username: user.name,
                  showAuthor: false,
                  largeFormat: false,
                  heightPerEntry: 10.h,
                  width: 80.w,
                  topPaddingForFirstEntry:
                      Device.orientation == Orientation.landscape ? 25.h : null,
                  scrollCallback: (bool) {},
                  enableNavigation: true,
                )),
            Padding(
              padding: EdgeInsets.only(top: 11.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: AccountAvatarBase(
                      username: user.name,
                      avatarSize: 17.h,
                      showVerified: true,
                      showName: true,
                      showNameLeft: true,
                      showFullUserInfo: true,
                      nameFontSizeMultiply: 1.4,
                      width: 95.w,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 45.h,
              right: 3.w,
              child: !ownUsername
                  ? Column(
                      children: [
                        GestureDetector(
                            child: ShadowedIcon(
                              icon: FontAwesomeIcons.history,
                              size: iconSize,
                              color: Colors.white,
                              shadowColor: Colors.black,
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlocProvider<AccountHistoryBloc>(
                                    create: (context) => AccountHistoryBloc(
                                        repository:
                                            AccountHistoryRepositoryImpl()),
                                    child: AccountHistoryScreen(
                                      username: user.name,
                                    ));
                              }));
                            }),
                        SizedBox(height: iconSize / 2),
                        GestureDetector(
                            child: ShadowedIcon(
                              icon: FontAwesomeIcons.exchangeAlt,
                              size: iconSize,
                              color: Colors.white,
                              shadowColor: Colors.black,
                            ),
                            onTap: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      TransferDialog(
                                        receiver: widget.username,
                                        txBloc:
                                            BlocProvider.of<TransactionBloc>(
                                                context),
                                      ));
                            }),
                        SizedBox(height: iconSize / 2),
                        GestureDetector(
                          child: ShadowedIcon(
                            icon: user.alreadyFollowing
                                ? FontAwesomeIcons.usersSlash
                                : FontAwesomeIcons.userFriends,
                            size: iconSize,
                            color: Colors.white,
                            shadowColor: Colors.black,
                          ),
                          onTap: () async {
                            TxData txdata = TxData(
                              target: widget.username,
                            );
                            Transaction newTx = Transaction(
                                type: user.alreadyFollowing ? 8 : 7,
                                data: txdata);
                            BlocProvider.of<TransactionBloc>(context)
                                .add(SignAndSendTransactionEvent(newTx));
                          },
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        GestureDetector(
                            child: ShadowedIcon(
                              icon: FontAwesomeIcons.cogs,
                              size: iconSize,
                              color: Colors.white,
                              shadowColor: Colors.black,
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProfileSettingsContainer();
                              }));
                            }),
                        SizedBox(height: 3.h),
                        GestureDetector(
                            child: ShadowedIcon(
                              icon: FontAwesomeIcons.history,
                              size: iconSize,
                              color: Colors.white,
                              shadowColor: Colors.black,
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlocProvider<AccountHistoryBloc>(
                                    create: (context) => AccountHistoryBloc(
                                        repository:
                                            AccountHistoryRepositoryImpl()),
                                    child: AccountHistoryScreen(
                                      username: widget.username,
                                    ));
                              }));
                            }),
                        SizedBox(height: iconSize / 2),
                        GestureDetector(
                            child: ShadowedIcon(
                              icon: FontAwesomeIcons.signOutAlt,
                              size: iconSize,
                              color: Colors.white,
                              shadowColor: Colors.black,
                            ),
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(SignOutEvent(context: context));
                            }),
                      ],
                    ),
            ),
          ])),
        ),
      ],
    );
  }
}
