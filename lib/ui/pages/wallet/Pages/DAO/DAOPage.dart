import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/DAO/DaoList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DAOPage extends StatefulWidget {
  const DAOPage({
    Key? key,
  }) : super(key: key);

  @override
  _DAOPageState createState() => _DAOPageState();
}

class _DAOPageState extends State<DAOPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> pageNames = ["Fund Requests", "Chain Updates"];
  List<IconData> pagesIcons = [
    FontAwesomeIcons.magnifyingGlassDollar,
    FontAwesomeIcons.magnifyingGlassArrowRight
  ];

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 2, vsync: this);
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
              TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: globalAlmostWhite,
                indicatorColor: globalRed,
                isScrollable: true,
                tabs: [
                  Tab(
                    icon: FaIcon(
                      pagesIcons[0],
                      size: globalIconSizeSmall,
                    ),
                    text: "fund requests",
                  ),
                  Tab(
                    icon: FaIcon(pagesIcons[1], size: globalIconSizeSmall),
                    text: "chain updates",
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBarView(
                    children: [
                      DaoList(
                        daoState: "all",
                        daoType: "1",
                        daoVotingPeriod: state.config.daoVotingPeriodSeconds,
                        daoVotingThreshold: state.config.daoVotingThreshold,
                      ),
                      DaoList(
                        daoState: "all",
                        daoType: "2",
                        daoVotingPeriod: state.config.daoVotingPeriodSeconds,
                        daoVotingThreshold: state.config.daoVotingThreshold,
                      ),
                    ],
                    controller: _tabController,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Text("loading");
    });
  }
}
