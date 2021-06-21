import 'package:equatable/equatable.dart';

abstract class ThirdPartyMetadataEvent extends Equatable {}

class LoadThirdPartyMetadataEvent extends ThirdPartyMetadataEvent {
  late String foreignSystemLink;
  LoadThirdPartyMetadataEvent(this.foreignSystemLink);
  @override
  List<Object> get props => List.empty();
}
