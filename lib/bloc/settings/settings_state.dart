import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {}

// general user states
class SettingsInitialState extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoadingState extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoadedState extends SettingsState {
  Map<String, String> settings;
  @override
  SettingsLoadedState({required this.settings});

  List<Object> get props => [settings];
}

class SettingsSavingState extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsSavedState extends SettingsState {
  Map<String, String> settings;
  @override
  SettingsSavedState({required this.settings});

  List<Object> get props => [];
}

class settingsErrorState extends SettingsState {
  String message;

  settingsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
