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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MarkdownBody(
        data: widget.description,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0)),
        onTapLink: (text, url, title) {
          launch(url!);
        },
      ),
    );
  }
}
