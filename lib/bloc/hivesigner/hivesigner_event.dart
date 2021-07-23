import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HivesignerEvent extends Equatable {}

class CheckAccessToken extends HivesignerEvent {
  CheckAccessToken();
  @override
  List<Object> get props => List.empty();
}

class RequestAccessToken extends HivesignerEvent {
  final BuildContext context;
  RequestAccessToken({required this.context});
  @override
  List<Object> get props => List.empty();
}
