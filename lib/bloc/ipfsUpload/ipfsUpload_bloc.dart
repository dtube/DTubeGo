import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_state.dart';

import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IPFSUploadBloc extends Bloc<IPFSUploadEvent, IPFSUploadState> {
  IPFSUploadRepository repository;

  IPFSUploadBloc({required this.repository}) : super(IPFSUploadInitialState());

  // @override

  // IPFSUploadState get initialState => IPFSUploadInitialState();

  @override
  Stream<IPFSUploadState> mapEventToState(IPFSUploadEvent event) async* {
    String _uploadEndpoint = "";
    String _thumbnailUploadToken = "";
    String _videoUploadToken = "";
    File _newFile;
    late Map _uploadStatusResponse;
    late Map _thumbUploadStatusResponse;
    if (event is UploadVideo) {
      yield IPFSUploadVideoPreProcessingState();

      if (!(p.extension(event.videoPath) == ".mov" ||
          p.extension(event.videoPath) == ".mp4")) {
        _newFile = await repository.compressVideo(event.videoPath);
      } else {
        _newFile = File(event.videoPath);
      }

      String _newThumbnail =
          await repository.createThumbnailFromVideo(event.videoPath);

      yield IPFSUploadVideoPreProcessedState(compressedFile: _newFile);
      try {
        _uploadEndpoint = await repository.getUploadEndpoint();
        print("ENDPOINT: " + _uploadEndpoint);
        if (_uploadEndpoint == "") {
          yield IPFSUploadErrorState(message: "no valid endpoint found");
        } else {
          _videoUploadToken =
              await repository.uploadVideo(_newFile.path, _uploadEndpoint);
          print("TOKEN: " + _videoUploadToken);
          yield IPFSUploadVideoUploadedState(uploadToken: _videoUploadToken);
          try {
            do {
              _uploadStatusResponse = await repository.monitorVideoUploadStatus(
                  _videoUploadToken, _uploadEndpoint);
              print(_uploadStatusResponse);
              yield IPFSUploadVideoPostProcessingState(
                  processingResponse: _uploadStatusResponse);
            } while (_uploadStatusResponse["finished"] == false);
            yield IPFSUploadVideoPostProcessedState(
                processingResponse: _uploadStatusResponse);
            try {
              _thumbnailUploadToken = await repository.uploadThumbnail(
                  event.thumbnailPath, _newThumbnail);
              do {
                _thumbUploadStatusResponse = await repository
                    .monitorThumbnailUploadStatus(_thumbnailUploadToken);
                print(_thumbUploadStatusResponse);
                yield IPFSUploadThumbnailUploadingState(
                    uploadingResponse: _thumbUploadStatusResponse);
              } while (_thumbUploadStatusResponse["ipfsAddSource"]["step"] !=
                      "Success" ||
                  _thumbUploadStatusResponse["ipfsAddOverlay"]["step"] !=
                      "Success");
              yield IPFSUploadThumbnailUploadedState(
                  uploadResponse: _thumbUploadStatusResponse);
            } catch (e) {
              print(e.toString());
              yield IPFSUploadErrorState(message: e.toString());
            }
          } catch (e) {
            print(e.toString());
            yield IPFSUploadErrorState(message: e.toString());
          }
        }
        // upload to ipfs
      } catch (e) {
        print(e.toString());
        yield IPFSUploadErrorState(message: e.toString());
      }
    }
  }
}
