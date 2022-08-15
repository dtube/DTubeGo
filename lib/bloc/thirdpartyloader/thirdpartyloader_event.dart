import 'package:equatable/equatable.dart';

abstract class ThirdPartyMetadataEvent extends Equatable {}

class LoadThirdPartyMetadataEvent extends ThirdPartyMetadataEvent {
  final String foreignSystemLink;
  LoadThirdPartyMetadataEvent(this.foreignSystemLink);
  @override
  List<Object> get props => List.empty();
}

class LoadThirdPartyChannelMetadataEvent extends ThirdPartyMetadataEvent {
  final String channelId;
  LoadThirdPartyChannelMetadataEvent(this.channelId);
  @override
  List<Object> get props => List.empty();
}

class CheckIfBioContainsVerificationCodeEvent extends ThirdPartyMetadataEvent {
  final String channelId;
  final String code;
  CheckIfBioContainsVerificationCodeEvent(
      {required this.channelId, required this.code});
  @override
  List<Object> get props => List.empty();
}
