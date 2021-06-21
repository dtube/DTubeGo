import 'package:dtube_togo/bloc/notification/notification_response_model.dart';
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

  NotificationLoadedState({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationErrorState extends NotificationState {
  String message;

  NotificationErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
