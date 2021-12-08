import 'package:equatable/equatable.dart';

abstract class ThirdPartyMetadataEvent extends Equatable {}

class LoadThirdPartyMetadataEvent extends ThirdPartyMetadataEvent {
  late String foreignSystemLink;
  LoadThirdPartyMetadataEvent(this.foreignSystemLink);
  @override
  List<Object> get props => List.empty();
}

class LoadThirdPartyChannelMetadataEvent extends ThirdPartyMetadataEvent {
  late String channelId;
  LoadThirdPartyChannelMetadataEvent(this.channelId);
  @override
  List<Object> get props => List.empty();
}

class CheckIfBioContainsVerificationCodeEvent extends ThirdPartyMetadataEvent {
  late String channelId;
  late String code;
  CheckIfBioContainsVerificationCodeEvent(
      {required this.channelId, required this.code});
  @override
  List<Object> get props => List.empty();
}
