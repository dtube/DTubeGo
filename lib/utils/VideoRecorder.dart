// probably not needed anymore because we use the internal camera

// More info: https://github.com/joeltok/flutter-camera-example/blob/main/src/camera.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  final Function(String) callback;
  CameraScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  late Future<void> cameraValue;
  bool isRecording = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    if (_cameraController != null) {}
    _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      cameraValue = _cameraController!.initialize();
    });
  }

  @override
  void initState() {
    super.initState();
    // Obtain a list of the available cameras on the device.
    _initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_cameraController!));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              flash = !flash;
                            });
                            flash
                                ? _cameraController!
                                    .setFlashMode(FlashMode.torch)
                                : _cameraController!
                                    .setFlashMode(FlashMode.off);
                          }),
                      GestureDetector(
                        onTap: () async {
                          if (!isRecording) {
                            await _cameraController!.startVideoRecording();
                            setState(() {
                              isRecording = true;
                            });
                          } else {
                            XFile videopath =
                                await _cameraController!.stopVideoRecording();
                            setState(() {
                              isRecording = false;
                            });
                            widget.callback(videopath.path);
                            Navigator.pop(
                              context,
                            );
                          }
                        },
                        child: isRecording
                            ? Icon(
                                Icons.radio_button_on,
                                color: Colors.red,
                                size: 80,
                              )
                            : Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70,
                              ),
                      ),
                      IconButton(
                          icon: Transform.rotate(
                            angle: transform,
                            child: Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              iscamerafront = !iscamerafront;
                              transform = transform + pi;
                            });
                            int cameraPos = iscamerafront ? 0 : 1;
                            _cameraController = CameraController(
                                cameras![cameraPos], ResolutionPreset.high);
                            cameraValue = _cameraController!.initialize();
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
