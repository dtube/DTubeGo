import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:dtube_togo/style/ThemeData.dart';

import 'package:dtube_togo/utils/navigationShortcuts.dart';

import 'package:flutter/material.dart';

typedef ListOfString2VoidFunc = void Function(List<String>);

class PostListCardNarrow extends StatefulWidget {
  const PostListCardNarrow(
      {Key? key,
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
      required this.height,
      required this.enableNavigation,
      this.itemSelectedCallback,
      required this.userPage})
      : super(key: key);

  final bool blur;
  final bool userPage;
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
  final double height;
  final bool enableNavigation;
  final ListOfString2VoidFunc?
      itemSelectedCallback; // only used in landscape mode for now

  @override
  _PostListCardNarrowState createState() => _PostListCardNarrowState();
}

class _PostListCardNarrowState extends State<PostListCardNarrow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.enableNavigation) {
          navigateToPostDetailPage(
              context, widget.author, widget.link, "none", false, () {});
        } else {
          if (widget.itemSelectedCallback != null) {
            widget.itemSelectedCallback!([widget.author, widget.link]);
          }
        }
      },
      child: Card(
        color: globalBGColor,
        elevation: 0,
        child: Container(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: widget.height,
              // width: widget.width * 0.3,
              child: AspectRatio(
                aspectRatio: 8 / 5,
                child: widget.blur
                    ? ClipRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaY: 5,
                            sigmaX: 5,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.thumbnailUrl,
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.thumbnailUrl,
                        fit: BoxFit.fitWidth,
                      ),
              ),
              // ),
            ),
            SizedBox(width: 4),
            Container(
              width: widget.width * 0.6,
              height: widget.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.title,
                    style: widget.userPage
                        ? Theme.of(context).textTheme.bodyText1
                        : Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  !widget.userPage
                      ? Text(
                          widget.author,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox(height: 0),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.publishDate} - ' +
                              (widget.duration.inHours == 0
                                  ? widget.duration.toString().substring(2, 7)
                                  : widget.duration.toString().substring(0, 7)),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          '${widget.dtcValue}',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
