import 'package:flutter/material.dart';

class MomentsList extends StatelessWidget {
  MomentsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Moments coming soon!",
      style: Theme.of(context).textTheme.headline1,
    ));
  }
}
