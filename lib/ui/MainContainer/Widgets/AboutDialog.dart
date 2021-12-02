// dialog to show current app version and build
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppDialog extends StatefulWidget {
  const AboutAppDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutAppDialog> createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends State<AboutAppDialog> {
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
                  padding: EdgeInsets.only(bottom: 1.h),
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
                        'App Development Team',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          "Main Developer: @tibfox",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          "iOS Developer: no-do-not-track-me",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          "API extensions: @brishtiteveja0595",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 1.h, left: 17.w, right: 17.w),
                  child: ElevatedButton(
                      onPressed: () {
                        launch(AppConfig.gitDTubeGoUrl);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("DTube Go on ",
                              style: Theme.of(context).textTheme.bodyText1),
                          FaIcon(FontAwesomeIcons.github, size: 8.w),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Avalon Blockchain',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          "This app is running on the Avalon blockchain and is highly inspired by the website d.tube.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                launch(AppConfig.gitDtubeUrl);
                              },
                              child: Row(
                                children: [
                                  Text("DTube on ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  FaIcon(FontAwesomeIcons.github, size: 6.w),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                launch(AppConfig.gitAvalonUrl);
                              },
                              child: Row(
                                children: [
                                  Text("Avalon on ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  FaIcon(FontAwesomeIcons.github, size: 6.w),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 1.h, left: 22.w, right: 22.w),
                        child: ElevatedButton(
                            onPressed: () {
                              launch(AppConfig.faqUrl);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                DTubeLogo(size: 8.w),
                                Text(
                                  " FAQ",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
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
