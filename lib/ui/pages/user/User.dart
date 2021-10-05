import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_go/bloc/auth/auth_bloc.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/style/styledCustomWidgets.dart';
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
    double iconSize = 8.w;
    if (Device.orientation == Orientation.landscape) {
      iconSize = 6.h;
    }

    return Stack(
      children: [
        SingleChildScrollView(
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
                width: 95.w,
                topPaddingForFirstEntry:
                    Device.orientation == Orientation.landscape ? 38.h : 30.h,
                sidepadding: 10.w,
                bottompadding: 10.h,
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
                    avatarSize: Device.orientation == Orientation.portrait
                        ? 18.h
                        : 25.h,
                    showVerified: true,
                    showName: true,
                    showNameLeft: true,
                    showFullUserInfo: true,
                    nameFontSizeMultiply: 1.4,
                    width: Device.orientation == Orientation.portrait
                        ? 95.w
                        : 70.w,
                    height: Device.orientation == Orientation.portrait
                        ? 18.h
                        : 25.h,
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
                                      txBloc: BlocProvider.of<TransactionBloc>(
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
                              return BlocProvider<ThirdPartyUploaderBloc>(
                                  create: (BuildContext context) =>
                                      ThirdPartyUploaderBloc(
                                          repository:
                                              ThirdPartyUploaderRepositoryImpl()),
                                  child: ProfileSettingsContainer(
                                      userBloc: userBloc));
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
      ],
    );
  }
}
