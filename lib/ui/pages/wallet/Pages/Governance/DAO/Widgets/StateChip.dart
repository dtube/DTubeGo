import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProposalStateChip extends StatefulWidget {
  ProposalStateChip({
    Key? key,
    required this.daoItem,
    required this.daoThreshold,
  }) : super(key: key);

  DAOItem daoItem;
  int daoThreshold;

  @override
  State<ProposalStateChip> createState() => _ProposalStateChipState();
}

class _ProposalStateChipState extends State<ProposalStateChip> {
  @override
  Widget build(BuildContext context) {
    if ([0, 1].contains(widget.daoItem.status!)) {
      if (widget.daoItem.status == 0) {
        return InputChip(
            avatar: FaIcon(FontAwesomeIcons.checkToSlot),
            onSelected: (bool) {},
            backgroundColor: Colors.green[800],
            label: Text(
              'voting phase',
              style: Theme.of(context).textTheme.caption,
            ));
      } else {
        return InputChip(
            avatar: FaIcon(FontAwesomeIcons.lock),
            backgroundColor: Colors.red[800],
            onSelected: (bool) {},
            label: Text(
              'voting failed',
              style: Theme.of(context).textTheme.caption,
            ));
      }
    }

    if ([2, 4].contains(widget.daoItem.status!)) {
      if ([2].contains(widget.daoItem.status!)) {
        return InputChip(
            avatar: FaIcon(FontAwesomeIcons.arrowUpFromBracket),
            backgroundColor: Colors.orange[800],
            onSelected: (bool) {},
            label: Text(
              'funding phase',
              style: Theme.of(context).textTheme.caption,
            ));
      } else {
        return InputChip(
            avatar: FaIcon(FontAwesomeIcons.arrowUpFromBracket),
            backgroundColor: Colors.red[800],
            onSelected: (bool) {},
            label: Text(
              'funding failed',
              style: Theme.of(context).textTheme.caption,
            ));
      }
    }
    if ([3, 5, 6, 8].contains(widget.daoItem.status)) {
      if ([3, 5, 8].contains(widget.daoItem.status)) {
        return InputChip(
            avatar: FaIcon(FontAwesomeIcons.hammer),
            backgroundColor: Colors.purple[600],
            onSelected: (bool) {},
            label: Text(
              'in progress',
              style: Theme.of(context).textTheme.caption,
            ));
      } else {
        return InputChip(
            avatar: FaIcon(FontAwesomeIcons.check),
            backgroundColor: Colors.purple[600],
            onSelected: (bool) {},
            label: Text(
              'completed',
              style: Theme.of(context).textTheme.caption,
            ));
      }
    }
    if (widget.daoItem.status == 7) {
      return InputChip(
          avatar: FaIcon(FontAwesomeIcons.hammer),
          backgroundColor: Colors.red[600],
          onSelected: (bool) {},
          label: Text(
            'expired',
            style: Theme.of(context).textTheme.caption,
          ));
    }
    return Text("state unknown");
  }
}
