import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherUsersAvatar extends StatelessWidget {
  String username;
  double avatarSize;
  OtherUsersAvatar({Key? key, required this.username, required this.avatarSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
        create: (context) => UserBloc(repository: UserRepositoryImpl()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              navigateToUserDetailPage(context, username, () {});
            },
            child: Container(
              width: avatarSize * 1.5,
              height: avatarSize * 1.5,
              child: Column(
                children: [
                  AccountIconBase(
                    avatarSize: avatarSize,
                    showVerified: true,
                    username: username,
                  ),
                  Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
