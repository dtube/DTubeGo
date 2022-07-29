import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:dtube_go/bloc/settings/settings_event.dart';
import 'package:dtube_go/bloc/settings/settings_state.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitialState()) {
    on<FetchSettingsEvent>((event, emit) async {
      emit(SettingsLoadingState());
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
          sec.settingKey_momentTitle: await sec.getMomentTitle(),
          sec.settingKey_momentBody: await sec.getMomentBody(),
          sec.settingKey_templateTag: await sec.getTemplateTag(),
          sec.settingKey_hiveSignerUsername: await sec.getHiveSignerUsername(),
          sec.settingKey_hiveSignerAccessTokenExpiresIn:
              await sec.getHiveSignerAccessTokenExpiresIn(),
          sec.settingKey_hiveSignerAccessTokenRequestedOn:
              await sec.getHiveSignerAccessTokenRequestedOn(),
          sec.settingKey_pincode: await sec.getPinCode(),
          sec.settingKey_videoAutoPause: await sec.getVideoAutoPause(),
          sec.settingKey_disableAnimations: await sec.getDisableAnimations(),
          sec.settingKey_imageUploadService: await sec.getImageUploadService(),
          sec.settingKey_DefaultUploadNSFW: await sec.getUploadNSFW(),
          sec.settingKey_DefaultUploadOC: await sec.getUploadOC(),
          sec.settingKey_DefaultUploadUnlist: await sec.getUploadUnlist(),
          sec.settingKey_DefaultUploadCrosspost: await sec.getUploadCrosspost(),
          sec.settingKey_DefaultMomentNSFW: await sec.getMomentNSFW(),
          sec.settingKey_DefaultMomentOC: await sec.getMomentOC(),
          sec.settingKey_DefaultMomentUnlist: await sec.getMomentUnlist(),
          sec.settingKey_DefaultMomentCrosspost: await sec.getMomentCrosspost(),
          sec.settingKey_DefaultUploadVotingWeigth:
              await sec.getUploadVotingWeight(),
          sec.settingKey_DefaultMomentVotingWeigth:
              await sec.getMomentVotingWeight(),
          sec.settingKey_HiveStillInCooldown:
              await sec.getSecondsUntilHiveCooldownEnds().toString(),
          sec.settingKey_hiveSignerDefaultCommunity:
              await sec.getHiveSignerDefaultCommunity(),
          sec.settingKey_hiveSignerDefaultTags:
              await sec.getHiveSignerDefaultTags(),
          sec.settingKey_FixedDownvoteActivated:
              await sec.getFixedDownvoteActivated(),
          sec.settingKey_FixedDownvoteWeight:
              await sec.getFixedDownvoteWeight(),
          sec.settingKey_videoAutoPause: await sec.getVideoAutoPause(),
          sec.settingKey_disableAnimations: await sec.getDisableAnimations()
        };
        globals.disableAnimations = await sec.getDisableAnimations() == "true";
        emit(SettingsLoadedState(settings: newSettings));
      } catch (e) {
        emit(SettingsErrorState(message: 'unknown error'));
      }
    });

    on<PushSettingsEvent>((event, emit) async {
      emit(SettingsSavingState());
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
          event.newSettings[sec.settingKey_FixedDownvoteActivated]!,
          event.newSettings[sec.settingKey_FixedDownvoteWeight]!,
        );
        await sec.persistTemplateSettings(
          event.newSettings[sec.settingKey_templateTitle]!,
          event.newSettings[sec.settingKey_templateBody]!,
          event.newSettings[sec.settingKey_templateTag]!,
        );
        await sec.persistMomentTemplateSettings(
          event.newSettings[sec.settingKey_momentTitle]!,
          event.newSettings[sec.settingKey_momentBody]!,
        );
        await sec.persistDefaultUploadAndMomentSettings(
          event.newSettings[sec.settingKey_DefaultUploadVotingWeigth]!,
          event.newSettings[sec.settingKey_DefaultMomentVotingWeigth]!,
          event.newSettings[sec.settingKey_DefaultUploadNSFW]!,
          event.newSettings[sec.settingKey_DefaultUploadOC]!,
          event.newSettings[sec.settingKey_DefaultUploadUnlist]!,
          event.newSettings[sec.settingKey_DefaultUploadCrosspost]!,
          event.newSettings[sec.settingKey_DefaultMomentNSFW]!,
          event.newSettings[sec.settingKey_DefaultMomentOC]!,
          event.newSettings[sec.settingKey_DefaultMomentUnlist]!,
          event.newSettings[sec.settingKey_DefaultMomentCrosspost]!,
        );

        await sec.persistHiveSignerAdditionalData(
            event.newSettings[sec.settingKey_hiveSignerDefaultCommunity]!,
            event.newSettings[sec.settingKey_hiveSignerDefaultTags]!);

        await sec.persistVideoAutoPause(
            event.newSettings[sec.settingKey_videoAutoPause]!);

        await sec.persistDisableAnimations(
            event.newSettings[sec.settingKey_disableAnimations]!);
        globals.disableAnimations =
            event.newSettings[sec.settingKey_disableAnimations]! == "true";

        emit(SettingsSavedState(settings: event.newSettings));
        Phoenix.rebirth(event.context);
      } catch (e) {
        emit(SettingsErrorState(message: 'unknown error'));
      }
    });
    on<PushNewPinEvent>((event, emit) async {
      emit(SettingsSavingState());
      try {
        await sec.persistPinCode(event.newPin);

        emit(PinSavedState());
      } catch (e) {
        emit(SettingsErrorState(message: 'unknown error'));
      }
    });
  }
}
