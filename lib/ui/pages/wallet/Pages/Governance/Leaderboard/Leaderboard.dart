import 'package:dtube_go/bloc/leaderboard/leaderboard_bloc_full.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/Leaderboard/LeaderCard.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({
    Key? key,
  }) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with SingleTickerProviderStateMixin {
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
    }, child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
            builder: (context, leaderboardState) {
      if (leaderboardState is LeaderboardLoadingState) {
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading leaderboard..",
          size: 30.w,
        );
      } else if (leaderboardState is LeaderboardLoadedState) {
        return ListView.builder(
            padding: EdgeInsets.zero,
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            key: new PageStorageKey('leaderboardlistview'),
            itemCount: leaderboardState.leaderboardList.length,
            itemBuilder: (ctx, pos) {
              if (leaderboardState.leaderboardList[pos].pubLeader != null) {
                return LeaderCard(
                  leaderItem: leaderboardState.leaderboardList[pos],
                );
              } else {
                return SizedBox(
                  height: 0,
                );
              }
            });
      }

      return Text("loading");
    }));
  }
}
