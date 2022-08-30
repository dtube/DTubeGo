import 'package:dtube_go/ui/pages/Governance/Pages/Rewards/RewardsList/RewardListDesktop.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Rewards/RewardsList/RewardListMobile.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Rewards/RewardsList/RewardListTablet.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class RewardList extends StatelessWidget {
  const RewardList({Key? key, required this.rewardsState}) : super(key: key);
  final String rewardsState;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: RewardsListDesktop(rewardsState: rewardsState),
      tabletBody: RewardsListTablet(rewardsState: rewardsState),
      mobileBody: RewardsListMobile(rewardsState: rewardsState),
    );
  }
}
