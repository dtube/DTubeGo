import 'package:dtube_go/ui/pages/feeds/lists/Widgets/TabBarWithPosition.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/FeedTabContainer.dart';
import 'package:dtube_go/ui/pages/feeds/FeedViewBase.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedTabsDesktop extends StatelessWidget {
  const FeedTabsDesktop({
    Key? key,
    required this.tabBarFeedItemList,
    required this.tabController,
    required this.tabIcons,
    required this.tabNames,
    required this.selectedIndex,
  }) : super(key: key);

  final List<FeedViewBase> tabBarFeedItemList;
  final TabController tabController;
  final List<IconData> tabIcons;
  final List<String> tabNames;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 80),
          child: TabBarView(
            children: tabBarFeedItemList,
            controller: tabController,
          ),
        ),
        TabBarWithPosition(
          tabIcons: tabIcons,
          iconSize: globalIconSizeMedium,
          tabController: tabController,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 0),
          tabNames: tabNames,
          showLabels: true,
          menuSize: globals.keyPermissions.isEmpty ? 200 : 250,
        ),
      ],
    );
  }
}
