import 'package:dtube_go/bloc/leaderboard/leaderboard_bloc_full.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/Leaderboard/Widgets/LeaderCard.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/Leaderboard/Widgets/LeaderCardDesktop.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaderboardDesktop extends StatefulWidget {
  const LeaderboardDesktop({
    Key? key,
  }) : super(key: key);

  @override
  _LeaderboardDesktopState createState() => _LeaderboardDesktopState();
}

class _LeaderboardDesktopState extends State<LeaderboardDesktop>
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
            builder: (context, LeaderboardState) {
      if (LeaderboardState is LeaderboardLoadingState) {
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading Leaderboard..",
          size: 30.w,
        );
      } else if (LeaderboardState is LeaderboardLoadedState) {
        return MasonryGridView.count(
            crossAxisCount: 4,
            padding: EdgeInsets.zero,
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            key: new PageStorageKey('Leaderboardlistview'),
            itemCount: LeaderboardState.leaderboardList.length,
            itemBuilder: (ctx, pos) {
              if (LeaderboardState.leaderboardList[pos].pubLeader != null) {
                return LeaderCardDesktop(
                  leaderItem: LeaderboardState.leaderboardList[pos],
                );
              } else {
                return SizedBox(
                  height: 0,
                );
              }
            });
      }

      return DtubeLogoPulseWithSubtitle(
        subtitle: "loading Leaderboard..",
        size: 30.w,
      );
    }));
  }
}
