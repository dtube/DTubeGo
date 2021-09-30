import 'package:dtube_go/bloc/settings/settings_event.dart';
import 'package:dtube_go/bloc/settings/settings_state.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
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
          sec.authKey_usernameKey: username,
          sec.settingKey_templateTitle: await sec.getTemplateTitle(),
          sec.settingKey_templateBody: await sec.getTemplateBody(),
          sec.settingKey_templateTag: await sec.getTemplateTag(),
          sec.settingKey_hiveSignerUsername: await sec.getHiveSignerUsername(),
          sec.settingKey_hiveSignerAccessTokenExpiresIn:
              await sec.getHiveSignerAccessTokenExpiresIn(),
          sec.settingKey_hiveSignerAccessTokenRequestedOn:
              await sec.getHiveSignerAccessTokenRequestedOn(),
          sec.settingKey_pincode: await sec.getPinCode(),
          sec.settingKey_imageUploadService: await sec.getImageUploadService(),
          sec.settingKey_ExploreTags: await sec.getExploreTags(),
        };
        yield SettingsLoadedState(settings: newSettings);
      } catch (e) {
        yield SettingsErrorState(message: 'unknown error');
      }
    }
    if (event is PushSettingsEvent) {
      yield SettingsSavingState();
      try {
        await sec.persistGeneralSettings(
            event.newSettings[sec.settingKey_showHidden]!,
            event.newSettings[sec.settingKey_showNSFW]!,
            event.newSettings[sec.settingKey_imageUploadService]!);
        await sec.persistAvalonSettings(
          event.newSettings[sec.settingKey_defaultVotingWeight]!,
          event.newSettings[sec.settingKey_defaultVotingWeightComments]!,
          event.newSettings[sec.settingKey_defaultVotingTip]!,
          event.newSettings[sec.settingKey_defaultVotingTipComments]!,
        );
        await sec.persistTemplateSettings(
          event.newSettings[sec.settingKey_templateTitle]!,
          event.newSettings[sec.settingKey_templateBody]!,
          event.newSettings[sec.settingKey_templateTag]!,
        );
        await sec
            .persistExploreTags(event.newSettings[sec.settingKey_ExploreTags]!);

        yield SettingsSavedState(settings: event.newSettings);
      } catch (e) {
        yield SettingsErrorState(message: 'unknown error');
      }
    }
    if (event is PushNewPinEvent) {
      yield SettingsSavingState();
      try {
        await sec.persistPinCode(event.newPin);

        yield PinSavedState();
      } catch (e) {
        yield SettingsErrorState(message: 'unknown error');
      }
    }
  }
}
