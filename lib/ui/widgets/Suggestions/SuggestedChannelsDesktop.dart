import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserList.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestedChannelsDesktop extends StatefulWidget {
  SuggestedChannelsDesktop({Key? key, required this.avatarSize})
      : super(key: key);

  final double avatarSize;
  @override
  State<SuggestedChannelsDesktop> createState() =>
      _SuggestedChannelsDesktopState();
}

class _SuggestedChannelsDesktopState extends State<SuggestedChannelsDesktop> {
  late FeedBloc feedBloc;
  ScrollController _scrollController = new ScrollController();

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
          size: 50,
          width: 50,
        );
      } else if (state is SuggestedUsersLoadedState) {
        if (state.users.length > 0) {
          return Container(
            width: 50.w,
            height: 30.h,
            child: SingleChildScrollView(
              child: UserList(
                userlist: state.users,
                title: "Suggested Channels",
                showCount: true,
                avatarSize: widget.avatarSize,
              ),
            ),
          );
        } else {
          return SizedBox(height: 0, width: 0);
        }
      } else {
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading suggested users...",
          size: 50,
          width: 50,
        );
      }
    });
  }
}
