import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_go/ui/widgets/gifts/GiftDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GiftboxWidget extends StatelessWidget {
  const GiftboxWidget({
    Key? key,
    required this.receiver,
    required this.link,
    required this.txBloc,
  }) : super(key: key);

  final String receiver;
  final String link;
  final TransactionBloc txBloc;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: globals.keyPermissions.contains(3),
      child: InputChip(
        label: FaIcon(FontAwesomeIcons.gift),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => GiftDialog(
              txBloc: txBloc,
              receiver: receiver,
              originLink: link,
            ),
          );
        },
      ),
    );
  }
}
