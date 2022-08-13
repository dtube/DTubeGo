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

class UserMoreInfoButton extends StatelessWidget {
  UserMoreInfoButton({Key? key, required this.context, required this.user})
      : super(key: key);

  final BuildContext context;
  final User user;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return PopUpDialogWithTitleLogo(
                  titleWidget: FaIcon(
                    FontAwesomeIcons.info,
                    size: 8.h,
                  ),
                  showTitleWidget: true,
                  callbackOK: () {},
                  titleWidgetPadding: 5.w,
                  titleWidgetSize: 20.w,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 10.w,
                                        height: 10.w,
                                        child: DTubeLogoShadowed(size: 10.w)),
                                    OverlayText(
                                      text: shortDTC(user.balance),
                                      sizeMultiply: 1.4,
                                      bold: true,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 10.w,
                                      height: 10.w,
                                      child: ShadowedIcon(
                                        icon: FontAwesomeIcons.bolt,
                                        shadowColor: Colors.black,
                                        color: globalAlmostWhite,
                                        size: 10.w,
                                      ),
                                    ),
                                    OverlayText(
                                        text: shortVP(user.vt!.v),
                                        sizeMultiply: 1.4,
                                        bold: true),
                                  ],
                                ),
                              ]),
                        ),
                        SizedBox(height: 2.h),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        textAlign: TextAlign.start),
                                    Container(
                                      width: 55.w,
                                      child: Text(
                                        user.jsonString!.profile!.location!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        textAlign: TextAlign.start),
                                    Container(
                                      width: 55.w,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        textAlign: TextAlign.start),
                                    Container(
                                      width: 55.w,
                                      child: Text(
                                        user.jsonString!.profile!.about!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        textAlign: TextAlign.start,
                                        maxLines: 5,
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
                  ),
                );
              });
        },
        icon: ShadowedIcon(
            size: globalIconSizeMedium,
            icon: FontAwesomeIcons.info,
            color: globalAlmostWhite,
            shadowColor: Colors.black));
  }
}
