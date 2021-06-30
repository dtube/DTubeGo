import 'package:dtube_togo/bloc/settings/settings_event.dart';
import 'package:dtube_togo/bloc/settings/settings_state.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitialState());

  // @override

  // SettingsState get initialState => SettingsInitialState();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is FetchSettingsEvent) {
      yield SettingsLoadingState();
      try {
        String? username = await sec.getUsername();
        Map<String, String> newSettings = {
          sec.settingKey_defaultVotingWeight: await sec.getDefaultVote(),
          sec.settingKey_defaultVotingWeightComments:
              await sec.getDefaultVoteComments(),
          sec.settingKey_defaultVotingTip: await sec.getDefaultVoteTip(),
          sec.settingKey_defaultVotingTipComments:
              await sec.getDefaultVoteTipComments(),
          sec.settingKey_showHidden: await sec.getShowHidden(),
          sec.settingKey_showNSFW: await sec.getNSFW(),
          sec.authKey_usernameKey: username!
        };
        yield SettingsLoadedState(settings: newSettings);
      } catch (e) {
        yield SettingsErrorState(message: 'unknown error');
      }
    }
    if (event is PushSettingsEvent) {
      yield SettingsSavingState();
      try {
        await sec.persistSettings(
            event.newSettings[sec.settingKey_defaultVotingWeight]!,
            event.newSettings[sec.settingKey_defaultVotingWeightComments]!,
            event.newSettings[sec.settingKey_defaultVotingTip]!,
            event.newSettings[sec.settingKey_defaultVotingTipComments]!,
            event.newSettings[sec.settingKey_showHidden]!,
            event.newSettings[sec.settingKey_showNSFW]!);

        yield SettingsSavedState(settings: event.newSettings);
      } catch (e) {
        yield SettingsErrorState(message: 'unknown error');
      }
    }
  }
}
