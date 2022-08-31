import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/leaderboard/leaderboard_bloc_full.dart';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/ProposalList/ProposalList.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/Leaderboard/Leaderboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DAO extends StatefulWidget {
  const DAO({
    Key? key,
  }) : super(key: key);

  @override
  _DAOState createState() => _DAOState();
}

class _DAOState extends State<DAO> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tabControllerFR;
  late TabController _tabControllerCU;

  List<String> pageNames = ["Fund Requests", "Chain Updates", "Leaderboard"];
  List<IconData> pagesIcons = [
    FontAwesomeIcons.magnifyingGlassDollar,
    FontAwesomeIcons.magnifyingGlassArrowRight,
    FontAwesomeIcons.server
  ];

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 3, vsync: this);
    _tabControllerFR = new TabController(length: 3, vsync: this);
    _tabControllerCU = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvalonConfigBloc, AvalonConfigState>(
        builder: (context, state) {
      if (state is AvalonConfigLoadingState) {
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading avalon config values..",
          size: 30.w,
        );
      } else if (state is AvalonConfigLoadedState) {
        return Center(
          child: Column(
            children: [
              Container(
                height: 3.h,
                child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: globalAlmostWhite,
                  indicatorColor: globalRed,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: pageNames[0],
                    ),
                    Tab(
                      text: pageNames[1],
                    ),
                    Tab(
                      text: pageNames[2],
                    ),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBarView(
                    children: [
                      Column(children: [
                        StateTabBar(tabControllerFR: _tabControllerFR),
                        StateTabBarView(
                          tabController: _tabControllerFR,
                          daoType: 1,
                          daoVotingPeriodSeconds:
                              state.config.daoVotingPeriodSeconds,
                          daoVotingThreshold: state.config.daoVotingThreshold,
                        ),
                      ]),
                      Column(children: [
                        StateTabBar(tabControllerFR: _tabControllerCU),
                        StateTabBarView(
                          tabController: _tabControllerCU,
                          daoType: 2,
                          daoVotingPeriodSeconds:
                              state.config.daoVotingPeriodSeconds,
                          daoVotingThreshold: state.config.daoVotingThreshold,
                        ),
                      ]),
                      MultiBlocProvider(providers: [
                        BlocProvider(
                            create: (context) =>
                                UserBloc(repository: UserRepositoryImpl())
                                  ..add(FetchMyAccountDataEvent())),
                        BlocProvider(
                            create: (context) => LeaderboardBloc(
                                repository: LeaderboardRepositoryImpl())
                              ..add(FetchLeaderboardEvent())),
                      ], child: Leaderboard())
                    ],
                    controller: _tabController,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return DtubeLogoPulseWithSubtitle(
        subtitle: "loading avalon config values..",
        size: 30.w,
      );
    });
  }
}

class StateTabBarView extends StatelessWidget {
  const StateTabBarView(
      {Key? key,
      required this.daoType,
      required this.daoVotingPeriodSeconds,
      required this.daoVotingThreshold,
      required this.tabController})
      : super(key: key);

  final TabController tabController;
  final int daoType;
  final int daoVotingPeriodSeconds;
  final int daoVotingThreshold;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(controller: tabController, children: [
        BlocProvider(
          create: (context) => DaoBloc(repository: DaoRepositoryImpl()),
          child: ProposalList(
            daoState: "0",
            daoType: daoType.toString(),
            daoVotingPeriod: daoVotingPeriodSeconds,
            daoVotingThreshold: daoVotingThreshold,
          ),
        ),
        BlocProvider(
          create: (context) => DaoBloc(repository: DaoRepositoryImpl()),
          child: ProposalList(
            daoState: "1",
            daoType: daoType.toString(),
            daoVotingPeriod: daoVotingPeriodSeconds,
            daoVotingThreshold: daoVotingThreshold,
          ),
        ),
        BlocProvider(
          create: (context) => DaoBloc(repository: DaoRepositoryImpl()),
          child: ProposalList(
            daoState: "2",
            daoType: daoType.toString(),
            daoVotingPeriod: daoVotingPeriodSeconds,
            daoVotingThreshold: daoVotingThreshold,
          ),
        ),
      ]),
    );
  }
}

class StateTabBar extends StatelessWidget {
  const StateTabBar({
    Key? key,
    required TabController tabControllerFR,
  })  : _tabControllerFR = tabControllerFR,
        super(key: key);

  final TabController _tabControllerFR;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.w,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabControllerFR,
        unselectedLabelColor: Colors.grey,
        labelColor: globalAlmostWhite,
        indicatorColor: globalRed,
        isScrollable: true,
        tabs: [
          Tab(
            text: "Open",
          ),
          Tab(
            text: "Failed",
          ),
          Tab(
            text: "Executed",
          )
        ],
      ),
    );
  }
}
