import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/rewards/rewards_bloc.dart';
import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/bloc/rewards/rewards_event.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_go/utils/friendlyTimestamp.dart';
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
          return DtubeLogoPulseWithSubtitle(
            subtitle: "loading rewards..",
            size: 30.w,
          );
        }
        if (state is RewardsLoadedState) {
          List<Reward> _rewards = state.rewardList;
          if (_rewards.isEmpty) {
            return Center(
                child: Text(
              "nothing here",
              style: Theme.of(context).textTheme.bodyText1,
            ));
          } else {
            return ListView.builder(
                padding: EdgeInsets.zero,
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                key: new PageStorageKey(
                    'rewards' + widget.rewardsState + 'listview'),
                itemCount: _rewards.length,
                itemBuilder: (ctx, pos) {
                  return RewardsCard(
                    reward: _rewards[pos],
                    parentWidget: this.widget,
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
  RewardsCard({Key? key, required this.reward, required this.parentWidget})
      : super(key: key);

  late Reward reward;
  late Widget parentWidget;

  @override
  _RewardsCardState createState() => _RewardsCardState();
}

class _RewardsCardState extends State<RewardsCard>
    with AutomaticKeepAliveClientMixin {
  double widthLabel = 25.w;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToPostDetailPage(
            context, widget.reward.author, widget.reward.link);
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AccountAvatarBase(
                      username: widget.reward.author,
                      avatarSize: 10.h,
                      showVerified: true,
                      showName: true,
                      width: 60.w,
                      height: 10.h,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "content:",
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                    Container(
                        width: 30.w,
                        child: Text(
                          widget.reward.author + '/' + widget.reward.link,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "spent:",
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                    Text(
                      (widget.reward.vt / 1000).toStringAsFixed(2) + 'K',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "voted on:",
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(widget.reward.ts)
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "published on:",
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              widget.reward.contentTs)
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 28.w,
              child: widget.reward.claimed != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (widget.reward.claimable / 100)
                                  .toStringAsFixed(2),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: DTubeLogoShadowed(size: 5.w),
                            ),
                          ],
                        ),
                        Text(
                          "claimed",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          TimeAgo.timeInAgoTS(widget.reward.claimed!),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
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
                            topLevelWidget: widget.parentWidget,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (widget.reward.claimable / 100)
                                      .toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 1.w),
                                  child: DTubeLogoShadowed(size: 5.w),
                                ),
                              ],
                            ),
                            Text(
                              'claimable ',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              TimeAgo.timeAgoClaimIn(widget.reward.ts),
                              style: Theme.of(context).textTheme.bodyText2,
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
  ClaimRewardButton(
      {Key? key,
      required this.author,
      required this.link,
      required this.claimable,
      required this.topLevelWidget})
      : super(key: key);

  final String author;
  final String link;
  final double claimable;
  late Widget topLevelWidget;

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'claimed',
              style: Theme.of(context).textTheme.headline6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (widget.claimable / 100).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 1.w),
                  child: DTubeLogoShadowed(size: 5.w),
                ),
              ],
            ),
          ],
        );
      } else {
        if (state is TransactionSinging || state is TransactionSigned) {
          return CircularProgressIndicator();
        } else {
          return ElevatedButton(
            onPressed: !globals.keyPermissions.contains(17)
                ? null
                : () {
                    TxData txdata = TxData(
                      author: widget.author,
                      link: widget.link,
                    );
                    Transaction newTx = Transaction(type: 17, data: txdata);
                    _txBloc.add(SignAndSendTransactionEvent(newTx));
                  },
            child: Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'claim',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (widget.claimable / 100).toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1.w),
                        child: DTubeLogoShadowed(size: 5.w),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }
    });
  }
}
