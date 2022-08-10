import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/bloc/dao/dao_bloc.dart';
import 'package:dtube_go/bloc/dao/dao_repository.dart';
import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/Governance.dart';

import 'package:dtube_go/ui/pages/wallet/Pages/KeyManagement/KeyManagement.dart';

import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardsPage.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Wallet/WalletPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WalletMainPage extends StatefulWidget {
  WalletMainPage({Key? key}) : super(key: key);

  @override
  _WalletMainPageState createState() => _WalletMainPageState();
}

class _WalletMainPageState extends State<WalletMainPage>
    with SingleTickerProviderStateMixin {
  List<String> walletPages = ["Rewards", "Wallet", "Keys", "Governance"];
  List<IconData> walletPagesIcons = [
    FontAwesomeIcons.coins,
    FontAwesomeIcons.paperPlane,
    FontAwesomeIcons.key,
    FontAwesomeIcons.checkToSlot
  ];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: dtubeSubAppBar(false, "", context, null),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          SizedBox(height: 7.h),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 10.w,
                  child: Center(
                    child: InkWell(
                      child: FaIcon(FontAwesomeIcons.arrowLeft),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 8.h,
                  width: 80.w,
                  child: Center(
                    child: TabBar(
                      labelPadding: EdgeInsets.all(8.9),
                      unselectedLabelColor: Colors.grey,
                      labelColor: globalAlmostWhite,
                      indicatorColor: globalRed,
                      isScrollable: true,
                      tabs: [
                        Tab(
                          text: walletPages[0],
                          icon: FaIcon(
                            walletPagesIcons[0],
                            size: globalIconSizeSmall,
                          ),
                        ),
                        Tab(
                          text: walletPages[1],
                          icon: FaIcon(
                            walletPagesIcons[1],
                            size: globalIconSizeSmall,
                          ),
                        ),
                        Tab(
                          text: walletPages[2],
                          icon: FaIcon(
                            walletPagesIcons[2],
                            size: globalIconSizeSmall,
                          ),
                        ),
                        Tab(
                          text: walletPages[3],
                          icon: FaIcon(
                            walletPagesIcons[3],
                            size: globalIconSizeSmall,
                          ),
                        ),
                      ],
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                children: [
                  BlocProvider(
                    create: (context) =>
                        RewardsBloc(repository: RewardRepositoryImpl()),
                    child: RewardsPage(),
                  ),
                  WalletPage(),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          create: (context) => TransactionBloc(
                              repository: TransactionRepositoryImpl())),
                      BlocProvider(
                          create: (context) =>
                              UserBloc(repository: UserRepositoryImpl())
                                ..add(FetchMyAccountDataEvent())),
                    ],
                    child: KeyManagementPage(),
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          create: (context) => AvalonConfigBloc(
                              repository: AvalonConfigRepositoryImpl())
                            ..add(FetchAvalonConfigEvent())),
                    ],
                    child: GovernancePage(),
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
}
