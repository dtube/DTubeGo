import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/widgets/TagList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagChip extends StatelessWidget {
  String tagName;
  double width;
  TagChip({Key? key, required this.tagName, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputChip(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(
                  create: (context) =>
                      UserBloc(repository: UserRepositoryImpl())),
              BlocProvider(
                  create: (context) =>
                      FeedBloc(repository: FeedRepositoryImpl())),
            ],
            child: TagList(
              tagName: tagName,
            ),
          );
        }));
      },
      label: Container(
          width: width,
          child: Center(
              child: Text(
            tagName,
            style: Theme.of(context).textTheme.bodyText2,
            overflow: TextOverflow.ellipsis,
          ))),
    );
  }
}
