import 'package:flutter/material.dart';

class MomentsItem {
  final Duration duration;
  bool shown;

  /// The page content
  final Widget view;
  MomentsItem(
    this.view, {
    required this.duration,
    this.shown = false,
  });
}
