import 'dart:ui';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      required this.showDTCValue,
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
  final bool showDTCValue;
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
        semanticContainer: true,
        color: globalBlueShades[2],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        elevation: 0,
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AspectRatio(
                    aspectRatio: 16 / 9,
                    child: widget.thumbnailUrl != ""
                        ? Container(
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: new Radius.circular(16.0)),
                                image: DecorationImage(
                                    image: NetworkImage(widget.thumbnailUrl),
                                    fit: BoxFit.cover)),
                          )
                        : Container(
                            color: globalBGColor,
                            child: DTubeLogo(
                              size: 20.w,
                            ),
                          )),
                SizedBox(height: 1.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 5.h,
                    child: Text(
                      widget.title,
                      style: widget.userPage
                          ? Theme.of(context).textTheme.titleLarge
                          : Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                !widget.userPage
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.author,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.publishDate} - ' +
                            (widget.duration.inHours == 0
                                ? widget.duration.toString().substring(2, 7)
                                : widget.duration.toString().substring(0, 7)),
                        style: !widget.userPage
                            ? Theme.of(context).textTheme.titleSmall
                            : Theme.of(context).textTheme.bodyMedium,
                      ),
                      Row(
                        children: [ LayoutBuilder(builder: (context, constraints) {
                          if (widget.showDTCValue == true) {
                            return Text(
                              '${widget.dtcValue}',
                              style: !widget.userPage
                                  ? Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium
                                  : Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
                            );
                          } else {
                            return Text("");
                          }
                        }),
                          Padding(
                            padding: EdgeInsets.only(left: 0.5.w),
                            child: widget.showDTCValue ? DTubeLogoShadowed(size: 4.w) : null,
                        )],
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
