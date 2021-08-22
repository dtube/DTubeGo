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
                    // Container(
                    //   width: deviceWidth * 0.5,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       user.jsonString?.additionals?.displayName != null
                    //           ? OverlayText(
                    //               text: user
                    //                   .jsonString!.additionals!.displayName!,
                    //               maxLines: 2,
                    //               overflow: TextOverflow.ellipsis,
                    //               sizeMultiply: 1.4,
                    //             )
                    //           : SizedBox(
                    //               height: 0,
                    //             ),
                    //       OverlayText(
                    //         text: user.jsonString?.additionals?.displayName !=
                    //                 null
                    //             ? '(@' + user.name + ')'
                    //             : user.name,
                    //         maxLines: 2,
                    //         overflow: TextOverflow.ellipsis,
                    //         sizeMultiply:
                    //             user.jsonString?.additionals?.displayName !=
                    //                     null
                    //                 ? 1
                    //                 : 1.8,
                    //       ),
                    //       user.jsonString?.profile?.location != null
                    //           ? OverlayText(
                    //               text: user.jsonString!.profile!.location!,
                    //               maxLines: 2,
                    //               overflow: TextOverflow.ellipsis,
                    //               sizeMultiply: 0.8,
                    //               // style:
                    //               //     Theme.of(context).textTheme.bodyText2,
                    //             )
                    //           : SizedBox(
                    //               height: 0,
                    //             ),
                    //       user.jsonString?.profile?.about != null
                    //           ? OverlayText(
                    //               text: user.jsonString!.profile!.about!,
                    //               maxLines: 2,
                    //               overflow: TextOverflow.ellipsis,
                    //               // style:
                    //               //     Theme.of(context).textTheme.bodyText2,
                    //             )
                    //           : SizedBox(
                    //               height: 0,
                    //             ),
                    //       user.jsonString?.profile?.website != null
                    //           ? OpenableHyperlink(
                    //               url: user.jsonString!.profile!.website!,
                    //             )
                    //           : SizedBox(
                    //               height: 0,
                    //             ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(width: 8),
                    Center(
                      child: AccountAvatarBase(
                        username: user.name,
                        avatarSize: 90,
                        showVerified: true,
                        showName: true,
                        showNameLeft: true,
                        showFullUserInfo: true,
                        nameFontSizeMultiply: 1.4,
                        width: deviceWidth * 0.8,
                      ),
                    ),
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
                                ],
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
                          SizedBox(height: 24),
                          GestureDetector(
                            child: DecoratedIcon(
                              user.alreadyFollowing
                                  ? FontAwesomeIcons.usersSlash
                                  : FontAwesomeIcons.userFriends,
                              size: 25,
                              shadows: [
                                BoxShadow(
                                  blurRadius: 24.0,
                                  color: Colors.black,
                                ),
                              ],
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
                              child: DecoratedIcon(
                                FontAwesomeIcons.cogs,
                                size: 25,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 24.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ProfileSettingsContainer();
                                }));
                              }),
                          SizedBox(height: 24),
                          GestureDetector(
                              child: DecoratedIcon(
                                FontAwesomeIcons.history,
                                size: 25,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 24.0,
                                    color: Colors.black,
                                  ),
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
                                ],
                              ),
                              onTap: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(SignOutEvent(context: context));
                              }),
                        ],
                      ),
              ),
            ]))),
      ],
    );
  }
}
