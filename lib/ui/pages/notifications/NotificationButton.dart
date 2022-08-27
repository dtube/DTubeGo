import 'package:badges/badges.dart';
import 'package:dtube_go/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/notifications/Notifications.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationButton extends StatefulWidget {
  double iconSize;
  NotificationButton({
    required this.iconSize,
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotificationBloc>(context).add(FetchNotificationsEvent([]));
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<NotificationBloc>(context)
                .add(UpdateLastNotificationSeen());
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              //needs it's own bloc to prevent refreshing in the page itself bc the button will get refreshed
              return BlocProvider<NotificationBloc>(
                  create: (context) => NotificationBloc(
                      repository: NotificationRepositoryImpl()),
                  child: Notifications());
            }));
          },
          child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
            if (state is NotificationInitialState) {
              return buildNotificationIcon(false, widget.iconSize, 0);
            } else if (state is NotificationLoadingState) {
              return buildNotificationIcon(false, widget.iconSize, 0);
            } else if (state is NotificationLoadedState) {
              if (state.notifications.isNotEmpty) {
                return buildNotificationIcon(
                    state.notifications.first.ts > state.tsLastNotificationSeen,
                    widget.iconSize,
                    state.newNotificationsCount);
              } else {
                return buildNotificationIcon(false, widget.iconSize, 0);
              }
            } else if (state is NotificationErrorState) {
              return buildNotificationIcon(false, widget.iconSize, 0);
            } else {
              return buildNotificationIcon(false, widget.iconSize, 0);
            }
          }),
        ));
  }

  Widget buildNotificationIcon(
      bool newNotifications, double iconSize, int newNotificationsCount) {
    return Badge(
      child: ShadowedIcon(
        icon: FontAwesomeIcons.bell,
        color: globalAlmostWhite,
        shadowColor: Colors.black,
        size: iconSize,
      ),
      badgeContent: Text(
          // newNotificationsCount.toString(),
          newNotificationsCount.toString(),
          style: Theme.of(context).textTheme.bodyText2),
      animationType: BadgeAnimationType.scale,
      showBadge: newNotificationsCount > 0,
    );
    //     newNotificationsCount > 0
    //         ? Center(
    //             child: OverlayText(
    //               text: newNotificationsCount.toString(),
    //               sizeMultiply: 0.8,
    //               bold: true,
    //             ),
    //           )
    //         : Container(),
    //   ],
    // );
  }
}
