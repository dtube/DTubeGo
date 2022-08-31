import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/Widgets/PieChart.dart';
import 'package:flutter/material.dart';

class ProposalStateChart extends StatefulWidget {
  ProposalStateChart({
    Key? key,
    required this.daoItem,
    required this.votingThreshold,
    required this.height,
    required this.width,
    required this.outerRadius,
    required this.centerRadius,
    required this.startFromDegree,
    this.showLabels,
    this.raisedLabel,
    required this.onTap,
  }) : super(key: key);
  final DAOItem daoItem;
  final int votingThreshold;
  final double height;
  final double width;
  final double centerRadius;
  final double outerRadius;
  final double startFromDegree;
  final bool? showLabels;
  final String? raisedLabel;
  final VoidCallback onTap;

  @override
  State<ProposalStateChart> createState() => _ProposalStateChartState();
}

class _ProposalStateChartState extends State<ProposalStateChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // proposal is in voting phase
    return PiChart(
      goalValue: [0, 1].contains(widget.daoItem.status)
          ? widget.votingThreshold
          : widget.daoItem.requested != null
              ? widget.daoItem.requested!
              : 0,
      receivedValue: [0, 1].contains(widget.daoItem.status)
          ? widget.daoItem.approvals!
          : widget.daoItem.raised!,
      centerRadius: widget.centerRadius,
      height: widget.height,
      outerRadius: widget.outerRadius,
      startFromDegree: widget.startFromDegree,
      width: widget.width,
      showLabels: widget.showLabels == null ? false : widget.showLabels!,
      raisedLabel: widget.raisedLabel == null ? '' : widget.raisedLabel!,
      onTapCallback: widget.onTap,
    );
  }
}
