import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {}

class FetchSettingsEvent extends SettingsEvent {
  @override
  List<Object> get props => List.empty();
}

class PushSettingsEvent extends SettingsEvent {
  Map<String, String> newSettings;
  PushSettingsEvent(this.newSettings);

  @override
  List<Object> get props => List.empty();
}

class PushNewPinEvent extends SettingsEvent {
  String newPin;
  PushNewPinEvent(this.newPin);

  @override
  List<Object> get props => List.empty();
}
