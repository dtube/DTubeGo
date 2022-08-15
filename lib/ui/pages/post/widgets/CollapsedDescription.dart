import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class CollapsedDescription extends StatefulWidget {
  CollapsedDescription(
      {Key? key,
      required this.description,
      required this.startCollapsed,
      this.showOpenLink,
      this.postAuthor,
      this.postLink})
      : super(key: key);

  final String description;
  final bool startCollapsed;
  final bool? showOpenLink;
  final String? postAuthor;
  final String? postLink;

  @override
  _CollapsedDescriptionState createState() => _CollapsedDescriptionState();
}

class _CollapsedDescriptionState extends State<CollapsedDescription> {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: !widget.startCollapsed,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(p: Theme.of(context).textTheme.bodyText1!),
                  onTapLink: (text, url, title) {
                    launchUrl(Uri.parse(url!));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  widget.showOpenLink != null &&
                          widget.showOpenLink! &&
                          widget.postAuthor != null &&
                          widget.postLink != null
                      ? InputChip(
                          label: Text(
                            "open proposal video",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          avatar:
                              FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                          onSelected: (value) {
                            navigateToPostDetailPage(
                                context,
                                widget.postAuthor!,
                                widget.postLink!,
                                "none",
                                false,
                                () {});
                          },
                        )
                      : SizedBox(width: 0),
                  Builder(
                    builder: (context) {
                      var controller =
                          ExpandableController.of(context, required: true)!;
                      return globals.disableAnimations
                          ? InputChip(
                              label: Text(
                                controller.expanded ? "collapse" : "read more",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              onPressed: () {
                                controller.toggle();
                              },
                            )
                          : InputChip(
                              label: Text(
                                controller.expanded ? "collapse" : "read more",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              onPressed: () {
                                controller.toggle();
                              },
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
    );
  }
}
