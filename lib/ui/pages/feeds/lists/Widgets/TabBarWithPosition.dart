import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabBarWithPosition extends StatefulWidget {
  const TabBarWithPosition(
      {Key? key,
      required this.tabIcons,
      required this.iconSize,
      required this.tabController,
      required this.alignment,
      required this.padding,
      required this.menuSize,
      required this.showLabels,
      required this.tabNames})
      : super(key: key);

  final List<IconData> tabIcons;
  final double iconSize;
  final TabController tabController;
  final Alignment alignment;
  final EdgeInsets padding;
  final double menuSize;
  final bool showLabels;
  final List<String> tabNames;

  @override
  State<TabBarWithPosition> createState() => _TabBarWithPositionState();
}

class _TabBarWithPositionState extends State<TabBarWithPosition> {
  late List<Tab> tabs;

  @override
  void initState() {
    tabs = [
      Tab(
        child: ShadowedIcon(
            icon: widget.tabIcons[0],
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: widget.iconSize),
      ),
      Tab(
        child: ShadowedIcon(
            icon: widget.tabIcons[1],
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: widget.iconSize),
      ),
      Tab(
        child: ShadowedIcon(
            icon: widget.tabIcons[2],
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: widget.iconSize),
      ),
      Tab(
        child: ShadowedIcon(
            icon: widget.tabIcons[3],
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: widget.iconSize),
      ),
      Tab(
        child: ShadowedIcon(
            icon: widget.tabIcons[4],
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: widget.iconSize),
      ),
    ];
    if (widget.showLabels) {
      tabs = [
        Tab(
          text: widget.tabNames[0],
          icon: ShadowedIcon(
              icon: widget.tabIcons[0],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
        Tab(
          text: widget.tabNames[1],
          icon: ShadowedIcon(
              icon: widget.tabIcons[1],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
        Tab(
          text: widget.tabNames[2],
          icon: FaIcon(widget.tabIcons[2],
              color: globalAlmostWhite,
              // shadowColor: Colors.black,
              size: widget.iconSize),
        ),
        Tab(
          text: widget.tabNames[3],
          icon: ShadowedIcon(
              icon: widget.tabIcons[3],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
        Tab(
          text: widget.tabNames[4],
          icon: ShadowedIcon(
              icon: widget.tabIcons[4],
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: widget.iconSize),
        ),
      ];
    }
    if (globals.keyPermissions.isEmpty) {
      tabs.removeAt(2);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: widget.padding,
        child: !widget.showLabels
            ? Container(
                width: widget.menuSize,
                child: TabBar(
                  unselectedLabelColor: globalAlmostWhite,
                  labelColor: globalAlmostWhite,
                  indicatorColor: globalAlmostWhite,
                  tabs: tabs,
                  controller: widget.tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.zero,
                ),
              )
            : Container(
                child: TabBar(
                  // unselectedLabelColor: globalAlmostWhite,
                  labelColor: globalAlmostWhite,
                  indicatorColor: globalAlmostWhite,
                  isScrollable: true,
                  tabs: tabs,
                  controller: widget.tabController,

                  labelStyle: Theme.of(context).textTheme.bodyText1!,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.only(right: 10),
                ),
              ),
      ),
    );
  }
}
