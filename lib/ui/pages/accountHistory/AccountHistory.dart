import 'package:dtube_go/ui/widgets/AppBar/DTubeSubAppBarDesktop.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/Navigation/navigationShortCuts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountHistoryScreen extends StatefulWidget {
  AccountHistoryScreen({Key? key, required this.username}) : super(key: key);
  final String? username;

  @override
  _AccountHistoryScreenState createState() => _AccountHistoryScreenState();
}

class _AccountHistoryScreenState extends State<AccountHistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

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
  final String? username;
  @override
  _HistoryState createState() => _HistoryState();

  History({Key? key, required this.username}) : super(key: key);
}

class _HistoryState extends State<History> {
  late AccountHistoryBloc historyBloc;
  late int lastNotification;
  final ScrollController _scrollController = ScrollController();
  List<AvalonAccountHistoryItem> _historyItems = [];
  late String? _username;
  @override
  void initState() {
    super.initState();
    historyBloc = BlocProvider.of<AccountHistoryBloc>(context);
    historyBloc.add(FetchAccountHistorysEvent(
        accountHistoryTypes: [],
        username: widget.username,
        fromBloc: 0)); // statements;
    _username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: dtubeSubAppBarDesktop(false, "", context, null),
        body:
            // Container(
            //   child: BlocBuilder<AccountHistoryBloc, AccountHistoryState>(
            //     builder: (context, state) {
            //       if (state is AccountHistoryInitialState) {
            //         return buildLoading();
            //       } else if (state is AccountHistoryLoadingState) {
            //         return buildLoading();
            //       } else if (state is AccountHistoryLoadedState) {
            //         return buildHistoryList(state.historyItems, state.username);
            //       } else if (state is AccountHistoryErrorState) {
            //         return buildErrorUi(state.message);
            //       } else {
            //         return buildErrorUi('test');
            //       }
            //     },
            //   ),
            // ),

            Container(
          height: MediaQuery.of(context).size.height - 150,
          // color: globalAlmostBlack,

          child: BlocConsumer<AccountHistoryBloc, AccountHistoryState>(
            listener: (context, state) {
              if (state is AccountHistoryErrorState) {
                BlocProvider.of<AccountHistoryBloc>(context).isFetching = false;
              }
              return;
            },
            builder: (context, state) {
              if (state is AccountHistoryInitialState ||
                  state is AccountHistoryLoadingState &&
                      _historyItems.isEmpty) {
                return buildLoading();
              } else if (state is AccountHistoryLoadedState) {
                _username = state.username;
                _historyItems.addAll(state.historyItems);
                BlocProvider.of<AccountHistoryBloc>(context).isFetching = false;
              } else if (state is AccountHistoryErrorState) {
                return buildErrorUi(state.message);
              }
              return buildHistoryList(
                _historyItems,
                _username,
              );
            },
          ),
        ));
  }

  Widget buildLoading() {
    return DtubeLogoPulseWithSubtitle(
      subtitle: "loading history..",
      size: 40.w,
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
      List<AvalonAccountHistoryItem> history, String? username) {
    return ListView.builder(
      itemCount: history.length,
      controller: _scrollController
        ..addListener(() {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !BlocProvider.of<AccountHistoryBloc>(context).isFetching) {
            BlocProvider.of<AccountHistoryBloc>(context)
              ..isFetching = true
              ..add(FetchAccountHistorysEvent(
                  accountHistoryTypes: [],
                  username: widget.username,
                  fromBloc: history[history.length - 1].iId));
          }

          if (_scrollController.offset <=
                  _scrollController.position.minScrollExtent &&
              !BlocProvider.of<AccountHistoryBloc>(context).isFetching) {
            history.clear();
            BlocProvider.of<AccountHistoryBloc>(context)
              ..isFetching = true
              ..add(FetchAccountHistorysEvent(
                  accountHistoryTypes: [],
                  username: widget.username,
                  fromBloc: 0));
          }
        }),
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Container(
              height: 8.h,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: history[pos].txs.length,
                itemBuilder: (ctx, posTx) {
                  return ActivityItem(
                    username: username!,
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
    return Container(
      width: 95.w,
      child: Column(
        children: [
          txData.sender != ""
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Row(
                        children: [
                          AccountIconBase(
                            username: txData.sender,
                            avatarSize: 10.w,
                            showVerified: true,
                            // showName: true,
                            // width: 30.w,
                            // height: 10.h
                          ),
                          AccountNameBase(
                              username: txData.sender,
                              width: 30.w,
                              height: 10.h,
                              mainStyle: Theme.of(context).textTheme.headline5!,
                              subStyle: Theme.of(context).textTheme.bodyText1!)
                        ],
                      ),
                      onTap: () {
                        navigateToUserDetailPage(context, txData.sender, () {});
                      },
                    ),
                    Container(
                      width: 50.w,
                      child: Text(
                        friendlyDescription,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: 20,
                        child: [4, 5, 13, 17, 19].contains(txData.type) // post
                            ? FaIcon(
                                FontAwesomeIcons.play,
                                size: 15,
                              )
                            : ([1, 2, 7, 8].contains(txData.type) &&
                                        txData.data.target != null &&
                                        txData.data.target != username) ||
                                    (txData.type == 3 &&
                                        txData.data.receiver !=
                                            username) // user
                                ? FaIcon(
                                    FontAwesomeIcons.user,
                                    size: 15,
                                  )
                                : SizedBox(width: 0),
                      ),
                      onTap: () {
                        if (txData.data.author != null &&
                            txData.data.link != null) {
                          navigateToPostDetailPage(context, txData.data.author!,
                              txData.data.link!, "none", false, () {});
                        }
                        if (txData.data.pa != null && txData.data.pp != null) {
                          navigateToPostDetailPage(context, txData.data.pa!,
                              txData.data.pp!, "none", false, () {});
                        }
                        if (txData.data.target != null) {
                          print(username);
                          navigateToUserDetailPage(
                              context, txData.data.target!, () {});
                        }
                        if (txData.data.receiver != null) {
                          navigateToUserDetailPage(
                              context, txData.data.receiver!, () {});
                        }
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
