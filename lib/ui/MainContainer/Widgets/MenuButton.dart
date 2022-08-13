import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/search/search_bloc_full.dart';
import 'package:dtube_go/ui/MainContainer/Widgets/AboutDialog.dart';
import 'package:dtube_go/ui/pages/search/SearchScreen.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/settings/SettingsTabContainer.dart';
import 'package:dtube_go/ui/pages/wallet/WalletTabContainer.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildMainMenuSpeedDial(BuildContext context) {
  List<SpeedDialChild> mainMenuButtonOptions = [
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.magnifyingGlass,
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: globalIconSizeBig),
        foregroundColor: globalAlmostWhite,
        elevation: 0,
        backgroundColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MultiBlocProvider(providers: [
              BlocProvider<SearchBloc>(
                  create: (context) =>
                      SearchBloc(repository: SearchRepositoryImpl())),
              BlocProvider(
                  create: (context) =>
                      FeedBloc(repository: FeedRepositoryImpl())),
            ], child: SearchScreen());
          }));
        }),
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.hotel,
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: globalIconSizeBig),
        foregroundColor: globalAlmostWhite,
        elevation: 0,
        backgroundColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return WalletMainPage();
          }));
        }),
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.question,
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: globalIconSizeBig),
        foregroundColor: globalAlmostWhite,
        elevation: 0,
        backgroundColor: Colors.transparent,
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AboutAppDialog();
              });
        }),
    SpeedDialChild(
        child: ShadowedIcon(
            icon: FontAwesomeIcons.gear,
            color: globalAlmostWhite,
            shadowColor: Colors.black,
            size: globalIconSizeBig),
        foregroundColor: globalAlmostWhite,
        elevation: 0,
        backgroundColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider<SettingsBloc>(
                create: (context) => SettingsBloc(),
                child: SettingsTabContainer());
          }));
        }),
  ];

  return SpeedDial(
      child: ShadowedIcon(
          icon: FontAwesomeIcons.bars,
          color: globalAlmostWhite,
          shadowColor: Colors.black,
          size: globalIconSizeMedium),
      activeIcon: FontAwesomeIcons.chevronLeft,
      direction: SpeedDialDirection.down,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'menu',
      heroTag: 'main menu button',
      backgroundColor: Colors.transparent,
      foregroundColor: globalAlmostWhite,
      elevation: 0.0,
      shape: CircleBorder(),
      gradientBoxShape: BoxShape.circle,
      children: mainMenuButtonOptions);
}
