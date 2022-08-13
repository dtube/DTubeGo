import 'package:dtube_go/bloc/notification/notification_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {}

class NotificationInitialState extends NotificationState {
  List<Object> get props => [];
}

class NotificationLoadingState extends NotificationState {
  List<Object> get props => [];
}

class NotificationLoadedState extends NotificationState {
  final List<AvalonNotification> notifications;
  final String username;
  final int tsLastNotificationSeen;
  final int newNotificationsCount;

  NotificationLoadedState(
      {required this.notifications,
      required this.username,
      required this.tsLastNotificationSeen,
      required this.newNotificationsCount});

  List<Object> get props => [notifications, username];
}

class NotificationErrorState extends NotificationState {
  final String message;

  NotificationErrorState({required this.message});

  List<Object> get props => [message];
}

class LastSeenUpdated extends NotificationState {
  List<Object> get props => [];
}
