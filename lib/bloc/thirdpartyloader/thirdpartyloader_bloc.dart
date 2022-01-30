import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_event.dart';
import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_repository.dart';
import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_response_model.dart';
import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_state.dart';

import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ThirdPartyMetadataBloc
    extends Bloc<ThirdPartyMetadataEvent, ThirdPartyMetadataState> {
  ThirdPartyMetadataRepository repository;
  ThirdPartyMetadataBloc({required this.repository})
      : super(ThirdPartyMetadataInitialState()) {
    on<LoadThirdPartyMetadataEvent>((event, emit) async {
      try {
        ThirdPartyMetadata _metadata =
            await repository.getMetadata(event.foreignSystemLink);
        emit(ThirdPartyMetadataLoadedState(metadata: _metadata));
      } catch (e) {
        emit(ThirdPartyMetadataErrorState(message: 'unknown error'));
      }
    });

    on<CheckIfBioContainsVerificationCodeEvent>((event, emit) async {
      emit(ThirdPartyMetadataLoadingState());
      try {
        bool bioContainsCode = await repository.getChannelCodeInserted(
            event.channelId, event.code);
        emit(ThirdPartyMetadataBioContainsCodeLoadedState(
            value: bioContainsCode));
      } catch (e) {
        emit(ThirdPartyMetadataErrorState(message: 'incorrect channel id'));
      }
    });
  }
}
