import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/ui/widgets/Suggestions/OtherUsersAvatar.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  UserList(
      {Key? key,
      required this.userlist,
      required this.title,
      required this.showCount})
      : super(key: key);
  List<String> userlist;
  String title;
  bool showCount;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
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
        height: 17.h,
        width: double.infinity,
        child: ListView.builder(
          // controller: _scrollController,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.userlist.length,
          itemBuilder: (ctx, index) =>
              OtherUsersAvatar(username: widget.userlist[index]),
        ),
      ),
    ]);
  }
}
