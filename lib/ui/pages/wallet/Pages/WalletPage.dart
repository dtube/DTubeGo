import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/wallet/Widgets/transferDialog.dart';
import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({
    Key? key,
  }) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            showCustomFlushbarOnError(state.message, context);
          }
          if (state is TransactionSent) {
            showCustomFlushbarOnSuccess(state, context);
          }
        },
        child: Center(
          child: Column(
            children: [
              TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: globalAlmostWhite,
                indicatorColor: globalRed,
                tabs: [
                  Tab(
                    text: 'Transfer History',
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
                      // BlocProvider(
                      //     create: (context) =>
                      //         RewardsBloc(repository: RewardRepositoryImpl()),
                      //     child:
                      WalletHistoryList(

                          // )
                          ),

                      // BlocProvider(
                      //     create: (context) =>
                      //         RewardsBloc(repository: RewardRepositoryImpl()),
                      //     child: WalletHistoryList(

                      //     )),
                    ],
                    controller: _tabController,
                  ),
                ),
              ),
              //https://avalon.d.tube/votes/claimable/tibfox/0
            ],
          ),
        ));
  }
}

class WalletHistoryList extends StatefulWidget {
  const WalletHistoryList({Key? key}) : super(key: key);

  @override
  _WalletHistoryListState createState() => _WalletHistoryListState();
}

class _WalletHistoryListState extends State<WalletHistoryList> {
  late TransactionBloc _transactionBloc;

  @override
  void initState() {
    super.initState();
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InputChip(
            label: Text("new transfer"),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    TransferDialog(txBloc: _transactionBloc),
              );
            },
          ),
        ),
        Text("History will come soon"),
      ],
    );
  }
}
