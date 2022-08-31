import 'package:dtube_go/ui/pages/Governance/Pages/Governance/Leaderboard/Layouts/LeaderboardDesktop.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/Leaderboard/Layouts/LeaderboardMobile.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/Leaderboard/Layouts/LeaderboardTablet.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: LeaderboardDesktop(),
      mobileBody: LeaderboardMobile(),
      tabletBody: LeaderboardTablet(),
    );
  }
}
