import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {}

// general user states
class SettingsInitialState extends SettingsState {
  List<Object> get props => [];
}

class SettingsLoadingState extends SettingsState {
  List<Object> get props => [];
}

class SettingsLoadedState extends SettingsState {
  Map<String, String> settings;

  SettingsLoadedState({required this.settings});

  List<Object> get props => [settings];
}

class SettingsSavingState extends SettingsState {
  List<Object> get props => [];
}

class PinSavedState extends SettingsState {
  List<Object> get props => [];
}

class SettingsSavedState extends SettingsState {
  final Map<String, String> settings;

  SettingsSavedState({required this.settings});

  List<Object> get props => [];
}

class SettingsErrorState extends SettingsState {
  final String message;

  SettingsErrorState({required this.message});

  List<Object> get props => [message];
}
