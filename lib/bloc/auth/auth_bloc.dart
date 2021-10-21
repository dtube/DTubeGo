import 'package:dtube_go/res/appConfigValues.dart';
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

  AuthBloc({required this.repository}) : super(AuthInitialState());

  //@override

  //AuthState get initialState => AuthInitialState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    String _avalonApiNode = await sec.getNode();
    String? _applicationUser = await sec.getUsername();
    String? _privKey = await sec.getPrivateKey();
    bool _openedOnce = await sec.getOpenedOnce();

    // event when the app gets started
    if (event is AppStartedEvent) {
      yield SignInLoadingState();
      // commented out for debugging
      _avalonApiNode = await discoverAPINode();
      await sec.persistNode(_avalonApiNode);
      repository.fetchAndStoreVerifiedUsers();

      // if the app has never been opened before
      if (!_openedOnce) {
        yield NeverUsedTheAppBeforeState();
      } else {
        // if the app has been opened before
        try {
          // if we can find login information in the secure storage
          if (_applicationUser != "" && _privKey != "") {
            // try to signin
            bool keyIsValid = await repository.signInWithCredentials(
                _avalonApiNode, _applicationUser, _privKey);
            // if the signin is legit
            if (keyIsValid) {
              yield SignedInState(firstSignIn: true);
              // if the sigin is not legit (anymore)
            } else {
              yield SignInFailedState(
                  message: "login failed", username: _applicationUser);
            }
            // if there was no signin information stored in the secure storage
          } else {
            yield NoSignInInformationFoundState();
          }
          // if that part fails usually the selected api node is offline
        } catch (e) {
          yield ApiNodeOfflineState();
        }
      }
    }
    // if the user wants to signout
    if (event is SignOutEvent) {
      yield SignOutInitiatedState();
      try {
        var loggedOut = await repository.signOut();

        if (loggedOut) {
          yield SignOutCompleteState();
          // restart the app
          Phoenix.rebirth(event.context);
        }
        // if the signout did not work (never happened)
      } catch (e) {
        yield AuthErrorState(message: 'unknown error');
      }
    }
    // if the user wants to sign in
    if (event is SignInWithCredentialsEvent) {
      yield SignInLoadingState();
      try {
        // check the signin data
        bool keyIsValid = await repository.signInWithCredentials(
            _avalonApiNode, event.username, event.privateKey);
        // if the login is legit
        if (keyIsValid) {
          // save the information in the secure storage
          sec.persistUsernameKey(event.username, event.privateKey);

          yield SignedInState(firstSignIn: true);
        } else {
          // if the login is not legit
          yield SignInFailedState(
              message: 'login failed', username: event.username);
        }
      } catch (e) {
        yield AuthErrorState(message: 'unknown error');
      }
    }
  }
}
