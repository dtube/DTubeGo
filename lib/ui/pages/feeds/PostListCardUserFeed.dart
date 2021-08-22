import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';

import 'package:flutter/material.dart';

class PostListCardUserFeed extends StatefulWidget {
  const PostListCardUserFeed(
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
      required this.indexOfList})
      : super(key: key);

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

  @override
  _PostListCardUserFeedState createState() => _PostListCardUserFeedState();
}

class _PostListCardUserFeedState extends State<PostListCardUserFeed> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        navigateToPostDetailPage(context, widget.author, widget.link, "none");
      },
      child: Padding(
        padding: EdgeInsets.only(top: widget.indexOfList == 0 ? 180 : 0),
        child: Card(
          color: globalBGColor,
          elevation: 0,
          child: Container(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 75,
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
              SizedBox(width: 8),
              Container(
                width: (deviceWidth - 50) / 3 * 2,
                height: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.publishDate} - ' +
                                (widget.duration.inHours == 0
                                    ? widget.duration.toString().substring(2, 7)
                                    : widget.duration
                                        .toString()
                                        .substring(0, 7)),
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            '${widget.dtcValue}',
                            style: Theme.of(context).textTheme.headline5,
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
      ),
    );
  }
}
