import 'package:dtube_go/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NotificationItemTablet extends StatelessWidget {
  const NotificationItemTablet({
    Key? key,
    required this.sender,
    required this.username,
    required this.tx,
    required this.userNavigation,
    required this.postNavigation,
    required this.notificationType,
  }) : super(key: key);

  final String sender;
  final String username;
  final Tx tx;
  final bool userNavigation;
  final bool postNavigation;
  final String notificationType;

  @override
  Widget build(BuildContext context) {
    return DTubeFormCard(
      childs: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              child: Column(
                children: [
                  Row(
                    children: [
                      BlocProvider<UserBloc>(
                        create: (BuildContext context) =>
                            UserBloc(repository: UserRepositoryImpl()),
                        child: GestureDetector(
                            onTap: () {
                              navigateToUserDetailPage(context, sender, () {});
                            },
                            child: AccountIconBase(
                              avatarSize: 50,
                              showVerified: true,
                              username: sender,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 80,
                        child: Text(
                          sender,
                          style: Theme.of(context).textTheme.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 150,
                    child: NotificationDetails(
                      sender: sender,
                      tx: tx,
                      username: username,
                      notificationType: notificationType,
                    ),
                  ),
                ],
              ),
            ),
            userNavigation || postNavigation
                ? FaIcon(
                    userNavigation
                        ? FontAwesomeIcons.user
                        : FontAwesomeIcons.play,
                    size: 30,
                  )
                : SizedBox(width: 0)
          ],
        ),
      ],
      avoidAnimation: true,
      waitBeforeFadeIn: Duration(milliseconds: 0),
    );
  }
}

class NotificationDetails extends StatelessWidget {
  const NotificationDetails(
      {Key? key,
      required this.sender,
      required this.username,
      required this.tx,
      required this.notificationType})
      : super(key: key);

  final String sender;
  final String username;
  final Tx tx;
  final String notificationType;

  @override
  Widget build(BuildContext context) {
    String username2 = "your";

    String friendlyDescription =
        txTypeFriendlyDescriptionNotifications[tx.type]!
            .replaceAll("##USERNAMES", username2)
            .replaceAll("##USERNAME", username);
    switch (tx.type) {
      case 3:
        friendlyDescription = friendlyDescription.replaceAll(
            '##DTCAMOUNT', (tx.data.amount! / 100).toString());
        break;
      case 19:
        friendlyDescription = friendlyDescription.replaceAll(
            '##TIPAMOUNT', tx.data.tip!.toString());
        break;
      default:
        break;
    }
    if (notificationType == "mentions" && [4, 13].contains(tx.type)) {
      friendlyDescription = "mentioned you";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
            DateFormat('yyyy-MM-dd kk:mm').format(
                    DateTime.fromMicrosecondsSinceEpoch(tx.ts * 1000)
                        .toLocal()) +
                ':',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1),
        Container(
          width: 100,
          child: Text(friendlyDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1),
        ),
      ],
    );
  }
}
