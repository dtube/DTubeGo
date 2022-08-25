import 'package:dtube_go/ui/pages/search/ResultCards/UserResultCardDesktop.dart';
import 'package:dtube_go/ui/pages/search/ResultCards/UserResultCardMobile.dart';
import 'package:dtube_go/ui/pages/search/ResultCards/UserResultCardTablet.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';

import 'package:flutter/material.dart';

class UserResultCard extends StatelessWidget {
  const UserResultCard({
    Key? key,
    required this.id,
    required this.name,
    required this.dtcValue,
    required this.vpBalance,
  }) : super(key: key);

  final String id;
  final String name;
  final double dtcValue;
  final double vpBalance;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: UserResultCardDesktop(
          id: id, name: name, dtcValue: dtcValue, vpBalance: vpBalance),
      tabletBody: UserResultCardTablet(
          id: id, name: name, dtcValue: dtcValue, vpBalance: vpBalance),
      mobileBody: UserResultCardMobile(
          id: id, name: name, dtcValue: dtcValue, vpBalance: vpBalance),
    );
  }
}
