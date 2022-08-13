import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/notification/notification_event.dart';
import 'package:dtube_go/bloc/notification/notification_state.dart';
import 'package:dtube_go/bloc/notification/notification_response_model.dart';
import 'package:dtube_go/bloc/notification/notification_repository.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepository repository;

  NotificationBloc({required this.repository})
      : super(NotificationInitialState()) {
    on<UpdateLastNotificationSeen>((event, emit) async {
      String? _applicationUser = await sec.getUsername();
      String _avalonApiNode = await sec.getNode();
      String _tsLastNotificationSeen = await sec.getLastNotification();
      List<AvalonNotification> notifications = await repository
          .getNotifications(_avalonApiNode, [], _applicationUser);

      sec.persistNotificationSeen(notifications.first.ts);
      emit(LastSeenUpdated());
    });

    on<FetchNotificationsEvent>((event, emit) async {
      String? _applicationUser = await sec.getUsername();
      String _avalonApiNode = await sec.getNode();
      String _tsLastNotificationSeen = await sec.getLastNotification();
      emit(NotificationLoadingState());
      try {
        List<AvalonNotification> notifications =
            await repository.getNotifications(
                _avalonApiNode, event.notificationTypes, _applicationUser);
        int _newNotifications = 0;
        if (notifications.length > 0) {
          for (var n in notifications) {
            if (n.ts > int.parse(_tsLastNotificationSeen)) {
              _newNotifications++;
            }
          }
        }
        emit(NotificationLoadedState(
            notifications: notifications,
            username: _applicationUser,
            tsLastNotificationSeen: int.parse(_tsLastNotificationSeen),
            newNotificationsCount: _newNotifications));
      } catch (e) {
        emit(NotificationErrorState(message: e.toString()));
      }
    });
  }
}
