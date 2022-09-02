import 'package:dtube_go/bloc/postdetails/postdetails_bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/res/Config/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/utils/Widgets/QRCodeDialog/QRCodeDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                          builder: (context2) {
                            return QRCodeDialog(
                              code: AppConfig.defaultWebsiteURL +
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
