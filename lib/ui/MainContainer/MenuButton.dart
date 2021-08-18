import 'package:decorated_icon/decorated_icon.dart';
import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';

import 'package:dtube_togo/ui/pages/settings/SettingsTabContainer.dart';
import 'package:dtube_togo/ui/pages/wallet/WalletTabContainer.dart';
import 'package:dtube_togo/ui/startup/OnboardingJourney.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildMainMenuSpeedDial(BuildContext context) {
  List<SpeedDialChild> mainMenuButtonOptions = [
    SpeedDialChild(
        child: DecoratedIcon(
          FontAwesomeIcons.wallet,
          shadows: [
            BoxShadow(
              blurRadius: 24.0,
              color: Colors.black,
            ),
            // BoxShadow(
            //   blurRadius: 12.0,
            //   color: Colors.white,
            // ),
          ],
        ),
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
        child: DecoratedIcon(
          FontAwesomeIcons.question,
          shadows: [
            BoxShadow(
              blurRadius: 24.0,
              color: Colors.black,
            ),
            // BoxShadow(
            //   blurRadius: 12.0,
            //   color: Colors.white,
            // ),
          ],
        ),
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
        child: DecoratedIcon(
          FontAwesomeIcons.cog,
          shadows: [
            BoxShadow(
              blurRadius: 24.0,
              color: Colors.black,
            ),
            // BoxShadow(
            //   blurRadius: 12.0,
            //   color: Colors.white,
            // ),
          ],
        ),
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
      child: DecoratedIcon(
        FontAwesomeIcons.bars,
        shadows: [
          BoxShadow(
            blurRadius: 24.0,
            color: Colors.black,
          ),
          // BoxShadow(
          //   blurRadius: 12.0,
          //   color: Colors.white,
          // ),
        ],
      ),
      activeIcon: FontAwesomeIcons.chevronLeft,
      buttonSize: 40.0,
      direction: SpeedDialDirection.Down,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0.0,
      shape: CircleBorder(),
      gradientBoxShape: BoxShape.circle,
      children: mainMenuButtonOptions);
}
