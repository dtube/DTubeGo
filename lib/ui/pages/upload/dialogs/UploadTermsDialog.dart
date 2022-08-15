import 'package:markdown/markdown.dart' as md;

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UploadTermsDialog extends StatefulWidget {
  UploadTermsDialog({Key? key, required this.agreeToTermsCallback})
      : super(key: key);

  final VoidCallback agreeToTermsCallback;

  @override
  State<UploadTermsDialog> createState() => _UploadTermsDialogState();
}

class _UploadTermsDialogState extends State<UploadTermsDialog> {
  String? _uploadTerms;
  bool _readingCompleted = false;

  var _controller = ScrollController();

  void loadTermsFromMD() async {
    final _loadUploadTerms =
        await rootBundle.loadString('lib/res/mds/uploadTerms.md');

    setState(() {
      _uploadTerms = _loadUploadTerms;
    });
  }

  @override
  void initState() {
    loadTermsFromMD();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
          setState(() {
            if (_uploadTerms == null) {
              _readingCompleted = true;
            } else {
              _readingCompleted = false;
            }
          });
        } else {
          setState(() {
            _readingCompleted = true;
          });
        }
      } else {
        setState(() {
          if (_uploadTerms == null) {
            _readingCompleted = true;
          } else {
            _readingCompleted = false;
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopUpDialogWithTitleLogo(
        showTitleWidget: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 6.h),
              Container(
                height: 50.h,
                width: 90.w,
                child: Markdown(
                    selectable: false,
                    controller: _controller,
                    data: (_uploadTerms != null ? _uploadTerms! : 'loading..'),
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                      [
                        md.EmojiSyntax(),
                        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                      ],
                      // ),
                    )),
              ),
              SizedBox(height: 3.h),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: _readingCompleted ? globalRed : Colors.grey,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                    ),
                    child: Text(
                      "Agree",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: _readingCompleted
                      ? () {
                          widget.agreeToTermsCallback();
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        }
                      : null),
            ],
          ),
        ),
        titleWidget: Center(
          child: FaIcon(
            FontAwesomeIcons.fileSignature,
            size: 8.h,
          ),
        ),
        callbackOK: () {},
        titleWidgetPadding: 10.w,
        titleWidgetSize: 10.w);
  }
}
