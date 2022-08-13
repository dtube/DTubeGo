import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_bloc_full.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ThirdPartyLoginEvent extends Equatable {}

class TryThirdPartyLoginEvent extends ThirdPartyLoginEvent {
  final String socialProvider;
  final String socialUId;
  TryThirdPartyLoginEvent(
      {required this.socialProvider, required this.socialUId});

  @override
  List<Object> get props => List.empty();
}

class DecryptThirdPartyLoginEvent extends ThirdPartyLoginEvent {
  final ThirdPartyLoginEncrypted data;
  final String password;
  final String socialUId;

  DecryptThirdPartyLoginEvent(
      {required this.data, required this.password, required this.socialUId});

  @override
  List<Object> get props => List.empty();
}

class EncryptThirdPartyLoginEvent extends ThirdPartyLoginEvent {
  final ThirdPartyLoginDecrypted data;
  final String password;
  final String socialUId;

  EncryptThirdPartyLoginEvent(
      {required this.data, required this.password, required this.socialUId});

  @override
  List<Object> get props => List.empty();
}

class StoreThirdPartyLoginEvent extends ThirdPartyLoginEvent {
  final ThirdPartyLoginDecrypted data;

  final String password;
  final String socialUId;
  StoreThirdPartyLoginEvent(
      {required this.data, required this.password, required this.socialUId});

  @override
  List<Object> get props => List.empty();
}
