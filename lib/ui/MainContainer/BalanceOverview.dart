import 'dart:async';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/utils/shortBalanceStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BalanceOverviewBase extends StatefulWidget {
  BalanceOverviewBase({Key? key}) : super(key: key);

  @override
  _BalanceOverviewBaseState createState() => _BalanceOverviewBaseState();
}

class _BalanceOverviewBaseState extends State<BalanceOverviewBase> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(repository: UserRepositoryImpl()),
      child: BalanceOverview(),
    );
  }
}

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
          try {
            return Column(
                //mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Center(
                    child: Text(
                      shortDTC(state.dtcBalance) + "DTC",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Text(
                    shortVP(state.vtBalance['v']!) + "VP",
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
