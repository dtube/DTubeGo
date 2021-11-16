import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherUsersAvatar extends StatelessWidget {
  String username;
  OtherUsersAvatar({Key? key, required this.username}) : super(key: key);

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
              width: 20.w,
              height: 15.h,
              child: Column(
                children: [
                  AccountAvatar(
                      username: username,
                      avatarSize: 20.w,
                      showVerified: true,
                      showName: false,
                      nameFontSizeMultiply: 1,
                      showNameLeft: false,
                      showFullUserInfo: false,
                      width: 20.w,
                      height: 20.w,
                      showAvatar: true),
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
