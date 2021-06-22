import 'package:dtube_togo/bloc/settings/settings_event.dart';
import 'package:dtube_togo/bloc/settings/settings_state.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitialState());

  @override
  // TODO: implement initialState
  SettingsState get initialState => SettingsInitialState();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is FetchSettingsEvent) {
      yield SettingsLoadingState();
      try {
        String? username = await sec.getUsername();
        Map<String, String> newSettings = {
          sec.settingKey_avalonNode: await sec.getNode(),
          sec.settingKey_defaultVotingWeight: await sec.getDefaultVote(),
          sec.settingKey_defaultVotingWeightComments:
              await sec.getDefaultVoteComments(),
          sec.settingKey_showHidden: await sec.getShowHidden(),
          sec.settingKey_showNSFW: await sec.getNSFW(),
          sec.authKey_usernameKey: username!
        };
        yield SettingsLoadedState(settings: newSettings);
      } catch (e) {
        yield settingsErrorState(message: 'unknown error');
      }
    }
    if (event is PushSettingsEvent) {
      yield SettingsSavingState();
      try {
        await sec.persistSettings(
            event.newSettings[sec.settingKey_avalonNode]!,
            event.newSettings[sec.settingKey_defaultVotingWeight]!,
            event.newSettings[sec.settingKey_defaultVotingWeightComments]!,
            event.newSettings[sec.settingKey_showHidden]!,
            event.newSettings[sec.settingKey_showNSFW]!);

        yield SettingsSavedState(settings: event.newSettings);
      } catch (e) {
        yield settingsErrorState(message: 'unknown error');
      }
    }
  }
}
