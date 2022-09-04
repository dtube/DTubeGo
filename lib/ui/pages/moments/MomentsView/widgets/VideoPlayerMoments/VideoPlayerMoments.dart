import 'package:dtube_go/ui/pages/moments/MomentsView/widgets/VideoPlayerMoments/Layouts/VideoPlayerMomentsDesktop.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/widgets/VideoPlayerMoments/Layouts/VideoPlayerMomentsMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/controller/MomentsController.dart';
import 'package:flutter/material.dart';

class VideoPlayerMoments extends StatelessWidget {
  //final String link;
  final FeedItem feedItem;
  MomentsController momentsController;
  VoidCallback goingInBackgroundCallback;
  VoidCallback goingInForegroundCallback;
  String defaultPostsVotingWeight;
  String defaultPostsVotingTip;
  String defaultCommentsVotingWeight;

  String momentsVotingWeight;
  String momentsUploadNSFW;
  String momentsUploadOC;
  String momentsUploadUnlist;
  String momentsUploadCrosspost;
  double currentVP;

  double fixedDownvoteWeight;
  bool fixedDownvoteActivated;

  UserBloc userBloc;

  VideoPlayerMoments(
      {Key? key, //required this.link,
      required this.feedItem,
      required this.momentsController,
      required this.goingInBackgroundCallback,
      required this.goingInForegroundCallback,
      required this.defaultCommentsVotingWeight,
      required this.defaultPostsVotingTip,
      required this.defaultPostsVotingWeight,
      required this.momentsVotingWeight,
      required this.momentsUploadNSFW,
      required this.momentsUploadOC,
      required this.momentsUploadUnlist,
      required this.momentsUploadCrosspost,
      required this.userBloc,
      required this.currentVP,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: VideoPlayerMomentsDesktop(
          feedItem: feedItem,
          momentsController: momentsController,
          goingInBackgroundCallback: goingInBackgroundCallback,
          goingInForegroundCallback: goingInForegroundCallback,
          defaultCommentsVotingWeight: defaultCommentsVotingWeight,
          defaultPostsVotingTip: defaultPostsVotingTip,
          defaultPostsVotingWeight: defaultPostsVotingWeight,
          momentsVotingWeight: momentsVotingWeight,
          momentsUploadNSFW: momentsUploadNSFW,
          momentsUploadOC: momentsUploadOC,
          momentsUploadUnlist: momentsUploadUnlist,
          momentsUploadCrosspost: momentsUploadCrosspost,
          userBloc: userBloc,
          currentVP: currentVP,
          fixedDownvoteActivated: fixedDownvoteActivated,
          fixedDownvoteWeight: fixedDownvoteWeight),
      tabletBody: VideoPlayerMomentsDesktop(
          feedItem: feedItem,
          momentsController: momentsController,
          goingInBackgroundCallback: goingInBackgroundCallback,
          goingInForegroundCallback: goingInForegroundCallback,
          defaultCommentsVotingWeight: defaultCommentsVotingWeight,
          defaultPostsVotingTip: defaultPostsVotingTip,
          defaultPostsVotingWeight: defaultPostsVotingWeight,
          momentsVotingWeight: momentsVotingWeight,
          momentsUploadNSFW: momentsUploadNSFW,
          momentsUploadOC: momentsUploadOC,
          momentsUploadUnlist: momentsUploadUnlist,
          momentsUploadCrosspost: momentsUploadCrosspost,
          userBloc: userBloc,
          currentVP: currentVP,
          fixedDownvoteActivated: fixedDownvoteActivated,
          fixedDownvoteWeight: fixedDownvoteWeight),
      mobileBody: VideoPlayerMomentsMobile(
          feedItem: feedItem,
          momentsController: momentsController,
          goingInBackgroundCallback: goingInBackgroundCallback,
          goingInForegroundCallback: goingInForegroundCallback,
          defaultCommentsVotingWeight: defaultCommentsVotingWeight,
          defaultPostsVotingTip: defaultPostsVotingTip,
          defaultPostsVotingWeight: defaultPostsVotingWeight,
          momentsVotingWeight: momentsVotingWeight,
          momentsUploadNSFW: momentsUploadNSFW,
          momentsUploadOC: momentsUploadOC,
          momentsUploadUnlist: momentsUploadUnlist,
          momentsUploadCrosspost: momentsUploadCrosspost,
          userBloc: userBloc,
          currentVP: currentVP,
          fixedDownvoteActivated: fixedDownvoteActivated,
          fixedDownvoteWeight: fixedDownvoteWeight),
    );
  }
}
