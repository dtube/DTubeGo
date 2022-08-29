import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardCard/RewardCardDesktop.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardCard/RewardCardMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class RewardCard extends StatelessWidget {
  RewardCard({Key? key, required this.reward, required this.parentWidget})
      : super(key: key);

  final Reward reward;
  final Widget parentWidget;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody:
          RewardCardDesktop(reward: reward, parentWidget: parentWidget),
      tabletBody: RewardCardDesktop(reward: reward, parentWidget: parentWidget),
      mobileBody: RewardCardMobile(reward: reward, parentWidget: parentWidget),
    );
  }
}
