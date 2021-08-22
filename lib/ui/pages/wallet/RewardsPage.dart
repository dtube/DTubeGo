import 'package:dtube_togo/bloc/rewards/rewards_bloc.dart';
import 'package:dtube_togo/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_togo/bloc/rewards/rewards_event.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/utils/friendlyTimestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({
    Key? key,
  }) : super(key: key);

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: globalAlmostWhite,
            indicatorColor: globalRed,
            tabs: [
              Tab(
                text: 'Claimable',
              ),
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Claimed',
              )
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                children: [
                  // WalletPage(),

                  BlocProvider(
                      create: (context) =>
                          RewardsBloc(repository: RewardRepositoryImpl()),
                      child: RewardsList(
                        rewardsState: "claimable",
                      )),
                  BlocProvider(
                      create: (context) =>
                          RewardsBloc(repository: RewardRepositoryImpl()),
                      child: RewardsList(
                        rewardsState: "pending",
                      )),
                  BlocProvider(
                      create: (context) =>
                          RewardsBloc(repository: RewardRepositoryImpl()),
                      child: RewardsList(
                        rewardsState: "claimed",
                      )),
                ],
                controller: _tabController,
              ),
            ),
          ),
          //https://avalon.d.tube/votes/claimable/tibfox/0
        ],
      ),
    );
  }
}

class RewardsList extends StatefulWidget {
  const RewardsList({Key? key, required this.rewardsState}) : super(key: key);
  final String rewardsState;

  @override
  _RewardsListState createState() => _RewardsListState();
}

class _RewardsListState extends State<RewardsList> {
  late RewardsBloc _rewardsBloc;

  @override
  void initState() {
    super.initState();
    _rewardsBloc = BlocProvider.of<RewardsBloc>(context);
    _rewardsBloc.add(FetchRewardsEvent(rewardState: widget.rewardsState));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardsBloc, RewardsState>(
      builder: (context, state) {
        if (state is RewardsLoadingState) {
          return Center(
              child:
                  DTubeLogoPulse(size: MediaQuery.of(context).size.width / 3));
        }
        if (state is RewardsLoadedState) {
          List<Reward> _rewards = state.rewardList;
          if (_rewards.isEmpty) {
            return Center(
                child: Text(
              "nothing here",
              style: Theme.of(context).textTheme.headline2,
            ));
          } else {
            return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _rewards.length,
                itemBuilder: (ctx, pos) {
                  return RewardsCard(
                    reward: _rewards[pos],
                  );
                });
          }
        }
        return Text("loading");
      },
    );
  }
}

class RewardsCard extends StatefulWidget {
  RewardsCard({
    Key? key,
    required this.reward,
  }) : super(key: key);

  late Reward reward;

  @override
  _RewardsCardState createState() => _RewardsCardState();
}

class _RewardsCardState extends State<RewardsCard> {
  double widthLabel = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        navigateToPostDetailPage(
            context, widget.reward.author, widget.reward.link);
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            SizedBox(
                width: 40,
                height: 40,
                child: AccountAvatarBase(
                  username: widget.reward.author,
                  avatarSize: 40,
                  showVerified: true,
                  showName: false,
                  width: 100,
                )),
            SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "content:",
                          style: Theme.of(context).textTheme.headline5,
                        )),
                    Container(
                        width: deviceWidth - 310,
                        child: Text(
                          widget.reward.author + '/' + widget.reward.link,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline5,
                        )),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "spent:",
                          style: Theme.of(context).textTheme.headline5,
                        )),
                    Text(
                      (widget.reward.vt / 1000).toStringAsFixed(2) + 'K',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "voted on:",
                          style: Theme.of(context).textTheme.headline5,
                        )),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(widget.reward.ts)
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "published on:",
                          style: Theme.of(context).textTheme.headline5,
                        )),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              widget.reward.contentTs)
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 80,
              child: widget.reward.claimed != null
                  ? Text(
                      "already claimed " +
                          (widget.reward.claimable / 100).toStringAsFixed(2) +
                          ' DTC ' +
                          TimeAgo.timeInAgoTS(widget.reward.claimed!),
                      style: Theme.of(context).textTheme.headline5,
                    )
                  : timestampGreater7Days(widget.reward.ts)
                      ? BlocProvider(
                          // gets its own tranactionbloc to avoid spamming snackbars
                          create: (context) => TransactionBloc(
                              repository: TransactionRepositoryImpl()),
                          child: ClaimRewardButton(
                            author: widget.reward.author,
                            claimable: widget.reward.claimable,
                            link: widget.reward.link,
                          ),
                        )
                      : Column(
                          children: [
                            Text(
                              (widget.reward.claimable / 100)
                                      .toStringAsFixed(2) +
                                  ' DTC claimable ' +
                                  TimeAgo.timeAgoClaimIn(widget.reward.ts),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
            ),
          ],
        ),
      )),
    );
  }

  void navigateToPostDetailPage(
      BuildContext context, String author, String link) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostDetailPage(
        author: author,
        link: link,
        recentlyUploaded: false,
        directFocus: "none",
      );
    }));
  }
}

class ClaimRewardButton extends StatefulWidget {
  const ClaimRewardButton({
    Key? key,
    required this.author,
    required this.link,
    required this.claimable,
  }) : super(key: key);

  final String author;
  final String link;
  final double claimable;

  @override
  _ClaimRewardButtonState createState() => _ClaimRewardButtonState();
}

class _ClaimRewardButtonState extends State<ClaimRewardButton> {
  late TransactionBloc _txBloc;

  @override
  void initState() {
    super.initState();
    _txBloc = BlocProvider.of<TransactionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
      if (state is TransactionSent) {
        return Text(
          "claimed " + (widget.claimable / 100).toStringAsFixed(2) + " DTC",
          style: Theme.of(context).textTheme.headline5,
        );
      } else {
        if (state is TransactionSinging || state is TransactionSigned) {
          return CircularProgressIndicator();
        } else {
          return ElevatedButton(
            onPressed: () {
              TxData txdata = TxData(
                author: widget.author,
                link: widget.link,
              );
              Transaction newTx = Transaction(type: 17, data: txdata);
              _txBloc.add(SignAndSendTransactionEvent(newTx));
            },
            child: Text('claim \n' +
                (widget.claimable / 100).toStringAsFixed(2) +
                ' DTC'),
          );
        }
      }
    });
  }
}
