import 'package:dtube_go/ui/pages/wallet/Pages/Wallet/transferDialog.dart';
import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
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
  late TransactionBloc _transactionBloc;

  @override
  void initState() {
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
    super.initState();
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
              Align(
                alignment: Alignment.topCenter,
                child: InputChip(
                  isEnabled: globals.keyPermissions.contains(3),
                  label: Text("new transfer",
                      style: Theme.of(context).textTheme.headline6),
                  backgroundColor: globalRed,
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          TransferDialog(txBloc: _transactionBloc),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WalletHistoryList(

                      // )
                      ),
                ),
              ),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Transfer History",
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
