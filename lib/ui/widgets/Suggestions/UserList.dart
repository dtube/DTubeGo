import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserListDesktop.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserListMobile.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserListTablet.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/ui/widgets/Suggestions/OtherUsersAvatar.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  UserList(
      {Key? key,
      required this.userlist,
      required this.title,
      required this.showCount,
      required this.avatarSize,
      this.crossAxisCount})
      : super(key: key);
  final List<String> userlist;
  final String title;
  final bool showCount;
  final double avatarSize;

  int? crossAxisCount;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: UserListDesktop(
          userlist: userlist,
          title: title,
          showCount: showCount,
          crossAxisCount: crossAxisCount!,
          avatarSize: avatarSize),
      mobileBody: UserListMobile(
          userlist: userlist,
          title: title,
          showCount: showCount,
          avatarSize: avatarSize),
      tabletBody: UserListTablet(
          userlist: userlist,
          title: title,
          showCount: showCount,
          crossAxisCount: crossAxisCount!,
          avatarSize: avatarSize),
    );
  }
}
