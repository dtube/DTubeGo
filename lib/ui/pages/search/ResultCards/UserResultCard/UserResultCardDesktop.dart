import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:dtube_go/utils/Strings/shortBalanceStrings.dart';
import 'package:flutter/material.dart';

class UserResultCardDesktop extends StatefulWidget {
  const UserResultCardDesktop({
    Key? key,
    required this.id,
    required this.name,
    required this.dtcValue,
    required this.vpBalance,
  }) : super(key: key);

  final String id;
  final String name;
  final double dtcValue;
  final double vpBalance;

  @override
  State<UserResultCardDesktop> createState() => _UserResultCardDesktopState();
}

class _UserResultCardDesktopState extends State<UserResultCardDesktop> {
  late UserBloc userBloc = new UserBloc(repository: UserRepositoryImpl());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc.add(FetchAccountDataEvent(username: widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        bloc: userBloc,
        builder: (context, state) {
          if (state is UserLoadedState) {
            return GestureDetector(
              onTap: () {
                navigateToUserDetailPage(context, widget.name, () {});
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                color: globalBlue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 12.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AccountIconBase(
                                    username: widget.name,
                                    avatarSize: 50,
                                    showVerified: true,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 15.w,
                                      child: Text(
                                        widget.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              state.user.jsonString != null &&
                                      state.user.jsonString!.profile != null &&
                                      state.user.jsonString!.profile!.about !=
                                          null
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Container(
                                        width: 20.w,
                                        child: Text(
                                          state
                                              .user.jsonString!.profile!.about!,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    )
                            ],
                          ),
                        ),
                        // Text(
                        //   name,
                        //   style: Theme.of(context).textTheme.headline4,
                        // )

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              shortDTC(widget.dtcValue.round()) + 'DTC',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              shortDTC(widget.vpBalance.round()) + 'VP',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              TimeAgo.timeInAgoTSShort(
                                  state.user.created != null
                                      ? state.user.created!.ts
                                      : 1593357855000),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              "by " +
                                  (state.user.created != null
                                      ? state.user.created!.by
                                      : "dtube"),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(
            child: DtubeLogoPulseWithSubtitle(
                size: 10.w, subtitle: "loading results.."),
          );
        });
  }
}
