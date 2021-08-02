import 'package:dtube_togo/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_togo/bloc/config/txTypes.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';

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
              height: 50,
              width: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: history[pos].txs.length,
                itemBuilder: (ctx, posTx) {
                  String username2 = "your";
                  if (username != "you") {
                    username2 = username + "'s";
                  }

                  String friendlyDescription = ' ' +
                      txTypeFriendlyDescriptionNotifications[
                              history[pos].txs[posTx].type]!
                          .replaceAll("##USERNAMES", username2)
                          .replaceAll("##USERNAME", username);
                  return Column(
                    children: [
                      history[pos].txs[posTx].sender != ""
                          ? Text(history[pos].txs[posTx].sender +
                              friendlyDescription)
                          : SizedBox(height: 0, width: 0),
                    ],
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

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.sender,
    required this.tx,
  }) : super(key: key);

  final String sender;
  final Tx tx;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 35,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocProvider<UserBloc>(
              create: (BuildContext context) =>
                  UserBloc(repository: UserRepositoryImpl()),
              child: AccountAvatar(username: sender, size: 30),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationTitle(sender: sender, tx: tx),
                  NotificationDescription(tx: tx),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationTitle extends StatelessWidget {
  const NotificationTitle({
    Key? key,
    required this.sender,
    required this.tx,
  }) : super(key: key);

  final String sender;
  final Tx tx;

  @override
  Widget build(BuildContext context) {
    String friendlyDescription =
        ' ' + txTypeFriendlyDescriptionNotifications[tx.type]!;
    switch (tx.type) {
      case 3:
        friendlyDescription = friendlyDescription.replaceAll(
            '##DTCAMOUNT', (tx.data.amount! / 100).toString());
        break;
      case 19:
        friendlyDescription = friendlyDescription.replaceAll(
            '##TIPAMOUNT', tx.data.tip!.toString());
        break;
      default:
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          sender,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Text(
          friendlyDescription,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14.0,
            //color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class NotificationDescription extends StatelessWidget {
  const NotificationDescription({
    Key? key,
    required this.tx,
  }) : super(key: key);

  final Tx tx;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Text(
          DateFormat('yyyy-MM-dd kk:mm').format(
              DateTime.fromMicrosecondsSinceEpoch(tx.ts * 1000).toLocal()),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.0,
            //color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
