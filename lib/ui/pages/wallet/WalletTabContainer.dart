import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_togo/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/thirdpartyloader/thirdpartyloader_bloc_full.dart';
import 'package:dtube_togo/bloc/thirdpartyloader/thirdpartyloader_repository.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/upload/3rdparty.dart';
import 'package:dtube_togo/ui/pages/upload/ipfs.dart';
import 'package:dtube_togo/ui/pages/wallet/RewardsPage.dart';
import 'package:dtube_togo/ui/pages/wallet/WalletPage.dart';
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
      appBar: dtubeSubAppBar(),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: globalAlmostWhite,
            indicatorColor: globalRed,
            tabs: [
              Tab(
                text: 'Wallet',
              ),
              Tab(
                text: 'Rewards',
              )
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
                    create: (context) => TransactionBloc(
                        repository: TransactionRepositoryImpl()),
                    child: WalletPage(),
                  ),
                  BlocProvider(
                    create: (context) =>
                        RewardsBloc(repository: RewardRepositoryImpl()),
                    child: RewardsPage(),
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
