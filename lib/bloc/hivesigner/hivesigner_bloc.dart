import 'package:flutter/services.dart';

import 'package:dtube_togo/bloc/hivesigner/hivesigner_event.dart';
import 'package:dtube_togo/bloc/hivesigner/hivesigner_state.dart';
import 'package:dtube_togo/bloc/hivesigner/hivesigner_repository.dart';

import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HivesignerBloc extends Bloc<HivesignerEvent, HivesignerState> {
  HivesignerRepository repository;

  HivesignerBloc({required this.repository}) : super(HivesignerInitialState());

  //@override

  //HivesignerState get initialState => HivesignerInitialState();
  // TODO: error handling
  @override
  Stream<HivesignerState> mapEventToState(HivesignerEvent event) async* {
    if (event is CheckAccessToken) {
      yield HiveSignerAccessTokenLoadingState();
      bool currentAccessTokenIsValid =
          await repository.checkCurrentAccessToken();
      if (currentAccessTokenIsValid) {
        yield HiveSignerAccessTokenValidState();
      } else {
        yield HiveSignerAccessTokenInvalidState(
            message: 'expired token or not set');
        try {
          bool newAccessTokenCreated =
              await repository.requestNewAccessToken(event.hiveSignerUsername);
          if (newAccessTokenCreated) {
            yield HiveSignerAccessTokenValidState();
          } else {
            yield HivesignerErrorState(message: 'unknown error');
          }
        } on PlatformException catch (e) {
          HivesignerErrorState(message: e.toString());
        }
      }
    }
    if (event is SendPostToHive) {
      yield HiveSignerTransactionPreparing();
      String transactionBody = await repository.preparePostTransaction(
          event.permlink,
          event.postTitle,
          event.postBody,
          event.dtubeUrl,
          event.thumbnailUrl,
          event.videoUrl,
          event.storageType,
          event.tag);
      yield HiveSignerTransactionBroadcasting();
      bool postPublished =
          await repository.broadcastPostToHive(transactionBody);
      if (postPublished) {
        yield HiveSignerTransactionSent();
      } else {
        yield HiveSignerTransactionError(message: 'unknown error');
      }
    }
  }
}
