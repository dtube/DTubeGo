import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:dtube_togo/bloc/auth/auth_event.dart';
import 'package:dtube_togo/bloc/auth/auth_state.dart';
import 'package:dtube_togo/bloc/auth/auth_repository.dart';
import 'package:dtube_togo/realMain.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_togo/utils/discoverAPINode.dart';
import 'package:flutter/material.dart';

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
    if (event is AppStartedEvent) {
      yield SignInLoadingState();
      _avalonApiNode = await discoverAPINode();
      sec.persistNode(_avalonApiNode);
      try {
        if (_applicationUser != null && _privKey != null) {
          bool keyIsValid = await repository.signInWithCredentials(
              _avalonApiNode, _applicationUser, _privKey);

          if (keyIsValid) {
            //sec.persistUsernameKey(event.username, event.privateKey);
            yield SignedInState();
          } else {
            yield SignInFailedState(message: "login failed");
          }
        } else {
          yield NoSignInInformationFoundState();
        }
      } catch (e) {
        yield ApiNodeOfflineState();
      }
    }
    if (event is SignOutEvent) {
      yield SignOutInitiatedState();
      try {
        var loggedOut = await repository.signOut();

        if (loggedOut) {
          //sec.persistUsernameKey(event.username, event.privateKey);
          yield SignOutCompleteState();
          Phoenix.rebirth(event.context);
        }
      } catch (e) {
        yield AuthErrorState(message: 'unknown error');
      }
    }

    if (event is SignInWithCredentialsEvent) {
      yield SignInLoadingState();
      try {
        bool keyIsValid = await repository.signInWithCredentials(
            _avalonApiNode, event.username, event.privateKey);
        if (keyIsValid) {
          sec.persistUsernameKey(event.username, event.privateKey);
          yield SignedInState();
        } else {
          yield SignInFailedState(
              message:
                  'login failed: Please check your username and key (we currently do not support login with the master key)');
        }
      } catch (e) {
        yield AuthErrorState(message: 'unknown error');
      }
    }
  }
}
