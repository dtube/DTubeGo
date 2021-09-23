import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';

import 'package:dtube_togo/style/styledCustomWidgets.dart';

import 'package:dtube_togo/ui/pages/settings/SettingsTabContainer.dart';
import 'package:dtube_togo/ui/pages/wallet/WalletTabContainer.dart';
import 'package:dtube_togo/ui/startup/OnboardingJourney.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildMainMenuSpeedDial(BuildContext context, double iconSize) {
  List<SpeedDialChild> mainMenuButtonOptions = [
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.wallet,
            color: Colors.white,
            shadowColor: Colors.black,
            size: iconSize),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // label: '',
        // labelStyle: TextStyle(fontSize: 14.0),
        // labelBackgroundColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider<NotificationBloc>(
                create: (context) =>
                    NotificationBloc(repository: NotificationRepositoryImpl()),
                child: WalletMainPage());
          }));
        }),
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.question,
            color: Colors.white,
            shadowColor: Colors.black,
            size: iconSize),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // label: '',
        // labelStyle: TextStyle(fontSize: 14.0),
        // labelBackgroundColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(repository: AuthRepositoryImpl()),
                child: OnboardingJourney(
                  loggedIn: true,
                ));
          }));
        }),
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.cog,
            color: Colors.white,
            shadowColor: Colors.black,
            size: iconSize),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // label: '',
        // labelStyle: TextStyle(fontSize: 14.0),
        // labelBackgroundColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider<SettingsBloc>(
                create: (context) => SettingsBloc(),
                child: SettingsTabContainer());
          }));
        }),
  ];

  return SpeedDial(
      // icon: FontAwesomeIcons.bars,
      child: ShadowedIcon(
          icon: FontAwesomeIcons.bars,
          color: Colors.white,
          shadowColor: Colors.black,
          size: iconSize),
      activeIcon: FontAwesomeIcons.chevronLeft,
      buttonSize: iconSize * 3,
      direction: SpeedDialDirection.Down,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'menu',
      heroTag: 'menu button',
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0.0,
      shape: CircleBorder(),
      gradientBoxShape: BoxShape.circle,
      children: mainMenuButtonOptions);
}
