import 'package:dtube_go/bloc/dao/dao_response_model.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';

class ProposalVoteOverview extends StatefulWidget {
  ProposalVoteOverview({
    Key? key,
    required this.daoItem,
  }) : super(key: key);

  final DAOItem daoItem;

  @override
  _ProposalVoteOverviewState createState() => _ProposalVoteOverviewState();
}

class _ProposalVoteOverviewState extends State<ProposalVoteOverview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopUpDialogWithTitleLogo(
        titleWidgetPadding: 5.w,
        titleWidgetSize: 20.w,
        callbackOK: () {},
        titleWidget: FaIcon(
          FontAwesomeIcons.checkToSlot,
          size: 10.w,
        ),
        showTitleWidget: true,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Text(
                "Vote Overview",
                style: Theme.of(context).textTheme.headline4,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: 60.h,
                    width: 100.w,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.daoItem.votes!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: !widget.daoItem.votes![index].veto!
                                          ? FaIcon(FontAwesomeIcons.thumbsUp)
                                          : FaIcon(FontAwesomeIcons.thumbsDown),
                                      width: 10.w,
                                    ),
                                    Container(
                                      child: Text(
                                        widget.daoItem.votes![index].voter!,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      width: 30.w,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(((widget.daoItem.votes![index]
                                                      .amount! >
                                                  99900
                                              ? (widget.daoItem.votes![index]
                                                              .amount! /
                                                          100000)
                                                      .toStringAsFixed(2) +
                                                  'K'
                                              : (widget.daoItem.votes![index]
                                                          .amount! /
                                                      100)
                                                  .toStringAsFixed(2)))),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Container(
                                                width: 5.w,
                                                height: 5.w,
                                                child: DTubeLogoShadowed(
                                                    size: globalIconSizeSmall)),
                                          ),
                                        ],
                                      ),
                                      width: 25.w,
                                    ),
                                  ],
                                ));
                          }),
                    ),
                  ),
                ),
              ),
              InkWell(
                  child: Container(
                    width: 100.w,
                    padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    decoration: BoxDecoration(
                      color: globalRed,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                    ),
                    child: Text(
                      "Thanks",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        }));

    //   }),
    // );
  }
}
