import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';

import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';

import 'package:dtube_go/ui/pages/settings/SettingsTabContainer.dart';
import 'package:dtube_go/ui/pages/wallet/WalletTabContainer.dart';
import 'package:dtube_go/ui/startup/OnboardingJourney/OnboardingJourney.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AboutDialog();
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
          color: Colors.white,
          shadowColor: Colors.black,
          size: globalIconSizeMedium),
      activeIcon: FontAwesomeIcons.chevronLeft,
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

// dialog to show current app version and build
class AboutDialog extends StatefulWidget {
  const AboutDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutDialog> createState() => _VersionDialogState();
}

class _VersionDialogState extends State<AboutDialog> {
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
    return PopUpDialogWithTitleLogo(
      titleWidgetPadding: 5.w,
      titleWidgetSize: 20.w,
      callbackOK: () {},
      titleWidget: FaIcon(
        FontAwesomeIcons.question,
        size: 20.w,
        color: globalBGColor,
      ),
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Version',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                            _packageInfo.version +
                                ' (Build: ' +
                                _packageInfo.buildNumber +
                                ')',
                            style: Theme.of(context).textTheme.headline4),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Development Team',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text("@tibfox"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text("@brishtiteveja0595"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            launch(AppConfig.faqUrl);
                          },
                          child: Row(
                            children: [
                              DTubeLogo(size: 8.w),
                              Text(
                                " FAQ",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              launch(AppConfig.faqUrl);
                            },
                            child: Row(
                              children: [
                                Text("Source on ",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                FaIcon(FontAwesomeIcons.github, size: 8.w),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: globalRed,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                      ),
                      child: Text(
                        "Thanks",
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}
