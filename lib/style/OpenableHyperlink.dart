import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenableHyperlink extends StatelessWidget {
  String url;
  OpenableHyperlink({
    required this.url,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(url,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
                fontSize: 14)),
        onTap: () async {
          await canLaunch(url)
              ? await launch(url)
              : throw 'Could not launch $url';
        });
  }
}
