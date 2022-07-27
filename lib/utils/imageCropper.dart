import 'dart:io';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File> cropImage(File currentThumbnail) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: currentThumbnail.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              // CropAspectRatioPreset.square,
              // CropAspectRatioPreset.ratio3x2,
              // CropAspectRatioPreset.original,
              // CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              //     CropAspectRatioPreset.original,
              //     CropAspectRatioPreset.square,
              //     CropAspectRatioPreset.ratio3x2,
              //     CropAspectRatioPreset.ratio4x3,
              //     CropAspectRatioPreset.ratio5x3,
              //     CropAspectRatioPreset.ratio5x4,
              //     CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: globalAlmostWhite,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            hideBottomControls: false,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        )
      ]);
  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    return currentThumbnail;
  }
}
