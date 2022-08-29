import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardCard/RewardCard.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardsList/RewardList.dart';
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

class RewardsPageMobile extends StatefulWidget {
  const RewardsPageMobile({
    Key? key,
  }) : super(key: key);

  @override
  _RewardsPageMobileState createState() => _RewardsPageMobileState();
}

class _RewardsPageMobileState extends State<RewardsPageMobile>
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
                      child: RewardList(
                        rewardsState: "claimable",
                      )),
                  BlocProvider(
                      create: (context) =>
                          RewardsBloc(repository: RewardRepositoryImpl()),
                      child: RewardList(
                        rewardsState: "pending",
                      )),
                  BlocProvider(
                      create: (context) =>
                          RewardsBloc(repository: RewardRepositoryImpl()),
                      child: RewardList(
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
