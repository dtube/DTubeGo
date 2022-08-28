import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/ui/widgets/Suggestions/OtherUsersAvatar.dart';
import 'package:flutter/material.dart';

class UserListDesktop extends StatefulWidget {
  UserListDesktop(
      {Key? key,
      required this.userlist,
      required this.title,
      required this.showCount,
      required this.avatarSize})
      : super(key: key);
  final List<String> userlist;
  final String title;
  final bool showCount;
  final double avatarSize;

  @override
  State<UserListDesktop> createState() => _UserListDesktopState();
}

class _UserListDesktopState extends State<UserListDesktop> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _scrollController.animateTo(_scrollController.position.maxScrollExtent,        duration: Duration(milliseconds: 200), curve: Curves.easeOut);

    return Column(children: [
      Text(
          widget.title +
              (widget.showCount
                  ? " (" + widget.userlist.length.toString() + ")"
                  : ""),
          style: Theme.of(context).textTheme.headline5),
      Container(
          width: 70.w,
          child: MasonryGridView.count(
            padding: EdgeInsets.zero,
            // controller: _scrollController,
            crossAxisCount: 9,
            crossAxisSpacing: 10,
            shrinkWrap: true,

            itemCount: widget.userlist.length,
            itemBuilder: (ctx, index) => GestureDetector(
              onTap: (() {
                navigateToUserDetailPage(
                    context, widget.userlist[index], () {});
              }),
              child: Column(
                children: [
                  AccountIconBase(
                    avatarSize: widget.avatarSize,
                    showVerified: true,
                    username: widget.userlist[index],
                    showBorder: true,
                  ),
                  Container(
                    height: 2.h,
                    width: widget.avatarSize,
                    child: Center(
                      child: Text(widget.userlist[index],
                          style: Theme.of(context).textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              ),
            ),
          )),
    ]);
  }
}
