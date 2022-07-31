import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/DAO/PieChart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DaoStateChart extends StatefulWidget {
  DaoStateChart(
      {Key? key, required this.daoItem, required this.votingThreshold})
      : super(key: key);
  DAOItem daoItem;
  final int votingThreshold;

  @override
  State<DaoStateChart> createState() => _DaoStateChartState();
}

class _DaoStateChartState extends State<DaoStateChart> {
  @override
  Widget build(BuildContext context) {
    if (DateTime.fromMillisecondsSinceEpoch(widget.daoItem.votingEnds!)
            .compareTo(DateTime.now()) >
        0) {
      // proposal is in voting phase
      return PiChart(
          goalValue: widget.votingThreshold,
          receivedValue: widget.daoItem.approvals!);
    } else {
      if (widget.daoItem.approvals! < widget.votingThreshold) {
        // proposal failed in voting phase
        return SizedBox(
          height: 0,
          width: 0,
        );
      } else {
        if (DateTime.fromMillisecondsSinceEpoch(widget.daoItem.fundingEnds!)
                    .compareTo(DateTime.now()) >
                0 &&
            widget.daoItem.raised! < widget.daoItem.requested!) {
          // proposal is in funding phase
          return PiChart(
              goalValue: widget.daoItem.requested!,
              receivedValue: widget.daoItem.raised!);
        } else {
          if (widget.daoItem.raised! < widget.daoItem.requested!) {
            // proposal failed in funding phase
            return PiChart(
                goalValue: widget.daoItem.requested!,
                receivedValue: widget.daoItem.raised!);
          } else {
            if (widget.daoItem.status == 4) {
              // proposal is completed
              return SizedBox(
                height: 0,
                width: 0,
              );
            } else {
              // proposal is being completed
              return SizedBox(
                height: 0,
                width: 0,
              );
            }
          }
        }
      }
    }
  }
}
