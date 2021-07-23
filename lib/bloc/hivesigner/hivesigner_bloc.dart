import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:dtube_togo/bloc/hivesigner/hivesigner_event.dart';
import 'package:dtube_togo/bloc/hivesigner/hivesigner_state.dart';
import 'package:dtube_togo/bloc/hivesigner/hivesigner_repository.dart';
import 'package:dtube_togo/realMain.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_togo/utils/discoverAPINode.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class HivesignerBloc extends Bloc<HivesignerEvent, HivesignerState> {
  HivesignerRepository repository;

  HivesignerBloc({required this.repository}) : super(HivesignerInitialState());

  //@override

  //HivesignerState get initialState => HivesignerInitialState();

  @override
  Stream<HivesignerState> mapEventToState(HivesignerEvent event) async* {
    if (event is CheckAccessToken) {
      yield AccessTokenLoadingState();
      bool currentAccessTokenIsValid =
          await repository.checkCurrentAccessToken();
      if (currentAccessTokenIsValid) {
        yield AccessTokenValidState();
      } else {
        yield AccessTokenInvalidState(message: 'expired token or not set');
        try {
          bool newAccessTokenCreated = await repository.requestNewAccessToken();
          if (newAccessTokenCreated) {
            yield AccessTokenValidState();
          } else {
            yield HivesignerErrorState(message: 'unknown error');
          }
        } on PlatformException catch (e) {
          HivesignerErrorState(message: e.toString());
        }
      }
    }
  }
}
