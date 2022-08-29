import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardCard/RewardCard.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RewardsListDesktop extends StatefulWidget {
  const RewardsListDesktop({Key? key, required this.rewardsState})
      : super(key: key);
  final String rewardsState;

  @override
  _RewardsListDesktopState createState() => _RewardsListDesktopState();
}

class _RewardsListDesktopState extends State<RewardsListDesktop> {
  late RewardsBloc _rewardsBloc;

  @override
  void initState() {
    super.initState();
    _rewardsBloc = BlocProvider.of<RewardsBloc>(context);
    _rewardsBloc.add(FetchRewardsEvent(rewardState: widget.rewardsState));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardsBloc, RewardsState>(
      builder: (context, state) {
        if (state is RewardsLoadingState) {
          return DtubeLogoPulseWithSubtitle(
            subtitle: "loading rewards..",
            size: 10.w,
          );
        }
        if (state is RewardsLoadedState) {
          List<Reward> _rewards = state.rewardList;
          if (_rewards.isEmpty) {
            return Center(
                child: Text(
              "There are no rewards in this list",
              style: Theme.of(context).textTheme.headline4,
            ));
          } else {
            return MasonryGridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.zero,
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                key: new PageStorageKey(
                    'rewards' + widget.rewardsState + 'listview'),
                itemCount: _rewards.length,
                itemBuilder: (ctx, pos) {
                  return Center(
                    child: RewardCard(
                      reward: _rewards[pos],
                      parentWidget: this.widget,
                    ),
                  );
                });
          }
        }
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading rewards..",
          size: 10.w,
        );
      },
    );
  }
}
