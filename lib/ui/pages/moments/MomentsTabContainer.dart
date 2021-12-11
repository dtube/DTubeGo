import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/moments/MomentsList.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/utils/ResponsiveLayout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MomentsPage extends StatefulWidget {
  bool play;
  MomentsPage({Key? key, required this.play}) : super(key: key);

  @override
  _MomentsPageState createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage>
    with SingleTickerProviderStateMixin {
  List<String> _tabNames = [
    "Global",
    "Followed",
  ];
  List<IconData> _tabIcons = [
    FontAwesomeIcons.globe,
    FontAwesomeIcons.userFriends,
  ];
  late TabController _tabController;
  // late StoryController storyController;
  int _selectedIndex = 0;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });

        switch (_selectedIndex) {
          case 0:
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchMomentsEvent(feedType: "NewMoments"));
            break;
          case 1:
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchMomentsEvent(feedType: "FollowMoments"));
            break;

          default:
        }
      }
    });

    super.initState();
    BlocProvider.of<FeedBloc>(context)
      ..isFetching = true
      ..add(FetchMomentsEvent(feedType: "NewMoments"));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _iconSize = 5.w;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.play
          ? Stack(
              children: [
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    MomentsList(
                      feedType: 'NewMoments',
                      goingInBackgroundCallback: () {
                        setState(() {
                          widget.play = false;
                        });
                      },
                      goingInForegroundCallback: () {
                        setState(() {
                          widget.play = true;
                        });
                      },
                    ),
                    MomentsList(
                      feedType: 'FollowMoments',
                      goingInBackgroundCallback: () {
                        setState(() {
                          widget.play = true;
                        });
                      },
                      goingInForegroundCallback: () {
                        setState(() {
                          widget.play = true;
                        });
                      },
                    ),
                  ],
                  controller: _tabController,
                ),
                ResponsiveLayout(
                  portrait: TabBarWithPosition(
                    tabIcons: _tabIcons,
                    iconSize: _iconSize,
                    tabController: _tabController,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 13.h, right: 4.w),
                    rotation: 0,
                    menuSize: 35.w,
                  ),
                  landscape: TabBarWithPosition(
                    tabIcons: _tabIcons,
                    iconSize: _iconSize,
                    tabController: _tabController,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    rotation: 3,
                    menuSize: 80.h,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 4.w),
                    child: OverlayText(
                      text: _tabNames[_selectedIndex],
                      sizeMultiply: 1.4,
                      bold: true,
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: 0,
              height: 0,
            ),
    );
  }
}

class TabBarWithPosition extends StatelessWidget {
  const TabBarWithPosition(
      {Key? key,
      required this.tabIcons,
      required this.iconSize,
      required this.tabController,
      required this.alignment,
      required this.padding,
      required this.rotation,
      required this.menuSize})
      : super(key: key);

  final List<IconData> tabIcons;
  final double iconSize;
  final TabController tabController;
  final Alignment alignment;
  final EdgeInsets padding;
  final int rotation;
  final double menuSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: RotatedBox(
          quarterTurns: rotation,
          child: Container(
            width: menuSize,
            child: TabBar(
              unselectedLabelColor: globalAlmostWhite,
              labelColor: globalAlmostWhite,
              indicatorColor: globalAlmostWhite,
              tabs: [
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[0],
                        color: globalAlmostWhite,
                        shadowColor: Colors.black,
                        size: iconSize),
                  ),
                ),
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[1],
                        color: globalAlmostWhite,
                        shadowColor: Colors.black,
                        size: iconSize),
                  ),
                ),
              ],
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
