import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/bloc/dao/dao_bloc.dart';
import 'package:dtube_go/bloc/dao/dao_repository.dart';
import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/wallet/Layouts/WalletTabContainerDesktop.dart';
import 'package:dtube_go/ui/pages/wallet/Layouts/WalletTabContainerMobile.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/Governance.dart';

import 'package:dtube_go/ui/pages/wallet/Pages/KeyManagement/KeyManagement.dart';

import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardsPage.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Wallet/WalletPage.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WalletMainPage extends StatelessWidget {
  const WalletMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: WalletMainPageDesktop(),
      tabletBody: WalletMainPageDesktop(),
      mobileBody: WalletMainPageMobile(),
    );
  }
}
