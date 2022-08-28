import 'package:dtube_go/ui/widgets/Suggestions/SuggestedChannelsDesktop.dart';
import 'package:dtube_go/ui/widgets/Suggestions/SuggestedChannelsMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/widgets/Suggestions/UserList.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestedChannels extends StatelessWidget {
  const SuggestedChannels({Key? key, required this.avatarSize})
      : super(key: key);
  final double avatarSize;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: SuggestedChannelsDesktop(avatarSize: avatarSize),
      mobileBody: SuggestedChannelsMobile(avatarSize: avatarSize),
      tabletBody: SuggestedChannelsDesktop(avatarSize: avatarSize),
    );
  }
}
