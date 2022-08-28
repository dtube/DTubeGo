import 'package:dtube_go/ui/pages/settings/SettingsTabContainerDesktop.dart';
import 'package:dtube_go/ui/pages/settings/SettingsTabContainerMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class SettingsTabContainer extends StatelessWidget {
  const SettingsTabContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: SettingsTabContainerDesktop(),
      tabletBody: SettingsTabContainerDesktop(),
      mobileBody: SettingsTabContainerMobile(),
    );
  }
}
