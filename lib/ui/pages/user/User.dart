import 'dart:async';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:dtube_togo/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_togo/bloc/auth/auth_bloc.dart';
import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/style/OpenableHyperlink.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/accountHistory/AccountHistory.dart';
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

import '../feeds/FeedList.dart';

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
          child: BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionError) {
                showCustomFlushbarOnError(state.message, context);
              }
              if (state is TransactionSent) {
                showCustomFlushbarOnSuccess(state, context);
                BlocProvider.of<UserBloc>(context)
                    .add(FetchAccountDataEvent(username: widget.username!));
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Stack(children: [
              SizedBox(height: 8),
              BlocProvider<FeedBloc>(
                  create: (context) =>
                      FeedBloc(repository: FeedRepositoryImpl())
                        ..add(FetchUserFeedEvent(username: user.name)),
                  child: FeedList(
                    feedType: 'UserFeed',
                    username: user.name,
                    showAuthor: false,
                    bigThumbnail: false,
                    paddingTop: 0,
                    scrollCallback: (bool) {},
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 16.0),
                    //   child:
                    Container(
                      width: deviceWidth * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OverlayText(
                            text: user.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            sizeMultiply: 1.8,
                          ),
                          user.jsonString?.profile?.location != null
                              ? OverlayText(
                                  text: user.jsonString!.profile!.location!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  sizeMultiply: 0.8,
                                  // style:
                                  //     Theme.of(context).textTheme.bodyText2,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          user.jsonString?.profile?.about != null
                              ? OverlayText(
                                  text: user.jsonString!.profile!.about!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  // style:
                                  //     Theme.of(context).textTheme.bodyText2,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          user.jsonString?.profile?.website != null
                              ? OpenableHyperlink(
                                  url: user.jsonString!.profile!.website!,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    AccountAvatarBase(
                        username: user.name, size: 90, showVerified: true),
                  ],
                ),
              ),
              Positioned(
                bottom: 90,
                right: 8,
                child: !ownUsername
                    ? Column(
                        children: [
                          GestureDetector(
                              child: DecoratedIcon(
                                FontAwesomeIcons.history,
                                size: 25,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 24.0,
                                    color: Colors.black,
                                  ),
                                  // BoxShadow(
                                  //   blurRadius: 12.0,
                                  //   color: Colors.white,
                                  // ),
                                ],
                              ),
                              // foregroundColor: Colors.white,
                              // elevation: 0,
                              // backgroundColor: Colors.transparent,
                              // labelStyle: TextStyle(fontSize: 14.0),
                              // labelBackgroundColor: globalBlue,
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
                          SizedBox(height: 24),
                          GestureDetector(
                              child: DecoratedIcon(
                                FontAwesomeIcons.exchangeAlt,
                                size: 25,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 24.0,
                                    color: Colors.black,
                                  ),
                                  // BoxShadow(
                                  //   blurRadius: 12.0,
                                  //   color: Colors.white,
                                  // ),
                                ],
                              ),
                              // foregroundColor: Colors.white,
                              // elevation: 0,
                              // backgroundColor: Colors.transparent,
                              // labelStyle: TextStyle(fontSize: 14.0),
                              // labelBackgroundColor: globalBlue,
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
                          SizedBox(height: 24),
                          GestureDetector(
                            child:
                                // FaIcon(widget.alreadyFollowing
                                //     ? FontAwesomeIcons.usersSlash
                                //     : FontAwesomeIcons.userFriends),
                                // foregroundColor: globalAlmostWhite,
                                // backgroundColor: globalBlue,
                                // label: widget.alreadyFollowing ? 'Unfollow' : 'Follow',
                                // labelStyle: TextStyle(fontSize: 14.0),
                                // labelBackgroundColor: globalBlue,
                                DecoratedIcon(
                              user.alreadyFollowing
                                  ? FontAwesomeIcons.usersSlash
                                  : FontAwesomeIcons.userFriends,
                              size: 25,
                              shadows: [
                                BoxShadow(
                                  blurRadius: 24.0,
                                  color: Colors.black,
                                ),
                                // BoxShadow(
                                //   blurRadius: 12.0,
                                //   color: Colors.white,
                                // ),
                              ],
                            ),
                            // foregroundColor: Colors.white,
                            // elevation: 0,
                            // backgroundColor: Colors.transparent,
                            // labelStyle: TextStyle(fontSize: 14.0),
                            // labelBackgroundColor: globalBlue,
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
                              child: DecoratedIcon(
                                FontAwesomeIcons.history,
                                size: 25,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 24.0,
                                    color: Colors.black,
                                  ),
                                  // BoxShadow(
                                  //   blurRadius: 12.0,
                                  //   color: Colors.white,
                                  // ),
                                ],
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
                          SizedBox(height: 24),
                          GestureDetector(
                              child: DecoratedIcon(
                                FontAwesomeIcons.signOutAlt,
                                size: 25,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 24.0,
                                    color: Colors.black,
                                  ),
                                  // BoxShadow(
                                  //   blurRadius: 12.0,
                                  //   color: Colors.white,
                                  // ),
                                ],
                              ),
                              onTap: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(SignOutEvent(context: context));
                                // navigate to new wallet page
                              }),
                        ],
                      ),
              ),
            ]))),
        // Positioned(
        //     bottom: 50,
        //     right: 25,
        //     child: UserSpeedDial(
        //         ownUser: ownUsername,
        //         alreadyFollowing: user.alreadyFollowing,
        //         username: user.name)),
      ],
    );
  }
}

