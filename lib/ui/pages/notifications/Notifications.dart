import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/styledCustomWidgets.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:dtube_go/bloc/notification/notification_bloc_full.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();

  Notifications({Key? key}) : super(key: key);
}

class _NotificationsState extends State<Notifications> {
  late NotificationBloc notificationBloc;
  late int lastNotification;

  @override
  void initState() {
    super.initState();
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    notificationBloc.add(FetchNotificationsEvent([])); // statements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dtubeSubAppBar(true, "", context, null),
      body: Container(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationInitialState) {
              return buildLoading();
            } else if (state is NotificationLoadingState) {
              return buildLoading();
            } else if (state is NotificationLoadedState) {
              return buildnotificationList(state.notifications, state.username);
            } else if (state is NotificationErrorState) {
              return buildErrorUi(state.message);
            } else {
              return buildErrorUi('test');
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildnotificationList(
      List<AvalonNotification> notifications, String username) {
    List<int> navigatableTxsUser = [1, 2, 3, 7, 8];
    List<int> navigatableTxsPost = [4, 5, 13, 19];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (ctx, pos) {
        bool _userNavigationPossible =
            navigatableTxsUser.contains(notifications[pos].tx.type);
        bool _postNavigationPossible =
            navigatableTxsPost.contains(notifications[pos].tx.type);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            child: CustomListItem(
              sender: notifications[pos].tx.sender,
              tx: notifications[pos].tx,
              username: username,
              userNavigation: _userNavigationPossible,
              postNavigation: _postNavigationPossible,
            ),
            onTap: () {
              if (_userNavigationPossible) {
                navigateToUserDetailPage(
                    context, notifications[pos].tx.sender, () {});
              }
              if (_postNavigationPossible) {
                navigateToPostDetailPage(
                    context,
                    notifications[pos].tx.data.author!,
                    notifications[pos].tx.data.link!,
                    "none",
                    false,
                    () {});
              }
            },
          ),
        );
      },
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.sender,
    required this.username,
    required this.tx,
    required this.userNavigation,
    required this.postNavigation,
  }) : super(key: key);

  final String sender;
  final String username;
  final Tx tx;
  final bool userNavigation;
  final bool postNavigation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 10.h,
        width: 100.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                BlocProvider<UserBloc>(
                  create: (BuildContext context) =>
                      UserBloc(repository: UserRepositoryImpl()),
                  child: AccountAvatarBase(
                    username: sender,
                    avatarSize: 15.w,
                    showVerified: true,
                    showName: true,
                    width: 35.w,
                    height: 7.h,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                NotificationTitle(
                  sender: sender,
                  tx: tx,
                  username: username,
                ),
              ],
            ),
            userNavigation || postNavigation
                ? FaIcon(
                    userNavigation
                        ? FontAwesomeIcons.user
                        : FontAwesomeIcons.play,
                    size: 5.w,
                  )
                : SizedBox(width: 0)
          ],
        ),
      ),
    );
  }
}

class NotificationTitle extends StatelessWidget {
  const NotificationTitle({
    Key? key,
    required this.sender,
    required this.username,
    required this.tx,
  }) : super(key: key);

  final String sender;
  final String username;
  final Tx tx;

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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1),
        Text(friendlyDescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}
