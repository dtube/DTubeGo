import 'package:dtube_togo/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_togo/bloc/config/txTypes.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/navigationShortCuts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountHistoryScreen extends StatefulWidget {
  AccountHistoryScreen({Key? key, required this.username}) : super(key: key);
  String username;

  @override
  _AccountHistoryScreenState createState() => _AccountHistoryScreenState();
}

class _AccountHistoryScreenState extends State<AccountHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountHistoryBloc>(
      create: (context) =>
          AccountHistoryBloc(repository: AccountHistoryRepositoryImpl()),
      child: History(
        username: widget.username,
      ),
    );
  }
}

class History extends StatefulWidget {
  final String username;
  @override
  _HistoryState createState() => _HistoryState();

  History({Key? key, required this.username}) : super(key: key);
}

class _HistoryState extends State<History> {
  late AccountHistoryBloc historyBloc;
  late int lastNotification;

  @override
  void initState() {
    super.initState();
    historyBloc = BlocProvider.of<AccountHistoryBloc>(context);
    historyBloc.add(FetchAccountHistorysEvent(
        accountHistoryTypes: [], username: widget.username)); // statements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dtubeSubAppBar(false),
      body: Container(
        child: BlocBuilder<AccountHistoryBloc, AccountHistoryState>(
          builder: (context, state) {
            if (state is AccountHistoryInitialState) {
              return buildLoading();
            } else if (state is AccountHistoryLoadingState) {
              return buildLoading();
            } else if (state is AccountHistoryLoadedState) {
              return buildHistoryList(state.historyItems, state.username);
            } else if (state is AccountHistoryErrorState) {
              return buildErrorUi(state.message);
            } else {
              return buildErrorUi('test');
            }
          },
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

  Widget buildHistoryList(
      List<AvalonAccountHistoryItem> history, String username) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            child: Container(
              height: 48.0 * history[pos].txs.length + 1,
              //width: 30.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: history[pos].txs.length,
                itemBuilder: (ctx, posTx) {
                  return ActivityItem(
                    username: username,
                    txData: history[pos].txs[posTx],
                  );
                },
              ),
            ),
            onTap: () {
              // List<int> navigatableTxsUser = [1, 2, 7, 8];
              // List<int> navigatableTxsPost = [4, 5, 13, 19];
              // if (navigatableTxsUser.contains(history[pos].txs.type)) {
              //   //load user and navigate
              // }
              // if (navigatableTxsPost.contains(history[pos].txs.type)) {
              //   //load post and navigate to it

              //   //           Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   // return PostDetailPage(
              //   //   post: postData,
              //   // );
              //}
            },
          ),
        );
        // return Padding(
        //     padding: const EdgeInsets.only(bottom: 8.0),
        //     child: Text(history[pos].iId.toString()));
      },
    );
  }
}

class ActivityItem extends StatelessWidget {
  ActivityItem({
    required this.username,
    required this.txData,
    Key? key,
  }) : super(key: key);
  String username;

  Txs txData;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    String _receiver = txData.data.receiver != null
        ? txData.data.receiver!
        : txData.data.pa != null
            ? txData.data.pa!
            : txData.data.author != null
                ? txData.data.author!
                : txData.data.target != null
                    ? txData.data.target!
                    : "";

    String _receivers = _receiver + "'s";

    String friendlyDescription =
        txTypeFriendlyDescriptionNotifications[txData.type]!
            .replaceAll("##USERNAMES", _receivers)
            .replaceAll("##USERNAME", _receiver)
            .replaceAll('##DTCAMOUNT', (txData.data.amount! / 100).toString())
            .replaceAll('##TIPAMOUNT', (txData.data.tip!).toString());
    if (txData.type == 4 && _receiver == "") {
      friendlyDescription = "posted a video";
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        children: [
          txData.sender != ""
              ? Row(
                  children: [
                    InkWell(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: BlocProvider<UserBloc>(
                              create: (BuildContext context) =>
                                  UserBloc(repository: UserRepositoryImpl()),
                              child: AccountAvatar(
                                  username: txData.sender, size: 40),
                            ),
                          ),
                          Container(
                            width: 90,
                            child: Text(
                              txData.sender,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        navigateToUserDetailPage(context, txData.sender);
                      },
                    ),
                    Container(
                      width: deviceWidth - 180,
                      child: Text(
                        friendlyDescription,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: 20,
                        child: [4, 5, 13, 17, 19].contains(txData.type)
                            ? FaIcon(
                                FontAwesomeIcons.play,
                                size: 15,
                              )
                            : SizedBox(width: 0),
                      ),
                      onTap: () {
                        // TODO: navigate to post
                      },
                    ),
                  ],
                )
              : SizedBox(height: 0, width: 0),
        ],
      ),
    );
  }
}
