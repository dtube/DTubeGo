import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {}

class FetchSettingsEvent extends SettingsEvent {
  @override
  List<Object> get props => List.empty();
}

class PushSettingsEvent extends SettingsEvent {
  Map<String, String> newSettings;
  BuildContext context;
  PushSettingsEvent({required this.newSettings, required this.context});

  @override
  List<Object> get props => List.empty();
}

class PushNewPinEvent extends SettingsEvent {
  String newPin;
  PushNewPinEvent(this.newPin);

  @override
  List<Object> get props => List.empty();
}
