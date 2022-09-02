import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/ProposalList/Layouts/ProposalListDesktop.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/ProposalList/Layouts/ProposalListMobile.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/ProposalList/Layouts/ProposalListTablet.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class ProposalList extends StatelessWidget {
  const ProposalList(
      {Key? key,
      required this.daoState,
      required this.daoType,
      required this.daoVotingThreshold,
      required this.daoVotingPeriod})
      : super(key: key);
  final String daoState;
  final String daoType;
  final int daoVotingThreshold;
  final int daoVotingPeriod;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: ProposalListDesktop(
          daoState: daoState,
          daoType: daoType,
          daoVotingThreshold: daoVotingThreshold,
          daoVotingPeriod: daoVotingPeriod),
      tabletBody: ProposalListTablet(
          daoState: daoState,
          daoType: daoType,
          daoVotingThreshold: daoVotingThreshold,
          daoVotingPeriod: daoVotingPeriod),
      mobileBody: ProposalListMobile(
          daoState: daoState,
          daoType: daoType,
          daoVotingThreshold: daoVotingThreshold,
          daoVotingPeriod: daoVotingPeriod),
    );
  }
}
