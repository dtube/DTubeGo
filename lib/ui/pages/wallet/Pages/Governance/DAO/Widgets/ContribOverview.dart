import 'package:dtube_go/bloc/dao/dao_response_model.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';

class ProposalContribOverview extends StatefulWidget {
  ProposalContribOverview({
    Key? key,
    required this.daoItem,
  }) : super(key: key);

  DAOItem daoItem;

  @override
  _ProposalContribOverviewState createState() =>
      _ProposalContribOverviewState();
}

class _ProposalContribOverviewState extends State<ProposalContribOverview> {
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
                "Conribution Overview",
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
                          itemCount: widget.daoItem.contrib!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      child: Text(
                                        widget.daoItem.contrib![index]
                                            .contribName!,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      width: 30.w,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text((widget.daoItem.contrib![index]
                                                      .contribAmount! /
                                                  100)
                                              .toString()),
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
                                      width: 30.w,
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
