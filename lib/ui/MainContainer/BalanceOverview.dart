import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:async';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/styledCustomWidgets.dart';
import 'package:dtube_go/utils/shortBalanceStrings.dart';
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
    const interval = const Duration(seconds: 240);
    new Timer.periodic(interval, (Timer t) {
      _userBloc.add(FetchDTCVPEvent());
    });
    // Do something
  }

  @override
  Widget build(BuildContext context) {
    double _iconSize = 5.w;
    if (Device.orientation == Orientation.landscape) {
      _iconSize = 5.h;
    }
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBloc,
      builder: (context, state) {
        if (state is UserInitialState) {
          return SizedBox(width: 0);
        } else if (state is UserDTCVPLoadingState) {
          return SizedBox(width: 0);
        } else if (state is UserDTCVPLoadedState) {
          try {
            return Container(
              width: 25.w,
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DTubeLogoShadowed(size: _iconSize),
                      SizedBox(
                        width: 2.5.w,
                      ),
                      OverlayText(
                        text: shortDTC(state.dtcBalance),
                        sizeMultiply: 1,
                        bold: true,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShadowedIcon(
                        icon: FontAwesomeIcons.bolt,
                        shadowColor: Colors.black,
                        color: Colors.white,
                        size: _iconSize,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      OverlayText(
                          text: shortVP(state.vtBalance['v']!),
                          sizeMultiply: 1,
                          bold: true),
                    ],
                  ),
                ]),
              ),
            );
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
