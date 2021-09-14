import 'package:dtube_togo/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc.dart';
import 'package:dtube_togo/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/ui/pages/feeds/FeedViewBase.dart';
import 'package:dtube_togo/ui/pages/moments/MomentsListV2.dart';
import 'package:dtube_togo/ui/pages/moments/widgets/MomentsUpload.dart';
import 'package:dtube_togo/utils/ResponsiveLayout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';

import 'package:dtube_togo/style/styledCustomWidgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/controller/story_controller.dart';

class MomentsPage extends StatefulWidget {
  MomentsPage({Key? key}) : super(key: key);

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
  late StoryController storyController;
  int _selectedIndex = 0;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        print("Selected Index: " + _tabController.index.toString());
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
    storyController = new StoryController();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _iconSize = 5.w;

    return BlocBuilder<ThirdPartyUploaderBloc, ThirdPartyUploaderState>(
        builder: (context, state) {
      if (state is ThirdPartyUploaderUploadingState) {
        return Center(
            child: DTubeLogoPulse(size: MediaQuery.of(context).size.width / 3));
      } else {
        // return BlocBuilder<IPFSUploadBloc, IPFSUploadState>(
        //     builder: (context, state) {
        //   if (state is IPFSUploadVideoUploadedState ||
        //       state is IPFSUploadInitialState) {

        return Scaffold(
          //appBar: dtubeSubAppBar(true, "", context, null),
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              TabBarView(
                children: [
                  MomentsList(
                    feedType: 'NewMoments',
                    storyController: storyController,
                  ),
                  MomentsList(
                    feedType: 'FollowMoments',
                    storyController: storyController,
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
                  //padding: EdgeInsets.only(top: 5.h),
                  child: OverlayText(
                    text: _tabNames[_selectedIndex],
                    sizeMultiply: 1.4,
                    bold: true,
                  ),
                ),
              ),
              MomentsOverlay(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 5.w, top: 15.h),
                  width: 25.w,
                  height: 25.h,
                  child: MultiBlocProvider(
                      providers: [
                        BlocProvider<UserBloc>(
                          create: (BuildContext context) =>
                              UserBloc(repository: UserRepositoryImpl())
                                ..add(FetchDTCVPEvent()),
                        ),
                      ],
                      child: MomentsUploadButton(
                        defaultVotingWeight:
                            double.parse("25"), // TODO make it dynamic
                      )))
            ],
          ),
        );
        // } else {
        //   return Center(
        //       child: DTubeLogoPulse(
        //           size: MediaQuery.of(context).size.width / 3));
        // }
        // });
      }
    });
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
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[0],
                        color: Colors.white,
                        shadowColor: Colors.black,
                        size: iconSize),
                  ),
                ),
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[1],
                        color: Colors.white,
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
