import 'package:flutter/services.dart';

import 'package:dtube_go/bloc/hivesigner/hivesigner_event.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_state.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_repository.dart';

import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HivesignerBloc extends Bloc<HivesignerEvent, HivesignerState> {
  HivesignerRepository repository;

  HivesignerBloc({required this.repository}) : super(HivesignerInitialState()) {
    on<CheckAccessToken>((event, emit) async {
      emit(HiveSignerAccessTokenLoadingState());
      bool currentAccessTokenIsValid =
          await repository.checkCurrentAccessToken();
      if (currentAccessTokenIsValid) {
        emit(HiveSignerAccessTokenValidState());
      } else {
        emit(HiveSignerAccessTokenInvalidState(
            message: 'expired token or not set'));
        try {
          bool newAccessTokenCreated =
              await repository.requestNewAccessToken(event.hiveSignerUsername);
          if (newAccessTokenCreated) {
            emit(HiveSignerAccessTokenValidState());
          } else {
            emit(HivesignerErrorState(message: 'unknown error'));
          }
        } on PlatformException catch (e) {
          emit(HivesignerErrorState(message: e.toString()));
        }
      }
    });

    on<SendPostToHive>((event, emit) async {
      emit(HiveSignerTransactionPreparing());
      String transactionBody = await repository.preparePostTransaction(
          event.permlink,
          event.postTitle,
          event.postBody,
          event.dtubeUrl,
          event.thumbnailUrl,
          event.videoUrl,
          event.storageType,
          event.tag,
          event.dtubeuser);
      emit(HiveSignerTransactionBroadcasting());
      bool postPublished =
          await repository.broadcastPostToHive(transactionBody);
      if (postPublished) {
        emit(HiveSignerTransactionSent());
      } else {
        emit(HiveSignerTransactionError(message: 'unknown error'));
      }
    });
  }
}
