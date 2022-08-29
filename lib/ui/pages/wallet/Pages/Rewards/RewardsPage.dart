import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/Layouts/RewardsPageDesktop.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/Layouts/RewardsPageMobile.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardCard/RewardCard.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardsList/RewardList.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
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
