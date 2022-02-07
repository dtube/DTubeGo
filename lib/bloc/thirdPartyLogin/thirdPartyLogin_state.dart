import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class ThirdPartyLoginState extends Equatable {}

class ThirdPartyLoginInitialState extends ThirdPartyLoginState {
  @override
  List<Object> get props => [];
}

class ThirdPartyLoginLoadingState extends ThirdPartyLoginState {
  @override
  List<Object> get props => [];
}

class ThirdPartyLoginLoadedState extends ThirdPartyLoginState {
  ThirdPartyLoginEncrypted encryptedLoginData;

  ThirdPartyLoginLoadedState({required this.encryptedLoginData});

  @override
  List<Object> get props => [encryptedLoginData];
}

class ThirdPartyLoginNotFoundState extends ThirdPartyLoginState {
  ThirdPartyLoginEncrypted encryptedLoginData;
  ThirdPartyLoginNotFoundState({required this.encryptedLoginData});
  @override
  List<Object> get props => [encryptedLoginData];
}

class ThirdPartyLoginDecryptingState extends ThirdPartyLoginState {
  ThirdPartyLoginDecryptingState();

  @override
  List<Object> get props => [];
}

class ThirdPartyLoginDecryptedState extends ThirdPartyLoginState {
  ThirdPartyLoginDecrypted decryptedLoginData;

  ThirdPartyLoginDecryptedState({required this.decryptedLoginData});

  @override
  List<Object> get props => [decryptedLoginData];
}

class ThirdPartyLoginEncryptingState extends ThirdPartyLoginState {
  ThirdPartyLoginEncryptingState();

  @override
  List<Object> get props => [];
}

class ThirdPartyLoginEncryptedState extends ThirdPartyLoginState {
  ThirdPartyLoginEncrypted encryptedLoginData;

  ThirdPartyLoginEncryptedState({required this.encryptedLoginData});

  @override
  List<Object> get props => [encryptedLoginData];
}

class ThirdPartyLoginStoringState extends ThirdPartyLoginState {
  ThirdPartyLoginStoringState();

  @override
  List<Object> get props => [];
}

class ThirdPartyLoginStoredState extends ThirdPartyLoginState {
  ThirdPartyLoginDecrypted decryptedLoginData;
  ThirdPartyLoginStoredState({required this.decryptedLoginData});

  @override
  List<Object> get props => [decryptedLoginData];
}

class ThirdPartyLoginErrorState extends ThirdPartyLoginState {
  String message;

  ThirdPartyLoginErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
