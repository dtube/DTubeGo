import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

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
    return Container(
      width: 42.w,
      height: 28.h,
      child: SingleChildScrollView(
        child: ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ScrollOnExpand(
              // child: Card(
              //   clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expandable(
                    collapsed: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.description,
                          style: Theme.of(context).textTheme.bodyText1,
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "...",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                    expanded: MarkdownBody(
                      data: widget.description,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: Theme.of(context).textTheme.bodyText1!),
                      onTapLink: (text, url, title) {
                        launch(url!);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          var controller =
                              ExpandableController.of(context, required: true)!;
                          return FadeIn(
                            preferences: AnimationPreferences(
                                offset: Duration(seconds: 1)),
                            child: InputChip(
                              label: Text(
                                controller.expanded ? "collapse" : "read more",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              onPressed: () {
                                controller.toggle();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //),
        ),
      ),
    );
  }
}
