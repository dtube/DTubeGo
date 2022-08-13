import 'package:dtube_go/bloc/postdetails/postdetails_bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

class ShareAndCommentChips extends StatelessWidget {
  const ShareAndCommentChips({
    Key? key,
    required this.author,
    required this.directFocus,
    required this.link,
    required this.postBloc,
    required this.txBloc,
    required double defaultVoteWeightComments,
  })  : _defaultVoteWeightComments = defaultVoteWeightComments,
        super(key: key);

  final String author;
  final String link;
  final double _defaultVoteWeightComments;
  final String directFocus;
  final PostBloc postBloc;
  final TransactionBloc txBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Stack(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InputChip(
                    label: FaIcon(FontAwesomeIcons.shareNodes),
                    onPressed: () {
                      Share.share(AppConfig.defaultWebsiteURL +
                          '/#!/v/' +
                          author +
                          '/' +
                          link);
                    },
                  ),
                  InputChip(
                    label: FaIcon(FontAwesomeIcons.qrcode),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return QRCodeDialog(
                              link: AppConfig.defaultWebsiteURL +
                                  '/#!/v/' +
                                  author +
                                  '/' +
                                  link,
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ReplyButton(
                  icon: FaIcon(FontAwesomeIcons.comment),
                  author: author,
                  link: link,
                  parentAuthor: author,
                  parentLink: link,
                  votingWeight: _defaultVoteWeightComments,
                  scale: 1,
                  focusOnNewComment: directFocus == "newcomment",
                  isMainPost: true,
                  postBloc: postBloc,
                  txBloc: txBloc),
            ),
          ],
        ),
      ],
    );
  }
}

class QRCodeDialog extends StatefulWidget {
  QRCodeDialog({
    Key? key,
    required this.link,
  }) : super(key: key);

  String link;

  @override
  State<QRCodeDialog> createState() => _QRCodeDialogState();
}

class _QRCodeDialogState extends State<QRCodeDialog> {
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
                  child: QrImage(
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.circle,
                    ),
                    data: widget.link,
                    padding: EdgeInsets.zero,
                    foregroundColor: globalAlmostWhite,
                    version: QrVersions.auto,
                    size: 100.w,
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
