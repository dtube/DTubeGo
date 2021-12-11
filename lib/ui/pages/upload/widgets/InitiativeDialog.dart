// dialog to show current app version and build
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/upload/widgets/PresetCards.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class InitiativeDialog extends StatefulWidget {
  InitiativeDialog({
    Key? key,
    required this.initiative,
  }) : super(key: key);

  Preset initiative;

  @override
  State<InitiativeDialog> createState() => _InitiativeDialogState();
}

class _InitiativeDialogState extends State<InitiativeDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopUpDialogWithTitleLogo(
      titleWidgetPadding: 0,
      titleWidgetSize: 0,
      callbackOK: () {},
      titleWidget: Container(),
      showTitleWidget: false,
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 20.h,
                        child: CachedNetworkImage(
                            fit: BoxFit.fitHeight,
                            imageUrl: widget.initiative.imageURL),
                      )),
                ),
                Container(
                    height: 50.h,
                    width: 95.w,
                    child: Markdown(data: widget.initiative.details)),
                InputChip(
                  label: Text("read more"),
                  backgroundColor: globalRed,
                  onPressed: () {
                    launch(widget.initiative.moreInfoURL);
                  },
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
