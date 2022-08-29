import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Rewards/RewardCard/RewardCard.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RewardsListMobile extends StatefulWidget {
  const RewardsListMobile({Key? key, required this.rewardsState})
      : super(key: key);
  final String rewardsState;

  @override
  _RewardsListMobileState createState() => _RewardsListMobileState();
}

class _RewardsListMobileState extends State<RewardsListMobile> {
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
            size: 30.w,
          );
        }
        if (state is RewardsLoadedState) {
          List<Reward> _rewards = state.rewardList;
          if (_rewards.isEmpty) {
            return Center(
                child: Text(
              "nothing here",
              style: Theme.of(context).textTheme.bodyText1,
            ));
          } else {
            return ListView.builder(
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
          size: 30.w,
        );
      },
    );
  }
}
