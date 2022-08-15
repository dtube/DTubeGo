import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HivesignerEvent extends Equatable {}

class CheckAccessToken extends HivesignerEvent {
  final String hiveSignerUsername;
  CheckAccessToken({required this.hiveSignerUsername});
  @override
  List<Object> get props => List.empty();
}

class RequestAccessToken extends HivesignerEvent {
  final BuildContext context;
  RequestAccessToken({required this.context});
  @override
  List<Object> get props => List.empty();
}

class SendPostToHive extends HivesignerEvent {
  final String postTitle;
  final String postBody;
  final String permlink;

  final String dtubeUrl;

  final String thumbnailUrl;
  final String videoUrl;
  final String storageType;
  final String tag;
  final String dtubeuser;

  SendPostToHive(
      {required this.postTitle,
      required this.postBody,
      required this.permlink,
      required this.dtubeUrl,
      required this.thumbnailUrl,
      required this.videoUrl,
      required this.storageType,
      required this.tag,
      required this.dtubeuser});
  @override
  List<Object> get props => List.empty();
}
