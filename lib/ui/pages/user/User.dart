import 'package:dtube_togo/bloc/auth/auth_bloc.dart';
import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/ui/pages/wallet/transferDialog.dart';
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
  @override
  _UserState createState() => _UserState();

  UserPage({Key? key, this.username, required this.ownUserpage})
      : super(key: key);
}

class _UserState extends State<UserPage> {
  late ScrollController scrollController;
  bool dialVisible = true;
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
    userBloc = BlocProvider.of<UserBloc>(context);
    if (widget.ownUserpage) {
      userBloc.add(FetchMyAccountDataEvent());
    } else {
      userBloc.add(FetchAccountDataEvent(widget.username!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.ownUserpage
          ? null
          : AppBar(
              backgroundColor: globalAlmostBlack,
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
                showCustomFlushbarOnError(state, context);
              }
              if (state is TransactionSent) {
                showCustomFlushbarOnSuccess(state, context);
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
      child: CircularProgressIndicator(),
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
                child: Column(children: [
              SizedBox(height: ownUsername ? 90 : 0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.jsonString?.profile?.avatar != null
                      ? CachedNetworkImage(
                          imageUrl: user.jsonString!.profile!.avatar!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new FaIcon(FontAwesomeIcons.times),
                        )
                      : FaIcon(FontAwesomeIcons.times),
                  SizedBox(width: 10),
                  Container(
                    width: (deviceWidth - 50) / 3 * 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        user.jsonString?.profile?.location != null
                            ? Text(
                                user.jsonString!.profile!.location!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        user.jsonString?.profile?.about != null
                            ? Text(
                                user.jsonString!.profile!.about!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        user.jsonString?.profile?.website != null
                            ? Text(
                                user.jsonString!.profile!.website!,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  ))
            ]))),
        Positioned(
            bottom: 50,
            right: 25,
            child:
                buildSpeedDial(ownUsername, user.alreadyFollowing, user.name)),
      ],
    );
  }

  Widget buildSpeedDial(bool ownUser, bool alreadyFollowing, String username) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    TransactionBloc _txBloc = BlocProvider.of<TransactionBloc>(context);

    List<SpeedDialChild> othersPageOptions = [
      SpeedDialChild(
          child: FaIcon(FontAwesomeIcons.exchangeAlt),
          foregroundColor: globalAlmostWhite,
          backgroundColor: globalBlue,
          label: 'transfer',
          labelStyle: TextStyle(fontSize: 18.0),
          labelBackgroundColor: globalBlue,
          onTap: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => TransferDialog(
                      receiver: username,
                      txBloc: _txBloc,
                    ));
          }),
      SpeedDialChild(
        child: FaIcon(alreadyFollowing
            ? FontAwesomeIcons.usersSlash
            : FontAwesomeIcons.userFriends),
        foregroundColor: globalAlmostWhite,
        backgroundColor: globalBlue,
        label: alreadyFollowing ? 'Unfollow' : 'Follow',
        labelStyle: TextStyle(fontSize: 18.0),
        labelBackgroundColor: globalBlue,
        onTap: () async {
          TxData txdata = TxData(
            target: username,
          );
          Transaction newTx =
              Transaction(type: alreadyFollowing ? 8 : 7, data: txdata);
          _txBloc.add(SignAndSendTransactionEvent(newTx));
          _userBloc.add(FetchAccountDataEvent(widget.username!));
        },
      ),
    ];

    List<SpeedDialChild> myPageOptions = [
      SpeedDialChild(
          child: FaIcon(FontAwesomeIcons.history),
          foregroundColor: globalAlmostWhite,
          backgroundColor: globalBlue,
          label: 'History',
          labelStyle: TextStyle(fontSize: 14.0),
          labelBackgroundColor: globalBlue,
          onTap: () {
            // navigate to new history page
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

    return SpeedDial(
        icon: FontAwesomeIcons.bars,
        activeIcon: FontAwesomeIcons.chevronLeft,
        buttonSize: 56.0,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: globalAlmostWhite,
        overlayOpacity: 0,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: globalBlue,
        foregroundColor: globalAlmostWhite,
        elevation: 8.0,
        shape: CircleBorder(),
        gradientBoxShape: BoxShape.circle,
        children: ownUser ? myPageOptions : othersPageOptions);
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }
}
