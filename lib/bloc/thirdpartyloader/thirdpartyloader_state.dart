import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class ThirdPartyMetadataState extends Equatable {}

// general user states
class ThirdPartyMetadataInitialState extends ThirdPartyMetadataState {
  List<Object> get props => [];
}

class ThirdPartyMetadataLoadingState extends ThirdPartyMetadataState {
  List<Object> get props => [];
}

class ThirdPartyMetadataLoadedState extends ThirdPartyMetadataState {
  final ThirdPartyMetadata metadata;

  ThirdPartyMetadataLoadedState({required this.metadata});

  List<Object> get props => [metadata];
}

class ThirdPartyMetadataErrorState extends ThirdPartyMetadataState {
  final String message;

  ThirdPartyMetadataErrorState({required this.message});

  List<Object> get props => [message];
}

class ThirdPartyMetadataBioContainsCodeLoadedState
    extends ThirdPartyMetadataState {
  final bool value;

  ThirdPartyMetadataBioContainsCodeLoadedState({required this.value});

  List<Object> get props => [value];
}
