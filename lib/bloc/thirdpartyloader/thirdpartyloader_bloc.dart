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
      : super(ThirdPartyMetadataInitialState());

  // @override

  // ThirdPartyMetadataState get initialState => ThirdPartyMetadataInitialState();

  @override
  Stream<ThirdPartyMetadataState> mapEventToState(
      ThirdPartyMetadataEvent event) async* {
    if (event is LoadThirdPartyMetadataEvent) {
      yield ThirdPartyMetadataLoadingState();
      try {
        ThirdPartyMetadata _metadata =
            await repository.getMetadata(event.foreignSystemLink);
        yield ThirdPartyMetadataLoadedState(metadata: _metadata);
      } catch (e) {
        yield ThirdPartyMetadataErrorState(message: 'unknown error');
      }
    }
    if (event is CheckIfBioContainsVerificationCodeEvent) {
      yield ThirdPartyMetadataLoadingState();
      try {
        bool bioContainsCode = await repository.getChannelCodeInserted(
            event.channelId, event.code);
        yield ThirdPartyMetadataBioContainsCodeLoadedState(
            value: bioContainsCode);
      } catch (e) {
        yield ThirdPartyMetadataErrorState(message: 'incorrect channel id');
      }
    }
  }
}
