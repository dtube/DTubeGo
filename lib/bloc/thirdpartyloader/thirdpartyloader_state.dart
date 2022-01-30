import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class ThirdPartyMetadataState extends Equatable {}

// general user states
class ThirdPartyMetadataInitialState extends ThirdPartyMetadataState {
  @override
  List<Object> get props => [];
}

class ThirdPartyMetadataLoadingState extends ThirdPartyMetadataState {
  @override
  List<Object> get props => [];
}

class ThirdPartyMetadataLoadedState extends ThirdPartyMetadataState {
  ThirdPartyMetadata metadata;
  @override
  ThirdPartyMetadataLoadedState({required this.metadata});

  List<Object> get props => [metadata];
}

class ThirdPartyMetadataErrorState extends ThirdPartyMetadataState {
  String message;

  ThirdPartyMetadataErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class ThirdPartyMetadataBioContainsCodeLoadedState
    extends ThirdPartyMetadataState {
  bool value;
  @override
  ThirdPartyMetadataBioContainsCodeLoadedState({required this.value});

  List<Object> get props => [value];
}
