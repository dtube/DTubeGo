import 'package:dtube_go/ui/pages/Governance/Pages/Rewards/Layouts/RewardsPageDesktop.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Rewards/Layouts/RewardsPageMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: RewardsPageDesktop(),
      tabletBody: RewardsPageDesktop(),
      mobileBody: RewardsPageMobile(),
    );
  }
}
