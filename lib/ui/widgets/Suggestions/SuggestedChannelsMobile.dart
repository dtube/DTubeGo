import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserList.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestedChannelsMobile extends StatefulWidget {
  SuggestedChannelsMobile({Key? key, required this.avatarSize})
      : super(key: key);

  final double avatarSize;
  @override
  State<SuggestedChannelsMobile> createState() =>
      _SuggestedChannelsMobileState();
}

class _SuggestedChannelsMobileState extends State<SuggestedChannelsMobile> {
  late FeedBloc feedBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
        //bloc: feedBloc,
        builder: (context, state) {
      if (state is SuggestedUsersLoadingState) {
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading suggested users...",
          size: 20.w,
          width: 80.w,
        );
      } else if (state is SuggestedUsersLoadedState) {
        if (state.users.length > 0) {
          return Padding(
            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
            child: UserList(
              userlist: state.users,
              title: "Suggested Channels",
              showCount: true,
              avatarSize: widget.avatarSize,
            ),
          );
        } else {
          return SizedBox(height: 0, width: 0);
        }
      } else {
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading suggested users...",
          size: 20.w,
          width: 40.w,
        );
      }
    });
  }
}
