import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_bloc_full.dart';

import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:flutter_phoenix/flutter_phoenix.dart';

class ThirdPartyLoginBloc
    extends Bloc<ThirdPartyLoginEvent, ThirdPartyLoginState> {
  ThirdPartyLoginRepository repository;

  ThirdPartyLoginBloc({required this.repository})
      : super(ThirdPartyLoginInitialState()) {
    // login part
    on<TryThirdPartyLoginEvent>((event, emit) async {
      emit(ThirdPartyLoginLoadingState());
      try {
        ThirdPartyLoginEncrypted _encryptedData = await repository
            .tryThirdPartyLogin(event.socialProvider, event.socialUId);

        if (_encryptedData.dTubePublicKey != "na") {
          emit(ThirdPartyLoginLoadedState(
              encryptedLoginData:
                  _encryptedData)); // will result in asking user to enter password
        } else {
          emit(ThirdPartyLoginNotFoundState(
              encryptedLoginData:
                  _encryptedData)); // will result in user creation
        }
      } catch (e) {
        emit(ThirdPartyLoginErrorState(message: e.toString()));
      }
    });

    // decrypting login part
    on<DecryptThirdPartyLoginEvent>((event, emit) async {
      emit(ThirdPartyLoginDecryptingState());
      try {
        ThirdPartyLoginDecrypted _decryptedData =
            await repository.decryptThirdPartyLogin(
                event.data, event.password, event.socialUId);

        await sec.persistUsernameKey(
            event.data.dTubeUsername, event.data.dTubeEncyptedPrivateKey);

        emit(ThirdPartyLoginDecryptedState(decryptedLoginData: _decryptedData));
      } catch (e) {
        emit(ThirdPartyLoginErrorState(message: e.toString()));
      }
    });

    // encrypting login part
    on<EncryptThirdPartyLoginEvent>((event, emit) async {
      emit(ThirdPartyLoginEncryptingState());
      try {
        ThirdPartyLoginEncrypted _encryptedData =
            await repository.encryptThirdPartyLogin(
                event.data, event.password, event.socialUId);

        emit(ThirdPartyLoginEncryptedState(encryptedLoginData: _encryptedData));
      } catch (e) {
        emit(ThirdPartyLoginErrorState(message: e.toString()));
      }
    });

    // storing login part
    on<StoreThirdPartyLoginEvent>((event, emit) async {
      emit(ThirdPartyLoginStoringState());
      try {
        ThirdPartyLoginEncrypted _encryptedData =
            await repository.encryptThirdPartyLogin(
                event.data, event.password, event.socialUId);

        bool stored = await repository.storeThirdPartyLogin(_encryptedData);

        if (stored) {
          await sec.persistUsernameKey(
              event.data.dTubeUsername, event.data.dTubeDecyptedPrivateKey);

          emit(ThirdPartyLoginStoredState(decryptedLoginData: event.data));
        } else {
          emit(ThirdPartyLoginErrorState(message: "saving failed"));
        }
      } catch (e) {
        emit(ThirdPartyLoginErrorState(message: e.toString()));
      }
    });
  }
}
