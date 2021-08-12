import 'dart:io';
import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/utils/randomPermlink.dart';
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
    late UploadData _uploadData;
    if (event is UploadVideo) {
      _uploadData = event.uploadData;
      yield IPFSUploadVideoPreProcessingState();

      // if (!(p.extension(event.videoPath) == ".mov" ||
      //     p.extension(event.videoPath) == ".mp4")) {

      _newFile = await repository.compressVideo(event.videoPath);
      // } else {
      //   _newFile = File(event.videoPath);
      // }

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
            var statusInfo = _uploadStatusResponse;

            _uploadData.videoSourceHash =
                statusInfo["ipfsAddSourceVideo"]["hash"];
            _uploadData.video240pHash =
                statusInfo["encodedVideos"][0]["ipfsAddEncodeVideo"]["hash"];
            _uploadData.video480pHash =
                statusInfo["encodedVideos"][1]["ipfsAddEncodeVideo"]["hash"];
            _uploadData.videoSpriteHash =
                statusInfo["ipfsAddSourceVideo"]["hash"];
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
              // just for testing: background uploader
              var statusInfo = _thumbUploadStatusResponse;

              _uploadData.thumbnail210Hash =
                  statusInfo["ipfsAddSource"]["hash"];
              _uploadData.thumbnail640Hash =
                  statusInfo["ipfsAddOverlay"]["hash"];
              _uploadData.thumbnailLocation =
                  statusInfo["ipfsAddOverlay"]["hash"];

              var voteValue =
                  (_uploadData.vpBalance * (_uploadData.vpPercent / 100))
                      .floor();
              _uploadData.link = randomPermlink(11);

              TransactionBloc txBloc =
                  TransactionBloc(repository: TransactionRepositoryImpl());

              txBloc.add(SendCommentEvent(_uploadData));
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
