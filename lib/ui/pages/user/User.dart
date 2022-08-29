import 'package:dtube_go/ui/pages/user/Layouts/UserDesktop.dart';
import 'package:dtube_go/ui/pages/user/Layouts/UserMobile.dart';
import 'package:dtube_go/ui/pages/user/Layouts/UserTablet.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';

import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  UserPage(
      {Key? key,
      this.username,
      required this.ownUserpage,
      this.alreadyFollowing,
      this.onPop})
      : super(key: key);
  String? username;
  final bool ownUserpage;
  bool? alreadyFollowing;
  VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: UserPageDesktop(
        ownUserpage: ownUserpage,
        username: username,
        onPop: onPop,
      ),
      mobileBody: UserPageMobile(
        ownUserpage: ownUserpage,
        username: username,
        onPop: onPop,
      ),
      tabletBody: UserPageTablet(
        ownUserpage: ownUserpage,
        username: username,
        onPop: onPop,
      ),
    );
  }
}
