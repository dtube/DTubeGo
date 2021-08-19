import 'package:decorated_icon/decorated_icon.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_togo/ui/pages/notifications/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  void initState() {
    BlocProvider.of<NotificationBloc>(context).add(FetchNotificationsEvent([]));
    super.initState();
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
              return buildNotificationIcon(false);
            } else if (state is NotificationLoadingState) {
              return buildNotificationIcon(false);
            } else if (state is NotificationLoadedState) {
              return buildNotificationIcon(
                  state.notifications.first.ts > state.tsLastNotificationSeen);
            } else if (state is NotificationErrorState) {
              return buildNotificationIcon(false);
            } else {
              return buildNotificationIcon(false);
            }
          }),
        ));
  }

  DecoratedIcon buildNotificationIcon(bool newNotifications) {
    return DecoratedIcon(
      FontAwesomeIcons.bell,
      color: newNotifications ? Colors.red : Colors.white,
      shadows: [
        BoxShadow(
          blurRadius: 24.0,
          color: Colors.black,
        ),
        // BoxShadow(
        //   blurRadius: 12.0,
        //   color: Colors.white,
        // ),
      ],
    );
  }
}
