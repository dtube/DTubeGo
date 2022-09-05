import 'package:dtube_go/ui/widgets/Suggestions/SuggestedChannels/SuggestedChannelsDesktop.dart';
import 'package:dtube_go/ui/widgets/Suggestions/SuggestedChannels/SuggestedChannelsMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserList.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestedChannels extends StatelessWidget {
  SuggestedChannels({Key? key, required this.avatarSize, this.crossAxisCount})
      : super(key: key);
  final double avatarSize;

  int? crossAxisCount;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: SuggestedChannelsDesktop(
        avatarSize: avatarSize,
        crossAxisCount: crossAxisCount != null ? crossAxisCount! : 1,
      ),
      mobileBody: SuggestedChannelsMobile(avatarSize: avatarSize),
      tabletBody: SuggestedChannelsDesktop(
        avatarSize: avatarSize,
        crossAxisCount: crossAxisCount != null ? crossAxisCount! : 1,
      ),
    );
  }
}
