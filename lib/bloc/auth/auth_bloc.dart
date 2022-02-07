import 'package:dtube_go/res/loadRemoteConf.dart' as remoteConfig;

import 'package:dtube_go/utils/crypto_convert.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:dtube_go/bloc/auth/auth_event.dart';
import 'package:dtube_go/bloc/auth/auth_state.dart';
import 'package:dtube_go/bloc/auth/auth_repository.dart';

import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_go/utils/discoverAPINode.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitialState()) {
    on<AppStartedEvent>((event, emit) async {
      await remoteConfig.initConf();
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();
      String? _privKey = await sec.getPrivateKey();
      bool _onbordingJourneyDone = await sec.getOnbordingJourneyDone();
      bool _termsAccepted = await sec.getTermsAccepted();

      emit(SignInLoadingState());
      // commented out for debugging
      _avalonApiNode = await discoverAPINode();
      await sec.persistNode(_avalonApiNode);
      repository.fetchAndStoreVerifiedUsers();

      // if the app has never been opened before
      if (!_onbordingJourneyDone) {
        emit(NeverUsedTheAppBeforeState());
      } else {
        // if the app has been opened before
        try {
          // if we can find login information in the secure storage
          if (_applicationUser != "" && _privKey != "") {
            if (_applicationUser == "na") {
              emit(SignedInState(
                  firstSignIn: true, termsAccepted: _termsAccepted));
            } else {
              // try to signin
              bool keyIsValid = await repository.signInWithCredentials(
                  _avalonApiNode, _applicationUser, _privKey);
              // if the signin is legit
              if (keyIsValid) {
                emit(SignedInState(
                    firstSignIn: true, termsAccepted: _termsAccepted));
                // if the sigin is not legit (anymore)
              } else {
                emit(SignInFailedState(
                    message: "login failed", username: _applicationUser));
              }
            }

            // if there was no signin information stored in the secure storage
          } else {
            emit(NoSignInInformationFoundState());
          }
          // if that part fails usually the selected api node is offline
        } catch (e) {
          emit(ApiNodeOfflineState());
        }
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(SignOutInitiatedState());
      try {
        var loggedOut = await repository.signOut();

        if (loggedOut) {
          emit(SignOutCompleteState());
          // restart the app
          Phoenix.rebirth(event.context);
        }
        // if the signout did not work (never happened)
      } catch (e) {
        emit(AuthErrorState(message: 'unknown error\n\n' + e.toString()));
      }
    });

    on<SignInWithCredentialsEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();

      bool _termsAccepted = await sec.getTermsAccepted();
      emit(SignInLoadingState());
      try {
        // check the signin data
        bool keyIsValid = await repository.signInWithCredentials(
            _avalonApiNode, event.username, event.privateKey);
        // if the login is legit
        if (keyIsValid) {
          // save the information in the secure storage
          sec.persistUsernameKey(event.username, event.privateKey);

          emit(SignedInState(firstSignIn: true, termsAccepted: _termsAccepted));
        } else {
          // if the login is not legit
          emit(SignInFailedState(
              message: 'login failed', username: event.username));
        }
      } catch (e) {
        emit(AuthErrorState(message: 'unknown error\n\n' + e.toString()));
      }
    });

    on<CheckCredentialsEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      try {
        // check the signin data
        List<int> _txTypes = await repository.getTxTypesForCredentials(
            _avalonApiNode, event.username, event.privateKey);
        // if the login is legit
        if (_txTypes.isNotEmpty) {
          emit(CheckCredentialsValidState(
              publicKey: privToPub(event.privateKey), txTypes: _txTypes));
        } else {
          // if the login is not legit
          emit(CheckCredentialsInValidState());
        }
      } catch (e) {
        emit(CheckCredentialsInValidState());
      }
    });

    on<StartBrowseOnlyMode>((event, emit) async {
      bool _termsAccepted = await sec.getTermsAccepted();
      emit(SignInLoadingState());
      try {
        sec.persistUsernameKey("na", "na");
        await repository.browseOnlyPermissions();

        emit(SignedInState(firstSignIn: true, termsAccepted: _termsAccepted));
      } catch (e) {
        emit(AuthErrorState(message: 'unknown error\n\n' + e.toString()));
      }
    });

    on<AuthSetInitState>((event, emit) async {
      emit(AuthInitialState());
    });
  }
}
