import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/rewards/rewards_bloc.dart';
import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/bloc/rewards/rewards_event.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/pages/post/postDetailPage.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
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

  List<String> pageNames = ["Claimable", "Pending", "Claimed"];
  List<IconData> pagesIcons = [
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.calendarDay,
    FontAwesomeIcons.calendarCheck
  ];

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 3.h,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: globalAlmostWhite,
              indicatorColor: globalRed,
              isScrollable: true,
              tabs: [
                Tab(
                  text: "claimable",
                ),
                Tab(
                  text: "pending",
                ),
                Tab(
                  text: "claimed",
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
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
