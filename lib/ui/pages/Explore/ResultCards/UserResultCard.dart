import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:dtube_go/utils/shortBalanceStrings.dart';
import 'package:flutter/material.dart';

class UserResultCard extends StatelessWidget {
  const UserResultCard({
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToUserDetailPage(context, name, () {});
      },
      child: Card(
        // height: 35,
        margin: EdgeInsets.all(8.0),
        color: globalBlue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AccountAvatarBase(
                        username: name,
                        avatarSize: 10.w,
                        showVerified: true,
                        showName: true,
                        width: 70.w,
                        height: 5.h),
                  ),
                  // Text(
                  //   name,
                  //   style: Theme.of(context).textTheme.headline4,
                  // )
                ],
              ),
              Column(
                children: [
                  Text(
                    shortDTC(dtcValue.round()) + 'DTC',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    shortDTC(vpBalance.round()) + 'VP',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
