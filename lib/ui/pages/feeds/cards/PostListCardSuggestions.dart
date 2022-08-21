import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

typedef ListOfString2VoidFunc = void Function(List<String>);

class PostListCardSuggestions extends StatefulWidget {
  const PostListCardSuggestions({
    Key? key,
    required this.blur,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.link,
    required this.publishDate,
    required this.duration,
    required this.dtcValue,
    required this.indexOfList,
    required this.width,
  }) : super(key: key);

  final bool blur;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String author;
  final String link;
  final String publishDate;
  final Duration duration;
  final String dtcValue;
  final int indexOfList;
  final double width;

  @override
  _PostListCardSuggestionsState createState() =>
      _PostListCardSuggestionsState();
}

class _PostListCardSuggestionsState extends State<PostListCardSuggestions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToPostDetailPage(
            context, widget.author, widget.link, "none", false, () {});
      },
      child: Card(
        semanticContainer: true,
        color: globalBlue,
        elevation: 0,
        child: Container(
          width: widget.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                      aspectRatio: 16 / 9,
                      child: widget.thumbnailUrl != ""
                          ? CachedNetworkImage(imageUrl: widget.thumbnailUrl)
                          : Container(
                              color: globalBGColor,
                              child: DTubeLogo(
                                size: 10.w,
                              ),
                            )),
                  Container(
                    width: widget.width,
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('@' + widget.author,
                          style: Theme.of(context).textTheme.subtitle2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${widget.publishDate} - ' +
                                  (widget.duration.inHours == 0
                                      ? widget.duration
                                          .toString()
                                          .substring(2, 7)
                                      : widget.duration
                                          .toString()
                                          .substring(0, 7)),
                              style: Theme.of(context).textTheme.subtitle2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.dtcValue}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 1.w),
                                child: DTubeLogoShadowed(size: 2.w),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
