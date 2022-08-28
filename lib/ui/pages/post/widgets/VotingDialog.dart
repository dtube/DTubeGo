import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingDialogDesktop.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingDialogMobile.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:dtube_go/utils/Strings/shortBalanceStrings.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VotingDialog extends StatelessWidget {
  VotingDialog(
      {Key? key,
      required this.author,
      required this.link,
      required this.downvote,
      required this.defaultVote,
      required this.defaultTip,
      //required this.currentVT,
      required this.isPost,
      this.vertical,
      this.verticalModeCallbackVotingButtonsPressed,
      this.okCallback,
      this.cancelCallback,
      required this.txBloc,
      required this.postBloc,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight})
      : super(key: key);

  final String author;
  final String link;
  final double defaultVote;
  final double defaultTip;
  final double fixedDownvoteWeight;
  final bool fixedDownvoteActivated;
  // double currentVT;
  final bool isPost;
  final bool? vertical; // only used in moments for now

  final bool downvote;
  final VoidCallback? verticalModeCallbackVotingButtonsPressed;

  final VoidCallback? okCallback;
  final VoidCallback? cancelCallback;
  final TransactionBloc txBloc;
  final PostBloc postBloc;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: VotingDialogDesktop(
          author: author,
          link: link,
          downvote: downvote,
          defaultVote: defaultVote,
          defaultTip: defaultTip,
          isPost: isPost,
          txBloc: txBloc,
          postBloc: postBloc,
          fixedDownvoteActivated: fixedDownvoteActivated,
          fixedDownvoteWeight: fixedDownvoteWeight),
      tabletBody: VotingDialogDesktop(
          author: author,
          link: link,
          downvote: downvote,
          defaultVote: defaultVote,
          defaultTip: defaultTip,
          isPost: isPost,
          txBloc: txBloc,
          postBloc: postBloc,
          fixedDownvoteActivated: fixedDownvoteActivated,
          fixedDownvoteWeight: fixedDownvoteWeight),
      mobileBody: VotingDialogMobile(
          author: author,
          link: link,
          downvote: downvote,
          defaultVote: defaultVote,
          defaultTip: defaultTip,
          isPost: isPost,
          txBloc: txBloc,
          postBloc: postBloc,
          fixedDownvoteActivated: fixedDownvoteActivated,
          fixedDownvoteWeight: fixedDownvoteWeight),
    );
  }
}
