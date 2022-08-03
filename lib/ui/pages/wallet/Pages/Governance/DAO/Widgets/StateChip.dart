import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProposalStateChip extends StatefulWidget {
  ProposalStateChip(
      {Key? key,
      required this.daoItem,
      required this.daoThreshold,
      required this.phase,
      required this.status})
      : super(key: key);

  DAOItem daoItem;
  int daoThreshold;
  String phase;
  String status;

  @override
  State<ProposalStateChip> createState() => _ProposalStateChipState();
}

class _ProposalStateChipState extends State<ProposalStateChip> {
  @override
  Widget build(BuildContext context) {
    if (widget.phase == "voting") {
      if (widget.status == "open") {
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

    if (widget.phase == "funding") {
      if (widget.status == "open") {
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
    if (widget.phase == "execution") {
      if (widget.status == "open") {
        return InputChip(
            avatar: FaIcon(FontAwesomeIcons.hammer),
            backgroundColor: Colors.purple[600],
            onSelected: (bool) {},
            label: Text(
              'in progress',
              style: Theme.of(context).textTheme.caption,
            ));
      } else {
        if (widget.daoItem.status == 4) {
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
    }
    return Text("state unknown");
  }
}
