import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class ThirdPartyLoginState extends Equatable {}

class ThirdPartyLoginInitialState extends ThirdPartyLoginState {
  List<Object> get props => [];
}

class ThirdPartyLoginLoadingState extends ThirdPartyLoginState {
  List<Object> get props => [];
}

class ThirdPartyLoginLoadedState extends ThirdPartyLoginState {
  final ThirdPartyLoginEncrypted encryptedLoginData;

  ThirdPartyLoginLoadedState({required this.encryptedLoginData});

  List<Object> get props => [encryptedLoginData];
}

class ThirdPartyLoginNotFoundState extends ThirdPartyLoginState {
  final ThirdPartyLoginEncrypted encryptedLoginData;
  ThirdPartyLoginNotFoundState({required this.encryptedLoginData});

  List<Object> get props => [encryptedLoginData];
}

class ThirdPartyLoginDecryptingState extends ThirdPartyLoginState {
  ThirdPartyLoginDecryptingState();

  List<Object> get props => [];
}

class ThirdPartyLoginDecryptedState extends ThirdPartyLoginState {
  final ThirdPartyLoginDecrypted decryptedLoginData;

  ThirdPartyLoginDecryptedState({required this.decryptedLoginData});

  List<Object> get props => [decryptedLoginData];
}

class ThirdPartyLoginEncryptingState extends ThirdPartyLoginState {
  ThirdPartyLoginEncryptingState();

  List<Object> get props => [];
}

class ThirdPartyLoginEncryptedState extends ThirdPartyLoginState {
  final ThirdPartyLoginEncrypted encryptedLoginData;

  ThirdPartyLoginEncryptedState({required this.encryptedLoginData});

  List<Object> get props => [encryptedLoginData];
}

class ThirdPartyLoginStoringState extends ThirdPartyLoginState {
  ThirdPartyLoginStoringState();

  List<Object> get props => [];
}

class ThirdPartyLoginStoredState extends ThirdPartyLoginState {
  final ThirdPartyLoginDecrypted decryptedLoginData;
  ThirdPartyLoginStoredState({required this.decryptedLoginData});

  List<Object> get props => [decryptedLoginData];
}

class ThirdPartyLoginErrorState extends ThirdPartyLoginState {
  final String message;

  ThirdPartyLoginErrorState({required this.message});

  List<Object> get props => [message];
}
