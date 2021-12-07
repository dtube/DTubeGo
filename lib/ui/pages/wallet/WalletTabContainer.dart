import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';

import 'package:dtube_go/ui/pages/wallet/Pages/RewardsPage.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/WalletPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletMainPage extends StatefulWidget {
  WalletMainPage({Key? key}) : super(key: key);

  @override
  _WalletMainPageState createState() => _WalletMainPageState();
}

class _WalletMainPageState extends State<WalletMainPage>
    with SingleTickerProviderStateMixin {
  List<String> uploadOptions = ["Wallet", "Rewards"];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dtubeSubAppBar(true, "", context, null),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: globalAlmostWhite,
            indicatorColor: globalRed,
            tabs: [
              Tab(
                text: 'Rewards',
              ),
              Tab(
                text: 'Wallet',
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
                  BlocProvider(
                    create: (context) =>
                        RewardsBloc(repository: RewardRepositoryImpl()),
                    child: RewardsPage(),
                  ),
                  WalletPage(),
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
