import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteOverview/VoteOverview.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:dtube_go/utils/Strings/shortBalanceStrings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../bloc/postdetails/postdetails_bloc_full.dart';

class DtubeCoinsChip extends StatelessWidget {
  const DtubeCoinsChip(
      {Key? key, required this.dist, required this.post, required this.width})
      : super(key: key);

  final double dist;
  final Post post;
  final double width;
  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            (dist / 100).round().toString(),
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: DTubeLogoShadowed(size: width),
          ),
        ],
      ),
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => VotesOverview(post: post),
        );
      },
    );
  }
}
