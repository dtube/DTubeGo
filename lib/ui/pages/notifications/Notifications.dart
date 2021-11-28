import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/notifications/NotificationItem.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
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
              return NotificationTabContainer(
                  notifications: state.notifications, username: state.username);
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
}

class NotificationTabContainer extends StatefulWidget {
  const NotificationTabContainer({
    Key? key,
    required this.notifications,
    required this.username,
  }) : super(key: key);

  final List<AvalonNotification> notifications;
  final String username;

  @override
  State<NotificationTabContainer> createState() =>
      _NotificationTabContainerState();
}

class _NotificationTabContainerState extends State<NotificationTabContainer>
    with SingleTickerProviderStateMixin {
  List<String> _tabNames = ["all", "comments", "votes", "transfers", "others"];
  List<AvalonNotification> _voteNotifications = [];
  List<AvalonNotification> _commentNotifications = [];
  List<AvalonNotification> _transferNotifications = [];
  List<AvalonNotification> _otherNotifications = [];
  late TabController _tabController;
  @override
  void initState() {
    for (var n in widget.notifications) {
      if ([5, 19].contains(n.tx.type)) {
        // votes || tipped votes
        _voteNotifications.add(n);
      } else if ([4, 13].contains(n.tx.type)) {
        // comment || promoted comment || mentions
        _commentNotifications.add(n);
      } else if (n.tx.type == 3) {
        // transfers
        _transferNotifications.add(n);
      } else {
        _otherNotifications.add(n);
      }
    }
    _tabController = new TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          child: Container(
            width: 100.w,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: globalAlmostWhite,
              indicatorColor: globalRed,
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 2.w),
              tabs: [
                Tab(
                  text: _tabNames[0],
                ),
                Tab(
                  text: _tabNames[1] +
                      ' (' +
                      _commentNotifications.length.toString() +
                      ')',
                ),
                Tab(
                  text: _tabNames[2] +
                      ' (' +
                      _voteNotifications.length.toString() +
                      ')',
                ),
                Tab(
                  text: _tabNames[3] +
                      ' (' +
                      _transferNotifications.length.toString() +
                      ')',
                ),
                Tab(
                  text: _tabNames[4] +
                      ' (' +
                      _otherNotifications.length.toString() +
                      ')',
                ),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
                buildNotificationList(widget.notifications),
                buildNotificationList(_commentNotifications),
                buildNotificationList(_voteNotifications),
                buildNotificationList(_transferNotifications),
                buildNotificationList(_otherNotifications),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNotificationList(List<AvalonNotification> notifications) {
    List<int> navigatableTxsUser = [1, 2, 3, 7, 8];
    List<int> navigatableTxsPost = [4, 5, 13, 19];
    if (notifications.length > 0) {
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
              child: NotificationItem(
                sender: notifications[pos].tx.sender,
                tx: notifications[pos].tx,
                username: widget.username,
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
                      notifications[pos].tx.data.author! != ""
                          ? notifications[pos].tx.data.author!
                          : notifications[pos].tx.sender,
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
    } else {
      return Center(
        child: Text("you dont have any notifications yet",
            style: Theme.of(context).textTheme.headline5),
      );
    }
  }
}
