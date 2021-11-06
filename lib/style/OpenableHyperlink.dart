import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenableHyperlink extends StatelessWidget {
  String url;
  TextStyle? style;
  OpenableHyperlink({
    required this.url,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(url,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style:
                style != null ? style : Theme.of(context).textTheme.overline),
        onTap: () async {
          await canLaunch(url)
              ? await launch(url)
              : throw 'Could not launch $url';
        });
  }
}
