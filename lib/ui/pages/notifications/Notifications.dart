import 'package:dtube_togo/bloc/config/txTypes.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';

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
    List<int> navigatableTxsUser = [1, 2, 7, 8];
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
              List<int> navigatableTxsUser = [1, 2, 7, 8];
              List<int> navigatableTxsPost = [4, 5, 13, 19];
              if (_userNavigationPossible) {
                navigateToUserDetailPage(context, notifications[pos].tx.sender);
              }
              if (_postNavigationPossible) {
                navigateToPostDetailPage(
                    context,
                    notifications[pos].tx.data.author!,
                    notifications[pos].tx.data.link!,
                    "none");
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
        height: 35,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocProvider<UserBloc>(
              create: (BuildContext context) =>
                  UserBloc(repository: UserRepositoryImpl()),
              child: AccountAvatarBase(
                username: sender,
                avatarSize: 30,
                showVerified: true,
                showName: true,
                width: 140,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationTitle(
                    sender: sender,
                    tx: tx,
                    username: username,
                  ),
                  NotificationDescription(tx: tx),
                ],
              ),
            ),
            userNavigation || postNavigation
                ? FaIcon(
                    userNavigation
                        ? FontAwesomeIcons.user
                        : FontAwesomeIcons.play,
                    size: 15,
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

    String friendlyDescription = ' ' +
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // Text(
        //   sender,
        //   maxLines: 2,
        //   overflow: TextOverflow.ellipsis,
        //   style: const TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 14.0,
        //   ),
        // ),
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Text(
          friendlyDescription,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14.0,
            //color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class NotificationDescription extends StatelessWidget {
  const NotificationDescription({
    Key? key,
    required this.tx,
  }) : super(key: key);

  final Tx tx;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Text(
          DateFormat('yyyy-MM-dd kk:mm').format(
              DateTime.fromMicrosecondsSinceEpoch(tx.ts * 1000).toLocal()),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.0,
            //color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
