import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {}

class FetchNotificationsEvent extends NotificationEvent {
  FetchNotificationsEvent(this.notificationTypes);
  final List<int> notificationTypes;

  @override
  List<Object> get props => List.empty();
}

class UpdateLastNotificationSeen extends NotificationEvent {
  UpdateLastNotificationSeen();

  @override
  List<Object> get props => List.empty();
}
