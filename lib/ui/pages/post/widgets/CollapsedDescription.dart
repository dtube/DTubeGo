// TODO: truncate description if too long - issue here is markdown since it's not calculateable before rendering
// perhaps this can help: https://stackoverflow.com/questions/63019636/flutter-markdown-show-more-button

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter/material.dart';

class CollapsedDescription extends StatefulWidget {
  const CollapsedDescription({
    Key? key,
    required this.description,
  }) : super(key: key);

  final String description;

  @override
  _CollapsedDescriptionState createState() => _CollapsedDescriptionState();
}

class _CollapsedDescriptionState extends State<CollapsedDescription> {
  bool showmorePressed = false;
  var myChildSize = Size.zero;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MarkdownBody(
        //data: post.json_string.desc,
        data: widget.description,

        onTapLink: (text, url, title) {
          launch(url!);
        },
      ),
    );
  }
}
