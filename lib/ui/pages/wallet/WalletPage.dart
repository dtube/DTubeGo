import 'package:dtube_togo/bloc/rewards/rewards_bloc.dart';
import 'package:dtube_togo/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_togo/bloc/rewards/rewards_event.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/ui/pages/post/widgets/AccountAvatar.dart';
import 'package:dtube_togo/ui/pages/post/widgets/postDetailPageV2.dart';
import 'package:dtube_togo/ui/pages/wallet/transferDialog.dart';
import 'package:dtube_togo/ui/widgets/customSnackbar.dart';
import 'package:dtube_togo/utils/friendlyTimestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({
    Key? key,
  }) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            showCustomFlushbarOnError(state, context);
          }
          if (state is TransactionSent) {
            showCustomFlushbarOnSuccess(state, context);
          }
        },
        child: Center(
          child: Column(
            children: [
              TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: globalAlmostWhite,
                indicatorColor: globalRed,
                tabs: [
                  Tab(
                    text: 'Transfer History',
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBarView(
                    children: [
                      // BlocProvider(
                      //     create: (context) =>
                      //         RewardsBloc(repository: RewardRepositoryImpl()),
                      //     child:
                      WalletHistoryList(

                          // )
                          ),

                      // BlocProvider(
                      //     create: (context) =>
                      //         RewardsBloc(repository: RewardRepositoryImpl()),
                      //     child: WalletHistoryList(

                      //     )),
                    ],
                    controller: _tabController,
                  ),
                ),
              ),
              //https://avalon.d.tube/votes/claimable/tibfox/0
            ],
          ),
        ));
  }
}

class WalletHistoryList extends StatefulWidget {
  const WalletHistoryList({Key? key}) : super(key: key);

  @override
  _WalletHistoryListState createState() => _WalletHistoryListState();
}

class _WalletHistoryListState extends State<WalletHistoryList> {
  late TransactionBloc _transactionBloc;

  @override
  void initState() {
    super.initState();
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
    // _rewardsBloc.add(FetchRewardsEvent(rewardState: widget.rewardsState));
  }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<RewardsBloc, RewardsState>(
    //   builder: (context, state) {
    //     if (state is RewardsLoadingState) {
    //       return Center(child: DTubeLogoPulse());
    //     }
    //     if (state is RewardsLoadedState) {
    //       List<Reward> _rewards = state.rewardList;
    //       return ListView.builder(
    //           padding: EdgeInsets.zero,
    //           shrinkWrap: true,
    //           physics: ClampingScrollPhysics(),
    //           itemCount: _rewards.length,
    //           itemBuilder: (ctx, pos) {
    //             return HistoryCard(
    //               reward: _rewards[pos],
    //             );
    //           });
    //     }
    //     return Text("Test");
    //   },
    // );
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InputChip(
            label: Text("new transfer"),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    TransferDialog(txBloc: _transactionBloc),
              );
            },
          ),
        ),
        Text("History will come soon"),
      ],
    );
  }
}

class HistoryCard extends StatefulWidget {
  HistoryCard({
    Key? key,
    required this.reward,
  }) : super(key: key);

  late Reward reward;

  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  double widthLabel = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onTap: () {
    //     navigateToPostDetailPage(
    //         context, widget.reward.author, widget.reward.link);
    //   },
    //   child: Card(
    //       child: Padding(
    //     padding: const EdgeInsets.all(4.0),
    //     child: Row(
    //       children: [
    //         AccoutnAvatarBase(username: widget.reward.author),
    //         SizedBox(width: 8),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               children: [
    //                 SizedBox(
    //                     width: widthLabel,
    //                     child: Text(
    //                       "content:",
    //                       style: Theme.of(context).textTheme.subtitle2,
    //                     )),
    //                 Container(
    //                     width: MediaQuery.of(context).size.width - 310,
    //                     child: Text(
    //                       widget.reward.author + '/' + widget.reward.link,
    //                       overflow: TextOverflow.ellipsis,
    //                       style: Theme.of(context).textTheme.caption,
    //                     )),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 SizedBox(
    //                     width: widthLabel,
    //                     child: Text(
    //                       "spent:",
    //                       style: Theme.of(context).textTheme.subtitle2,
    //                     )),
    //                 Text(
    //                   (widget.reward.vt / 1000).toStringAsFixed(2) + 'K',
    //                   style: Theme.of(context).textTheme.caption,
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 SizedBox(
    //                     width: widthLabel,
    //                     child: Text(
    //                       "voted on:",
    //                       style: Theme.of(context).textTheme.subtitle2,
    //                     )),
    //                 Text(
    //                   DateTime.fromMillisecondsSinceEpoch(widget.reward.ts)
    //                       .toLocal()
    //                       .toString()
    //                       .substring(0, 16),
    //                   style: Theme.of(context).textTheme.caption,
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 SizedBox(
    //                     width: widthLabel,
    //                     child: Text(
    //                       "published on:",
    //                       style: Theme.of(context).textTheme.subtitle2,
    //                     )),
    //                 Text(
    //                   DateTime.fromMillisecondsSinceEpoch(
    //                           widget.reward.contentTs)
    //                       .toLocal()
    //                       .toString()
    //                       .substring(0, 16),
    //                   style: Theme.of(context).textTheme.caption,
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //         Container(
    //           width: 100,
    //           child: widget.reward.claimed != null
    //               ? Text("already claimed " +
    //                   (widget.reward.claimable / 100).toStringAsFixed(2) +
    //                   ' DTC ' +
    //                   friendlyTimestamp(widget.reward.claimed!))
    //               : timestampGreater7Days(widget.reward.ts)
    //                   ? BlocProvider(
    //                       create: (context) => TransactionBloc(
    //                           repository: TransactionRepositoryImpl()),
    //                       // child: ClaimRewardButton(
    //                       //   author: widget.reward.author,
    //                       //   claimable: widget.reward.claimable,
    //                       //   link: widget.reward.link,
    //                       // ),
    //                     )
    //                   : Column(
    //                       children: [
    //                         Text((widget.reward.claimable / 100)
    //                                 .toStringAsFixed(2) +
    //                             ' DTC claimable ' +
    //                             timestamp7Days(widget.reward.ts)),
    //                       ],
    //                     ),
    //         ),
    //       ],
    //     ),
    //   )),
    // );
    return Text("none");
  }
}
