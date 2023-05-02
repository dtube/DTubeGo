import 'package:dtube_go/ui/pages/feeds/lists/Widgets/TabBarWithPosition.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/FeedViewBase.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedTabs extends StatelessWidget {
  const FeedTabs({
    Key? key,
    required this.tabBarFeedItemList,
    required this.tabBarFeedItemListUnsignedLogin,
    required this.tabController,
    required this.tabIcons,
    required this.tabNames,
    required this.tabIconsUnsignedLogin,
    required this.tabNamesUnsignedLogin,
    required this.selectedIndex,
  }) : super(key: key);

  final List<FeedViewBase> tabBarFeedItemList;
  final List<FeedViewBase> tabBarFeedItemListUnsignedLogin;
  final TabController tabController;
  final List<IconData> tabIcons;
  final List<String> tabNames;
  final List<IconData> tabIconsUnsignedLogin;
  final List<String> tabNamesUnsignedLogin;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TabBarView(
          children: globals.keyPermissions.isEmpty
              ? tabBarFeedItemListUnsignedLogin
              : tabBarFeedItemList,
          controller: tabController,
        ),
        TabBarWithPosition(
          tabIcons:
              globals.keyPermissions.isEmpty ? tabIconsUnsignedLogin : tabIcons,
          iconSize: globalIconSizeMedium,
          tabController: tabController,
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(top: 11.h, right: 4.w),
          tabNames:
              globals.keyPermissions.isEmpty ? tabNamesUnsignedLogin : tabNames,
          showLabels: false,
          menuSize: globals.keyPermissions.isEmpty
              ? globalIconSizeMedium * 6
              : globalIconSizeMedium * 8,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 6.h, left: 4.w),
            //padding: EdgeInsets.only(top: 5.h),
            child: OverlayText(
              text: tabNames[selectedIndex],
              sizeMultiply: 1.4,
              bold: true,
            ),
          ),
        )
      ],
    );
  }
}
