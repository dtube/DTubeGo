import 'package:dtube_go/ui/pages/Governance/Layouts/GovernanceTabContainerDesktop.dart';
import 'package:dtube_go/ui/pages/Governance/Layouts/GovernanceTabContainerMobile.dart';

import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class GovernanceMainPage extends StatelessWidget {
  const GovernanceMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: GovernanceMainPageDesktop(),
      tabletBody: GovernanceMainPageDesktop(),
      mobileBody: GovernanceMainPageMobile(),
    );
  }
}
