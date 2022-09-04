import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/Strings/shortBalanceStrings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserMoreInfoButtonDesktop extends StatelessWidget {
  UserMoreInfoButtonDesktop(
      {Key? key, required this.context, required this.user, this.size})
      : super(key: key);

  final BuildContext context;
  final User user;
  double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: size != null ? size! : 24,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return PopUpDialogWithTitleLogo(
                  titleWidget: FaIcon(
                    FontAwesomeIcons.info,
                    size: 50,
                  ),
                  showTitleWidget: true,
                  callbackOK: () {},
                  titleWidgetPadding: 25,
                  titleWidgetSize: 50,
                  height: 500,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DTubeLogoShadowed(size: 30),
                                  Text(
                                    shortDTC(user.balance),
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ShadowedIcon(
                                      icon: FontAwesomeIcons.bolt,
                                      shadowColor: Colors.black,
                                      color: globalAlmostWhite,
                                      size: 24),
                                  Text(
                                    shortVP(user.vt!.v),
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      SizedBox(height: 20),
                      user.jsonString != null &&
                              user.jsonString!.profile != null &&
                              user.jsonString!.profile!.location != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("From: ",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      textAlign: TextAlign.start),
                                  Container(
                                    width: 300,
                                    child: Text(
                                      user.jsonString!.profile!.location!,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                      maxLines: 5,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(height: 0),
                      user.jsonString != null &&
                              user.jsonString!.profile != null &&
                              user.jsonString!.profile!.website != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Website: ",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      textAlign: TextAlign.start,
                                      maxLines: 1),
                                  Container(
                                    width: 300,
                                    child: OpenableHyperlink(
                                      url: user.jsonString!.profile!.website!,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(height: 0),
                      user.jsonString != null &&
                              user.jsonString!.profile != null &&
                              user.jsonString!.profile!.about != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("about: ",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      textAlign: TextAlign.start),
                                  Container(
                                    width: 300,
                                    child: Text(
                                      user.jsonString!.profile!.about!,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(height: 0),
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
                              "Thanks!",
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            FocusScope.of(context).unfocus();
                          }),
                    ],
                  ),
                );
              });
        },
        icon: ShadowedIcon(
            size: size != null ? size! : globalIconSizeMedium,
            icon: FontAwesomeIcons.info,
            color: globalAlmostWhite,
            shadowColor: Colors.black));
  }
}
