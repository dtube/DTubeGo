import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteOverview/VoteOverviewDesktop.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteOverview/VoteOverviewMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class VotesOverview extends StatelessWidget {
  VotesOverview({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: VotesOverviewDesktop(post: post),
      tabletBody: VotesOverviewDesktop(post: post),
      mobileBody: VotesOverviewMobile(post: post),
    );
  }
}
