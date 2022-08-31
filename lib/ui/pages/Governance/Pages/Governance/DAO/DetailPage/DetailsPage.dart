import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/DetailPage/DetailsPageDesktop.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/DetailPage/DetailsPageMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class ProposalDetailPage extends StatelessWidget {
  final int proposalId;
  final int daoThreshold;

  ProposalDetailPage({required this.daoThreshold, required this.proposalId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: ProposalDetailPageDesktop(
          daoThreshold: daoThreshold, proposalId: proposalId),
      tabletBody: ProposalDetailPageDesktop(
          daoThreshold: daoThreshold, proposalId: proposalId),
      mobileBody: ProposalDetailPageMobile(
          daoThreshold: daoThreshold, proposalId: proposalId),
    );
  }
}
