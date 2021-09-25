import 'package:dtube_go/bloc/notification/notification_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {}

class NotificationInitialState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadingState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadedState extends NotificationState {
  List<AvalonNotification> notifications;
  String username;
  int tsLastNotificationSeen;

  NotificationLoadedState(
      {required this.notifications,
      required this.username,
      required this.tsLastNotificationSeen});

  @override
  List<Object> get props => [notifications, username];
}

class NotificationErrorState extends NotificationState {
  String message;

  NotificationErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class LastSeenUpdated extends NotificationState {
  @override
  List<Object> get props => [];
}
