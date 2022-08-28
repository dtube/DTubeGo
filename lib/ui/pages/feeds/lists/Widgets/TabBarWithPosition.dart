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
    tabs = List<Tab>.generate(
      widget.tabIcons.length,
      (int index) => !widget.showLabels
          ? Tab(
              child: ShadowedIcon(
                  icon: widget.tabIcons[index],
                  color: globalAlmostWhite,
                  shadowColor: Colors.black,
                  size: widget.iconSize),
            )
          : Tab(
              text: widget.tabNames[index],
              icon: ShadowedIcon(
                  icon: widget.tabIcons[index],
                  color: globalAlmostWhite,
                  shadowColor: Colors.black,
                  size: widget.iconSize),
            ),
    );

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
