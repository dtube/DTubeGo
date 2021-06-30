import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/notification/notification_event.dart';
import 'package:dtube_togo/bloc/notification/notification_state.dart';
import 'package:dtube_togo/bloc/notification/notification_response_model.dart';
import 'package:dtube_togo/bloc/notification/notification_repository.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepository repository;

  NotificationBloc({required this.repository})
      : super(NotificationInitialState());

  // @override

  // NotificationState get initialState => NotificationInitialState();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    String? _applicationUser = await sec.getUsername();
    String _avalonApiNode = await sec.getNode();
    if (event is FetchNotificationsEvent) {
      yield NotificationLoadingState();
      try {
        List<AvalonNotification> notifications =
            await repository.getNotifications(
                _avalonApiNode, event.notificationTypes, _applicationUser!);

        yield NotificationLoadedState(notifications: notifications);
      } catch (e) {
        yield NotificationErrorState(message: e.toString());
      }
    }
  }
}
