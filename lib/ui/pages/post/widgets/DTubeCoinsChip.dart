import 'package:dtube_go/style/ThemeData.dart';
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
  const DtubeCoinsChip({
    Key? key,
    required this.dist,
    required this.post,
  }) : super(key: key);

  final double dist;
  final Post post;
  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Row(
        children: [
          Text(
            (dist / 100).round().toString(),
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: DTubeLogoShadowed(size: 5.w),
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

class VotesOverview extends StatefulWidget {
  VotesOverview({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;

  @override
  _VotesOverviewState createState() => _VotesOverviewState();
}

class _VotesOverviewState extends State<VotesOverview> {
  List<Votes> _allVotes = [];

  @override
  void initState() {
    super.initState();
    _allVotes = widget.post.upvotes!;
    if (widget.post.downvotes != null) {
      _allVotes = _allVotes + widget.post.downvotes!;
    }
    // sorting the list would be perhaps useful
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      backgroundColor: globalAlmostBlack,
      content: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: 45.h,
              width: 90.w,
              child: ListView.builder(
                itemCount: _allVotes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 10.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              navigateToUserDetailPage(
                                  context, _allVotes[index].u, () {});
                            },
                            child: Row(
                              children: [
                                Container(
                                    height: 10.w,
                                    width: 10.w,
                                    child: AccountIconBase(
                                      avatarSize: 10.w,
                                      showVerified: true,
                                      username: _allVotes[index].u,
                                    )),
                                SizedBox(width: 2.w),
                                Container(
                                  width: 30.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _allVotes[index].u,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Text(
                                        TimeAgo.timeInAgoTSShort(
                                            _allVotes[index].ts),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FaIcon(_allVotes[index].vt > 0
                              ? FontAwesomeIcons.heart
                              : FontAwesomeIcons.flag),
                          Container(
                            width: 20.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          (_allVotes[index].claimable != null
                                              ? shortDTC(_allVotes[index]
                                                  .claimable!
                                                  .floor())
                                              : "0"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Container(
                                          width: 5.w,
                                          child: Center(
                                            child: DTubeLogoShadowed(size: 5.w),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          shortVP(_allVotes[index].vt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Container(
                                          width: 5.w,
                                          child: Center(
                                            child: ShadowedIcon(
                                              icon: FontAwesomeIcons.bolt,
                                              shadowColor: Colors.black,
                                              color: globalAlmostWhite,
                                              size: 5.w,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
            // ),
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        InputChip(
          backgroundColor: globalRed,
          onPressed: () async {
            Navigator.of(context).pop();
          },
          label: Text(
            'Close',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }
}