class UserSpeedDial extends StatefulWidget {
  UserSpeedDial(
      {Key? key,
      required this.alreadyFollowing,
      required this.ownUser,
      required this.username})
      : super(key: key);
  bool alreadyFollowing;
  String username;
  bool ownUser;

  @override
  User_SpeedDialState createState() => User_SpeedDialState();
}

class User_SpeedDialState extends State<UserSpeedDial> {
  UserBloc _userBloc = UserBloc(repository: UserRepositoryImpl());
  AuthBloc _authBloc = AuthBloc(repository: AuthRepositoryImpl());
  TransactionBloc _txBloc =
      TransactionBloc(repository: TransactionRepositoryImpl());
  List<SpeedDialChild> othersPageOptions = [];
  List<SpeedDialChild> myPageOptions = [];

  @override
  void initState() {
    super.initState();
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    TransactionBloc _txBloc = BlocProvider.of<TransactionBloc>(context);
    othersPageOptions = [
      SpeedDialChild(
          child: DecoratedIcon(
            FontAwesomeIcons.history,
            shadows: [
              BoxShadow(
                blurRadius: 24.0,
                color: Colors.black,
              ),
              // BoxShadow(
              //   blurRadius: 12.0,
              //   color: Colors.white,
              // ),
            ],
          ),
          foregroundColor: Colors.white,
          elevation: 0,
          backgroundColor: Colors.transparent,
          labelStyle: TextStyle(fontSize: 14.0),
          labelBackgroundColor: globalBlue,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider<AccountHistoryBloc>(
                  create: (context) => AccountHistoryBloc(
                      repository: AccountHistoryRepositoryImpl()),
                  child: AccountHistoryScreen(
                    username: widget.username,
                  ));
            }));
          }),
      SpeedDialChild(
          child: DecoratedIcon(
            FontAwesomeIcons.exchangeAlt,
            shadows: [
              BoxShadow(
                blurRadius: 24.0,
                color: Colors.black,
              ),
              // BoxShadow(
              //   blurRadius: 12.0,
              //   color: Colors.white,
              // ),
            ],
          ),
          foregroundColor: Colors.white,
          elevation: 0,
          backgroundColor: Colors.transparent,
          labelStyle: TextStyle(fontSize: 14.0),
          labelBackgroundColor: globalBlue,
          onTap: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => TransferDialog(
                      receiver: widget.username,
                      txBloc: _txBloc,
                    ));
          }),
      SpeedDialChild(
        child:
            // FaIcon(widget.alreadyFollowing
            //     ? FontAwesomeIcons.usersSlash
            //     : FontAwesomeIcons.userFriends),
            // foregroundColor: globalAlmostWhite,
            // backgroundColor: globalBlue,
            // label: widget.alreadyFollowing ? 'Unfollow' : 'Follow',
            // labelStyle: TextStyle(fontSize: 14.0),
            // labelBackgroundColor: globalBlue,
            DecoratedIcon(
          widget.alreadyFollowing
              ? FontAwesomeIcons.usersSlash
              : FontAwesomeIcons.userFriends,
          shadows: [
            BoxShadow(
              blurRadius: 24.0,
              color: Colors.black,
            ),
            // BoxShadow(
            //   blurRadius: 12.0,
            //   color: Colors.white,
            // ),
          ],
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        labelStyle: TextStyle(fontSize: 14.0),
        labelBackgroundColor: globalBlue,
        onTap: () async {
          TxData txdata = TxData(
            target: widget.username,
          );
          Transaction newTx =
              Transaction(type: widget.alreadyFollowing ? 8 : 7, data: txdata);
          _txBloc.add(SignAndSendTransactionEvent(newTx));
          _userBloc.add(FetchAccountDataEvent(username: widget.username));
        },
      ),
    ];

    myPageOptions = [
      SpeedDialChild(
          child: FaIcon(FontAwesomeIcons.history),
          foregroundColor: globalAlmostWhite,
          backgroundColor: globalBlue,
          label: 'History',
          labelStyle: TextStyle(fontSize: 14.0),
          labelBackgroundColor: globalBlue,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider<AccountHistoryBloc>(
                  create: (context) => AccountHistoryBloc(
                      repository: AccountHistoryRepositoryImpl()),
                  child: AccountHistoryScreen(
                    username: widget.username,
                  ));
            }));
          }),
      SpeedDialChild(
          child: FaIcon(FontAwesomeIcons.signOutAlt),
          foregroundColor: globalAlmostWhite,
          backgroundColor: globalBlue,
          label: 'Logout',
          labelStyle: TextStyle(fontSize: 14.0),
          labelBackgroundColor: globalBlue,
          onTap: () {
            _authBloc.add(SignOutEvent(context: context));
            // navigate to new wallet page
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        icon: FontAwesomeIcons.bars,
        activeIcon: FontAwesomeIcons.chevronLeft,
        buttonSize: 56.0,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: globalAlmostWhite,
        renderOverlay: false,
        overlayOpacity: 0,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'heroTagUser',
        backgroundColor: globalBlue,
        foregroundColor: globalAlmostWhite,
        elevation: 8.0,
        shape: CircleBorder(),
        gradientBoxShape: BoxShape.circle,
        children: widget.ownUser ? myPageOptions : othersPageOptions);
  }
}
