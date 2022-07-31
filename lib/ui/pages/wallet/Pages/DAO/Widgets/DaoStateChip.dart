import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DaoStateChip extends StatefulWidget {
  DaoStateChip({Key? key, required this.daoItem, required this.daoThreshold})
      : super(key: key);

  DAOItem daoItem;
  int daoThreshold;

  @override
  State<DaoStateChip> createState() => _DaoStateChipState();
}

class _DaoStateChipState extends State<DaoStateChip> {
  @override
  Widget build(BuildContext context) {
    if (DateTime.fromMillisecondsSinceEpoch(widget.daoItem.votingEnds!)
            .compareTo(DateTime.now()) >
        0) {
      return InputChip(
          avatar: FaIcon(FontAwesomeIcons.checkToSlot),
          onSelected: (bool) {},
          backgroundColor: Colors.green[800],
          label: Text(
            'voting phase',
            style: Theme.of(context).textTheme.caption,
          ));
    } else {
      if (widget.daoItem.approvals! < widget.daoThreshold) {
        return InputChip(
            avatar: FaIcon(FontAwesomeIcons.lock),
            backgroundColor: Colors.red[800],
            onSelected: (bool) {},
            label: Text(
              'voting failed',
              style: Theme.of(context).textTheme.caption,
            ));
      } else {
        if (DateTime.fromMillisecondsSinceEpoch(widget.daoItem.fundingEnds!)
                    .compareTo(DateTime.now()) >
                0 &&
            widget.daoItem.raised! < widget.daoItem.requested!) {
          return InputChip(
              avatar: FaIcon(FontAwesomeIcons.arrowUpFromBracket),
              backgroundColor: Colors.orange[800],
              onSelected: (bool) {},
              label: Text(
                'funding phase',
                style: Theme.of(context).textTheme.caption,
              ));
        } else {
          if (widget.daoItem.raised! < widget.daoItem.requested!) {
            return InputChip(
                avatar: FaIcon(FontAwesomeIcons.arrowUpFromBracket),
                backgroundColor: Colors.red[800],
                onSelected: (bool) {},
                label: Text(
                  'funding failed',
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
            } else {
              return InputChip(
                  avatar: FaIcon(FontAwesomeIcons.hammer),
                  backgroundColor: Colors.purple[600],
                  onSelected: (bool) {},
                  label: Text(
                    'in progress',
                    style: Theme.of(context).textTheme.caption,
                  ));
            }
          }
        }
      }
    }
  }
}
