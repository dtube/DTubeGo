import 'dart:async';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BalanceOverview extends StatefulWidget {
  const BalanceOverview({
    Key? key,
  }) : super(key: key);

  @override
  _BalanceOverviewState createState() => _BalanceOverviewState();
}

class _BalanceOverviewState extends State<BalanceOverview> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchDTCVPEvent()); // statements;
    const oneSec = const Duration(seconds: 240);
    new Timer.periodic(oneSec, (Timer t) {
      _userBloc.add(FetchDTCVPEvent());
    });
    // Do something
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBloc,
      builder: (context, state) {
        if (state is UserInitialState) {
          return SizedBox(width: 0);
        } else if (state is UserDTCVPLoadingState) {
          return SizedBox(width: 0);
        } else if (state is UserDTCVPLoadedState) {
          double _dtcBalanceK = state.dtcBalance / 100000;
          double _vpBalanceK = state.vtBalance["v"]! / 1000;
          try {
            return Column(
                //mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Center(
                    child: Text(
                      (state.dtcBalance < 100000
                                  ? state.dtcBalance / 100
                                  : _dtcBalanceK >= 1000
                                      ? _dtcBalanceK / 1000
                                      : _dtcBalanceK)
                              .toStringAsFixed(1) +
                          (state.dtcBalance < 10000
                              ? ""
                              : _dtcBalanceK >= 1000
                                  ? 'M'
                                  : 'K') +
                          "DTC",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Text(
                    (_vpBalanceK >= 1000 ? _vpBalanceK / 1000 : _vpBalanceK)
                            .toStringAsFixed(1) +
                        (_vpBalanceK >= 1000 ? 'M' : 'K') +
                        "VP",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ]);
          } catch (e) {
            return FaIcon(FontAwesomeIcons.times);
          }
        } else if (state is UserErrorState) {
          return FaIcon(FontAwesomeIcons.times);
        } else {
          return FaIcon(FontAwesomeIcons.times);
        }
      },
    );
  }
}
