import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';

import 'package:dtube_go/style/styledCustomWidgets.dart';

import 'package:dtube_go/ui/pages/settings/SettingsTabContainer.dart';
import 'package:dtube_go/ui/pages/wallet/WalletTabContainer.dart';
import 'package:dtube_go/ui/startup/OnboardingJourney.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

Widget buildMainMenuSpeedDial(BuildContext context) {
  List<SpeedDialChild> mainMenuButtonOptions = [
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.wallet,
            color: Colors.white,
            shadowColor: Colors.black,
            size: globalIconSizeMedium),
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
            size: globalIconSizeMedium),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // label: '',
        // labelStyle: TextStyle(fontSize: 14.0),
        // labelBackgroundColor: Colors.transparent,
        onTap: () {
          AppConfig.faqVisible
              ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocProvider<AuthBloc>(
                      create: (context) =>
                          AuthBloc(repository: AuthRepositoryImpl()),
                      child: OnboardingJourney(
                        loggedIn: true,
                      ));
                }))
              : showDialog(
                  context: context,
                  builder: (context) {
                    return VersionDialog();
                  });
        }),
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.cog,
            color: Colors.white,
            shadowColor: Colors.black,
            size: globalIconSizeMedium),
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
          size: globalIconSizeMedium),
      activeIcon: FontAwesomeIcons.chevronLeft,
      //buttonSize: globalIconSizeMedium * 3,
      direction: SpeedDialDirection.Down,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'menu',
      heroTag: 'main menu button',
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0.0,
      shape: CircleBorder(),
      gradientBoxShape: BoxShape.circle,
      children: mainMenuButtonOptions);
}

class VersionDialog extends StatefulWidget {
  const VersionDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<VersionDialog> createState() => _VersionDialogState();
}

class _VersionDialogState extends State<VersionDialog> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Version info',
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Text(
          _packageInfo.version + ' (Build: ' + _packageInfo.buildNumber + ')',
          style: Theme.of(context).textTheme.bodyText1),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Thanks',
              style: Theme.of(context).textTheme.bodyText1,
            )),
      ],
    );
  }
}
