import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QRCodeDialogMobile extends StatefulWidget {
  QRCodeDialogMobile({
    Key? key,
    required this.code,
  }) : super(key: key);

  final String code;

  @override
  State<QRCodeDialogMobile> createState() => _QRCodeDialogMobileState();
}

class _QRCodeDialogMobileState extends State<QRCodeDialogMobile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopUpDialogWithTitleLogo(
      titleWidgetPadding: 0,
      titleWidgetSize: 0,
      height: 50.h,
      width: 80.w,
      callbackOK: () {},
      titleWidget: Container(),
      showTitleWidget: false,
      child: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      QrImage(
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.circle,
                        ),
                        data: widget.code,
                        padding: EdgeInsets.zero,
                        foregroundColor: globalAlmostWhite,
                        version: QrVersions.auto,
                        size: 80.w,
                      ),
                      Text(widget.code)
                    ],
                  ),
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
          );
        },
      ),
    );
  }
}
