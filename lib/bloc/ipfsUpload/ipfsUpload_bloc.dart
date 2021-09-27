import 'dart:io';
import 'package:dtube_go/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/utils/randomPermlink.dart';

import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_state.dart';

import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

class IPFSUploadBloc extends Bloc<IPFSUploadEvent, IPFSUploadState> {
  IPFSUploadRepository repository;

  IPFSUploadBloc({required this.repository}) : super(IPFSUploadInitialState());

  @override
  Stream<IPFSUploadState> mapEventToState(IPFSUploadEvent event) async* {
    String _uploadEndpoint = "";
    String _thumbnailOnlineLocation = "";
    String _videoUploadToken = "";
    String _newThumbnail = "";
    File _newFile;
    late Map _uploadStatusResponse;

    late UploadData _uploadData;
    if (event is IPFSUploaderInitState) {
      yield IPFSUploadInitialState();
    }

    if (event is UploadVideo) {
      TransactionBloc txBloc = BlocProvider.of<TransactionBloc>(event.context);

      _uploadData = event.uploadData;
      yield IPFSUploadVideoPreProcessingState();

      _newFile = await repository.compressVideo(event.videoPath);
      MediaInfo _metadata = await VideoCompress.getMediaInfo(event.videoPath);
      _uploadData.duration = (_metadata.duration! / 1000).floor().toString();

      _newThumbnail =
          await repository.createThumbnailFromVideo(event.videoPath);
      if (event.thumbnailPath != "") {
        _newThumbnail = event.thumbnailPath;
      }

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
              _thumbnailOnlineLocation =
                  await repository.uploadThumbnail(_newThumbnail);

              yield IPFSUploadThumbnailUploadedState();

              _uploadData.thumbnailLocation = _thumbnailOnlineLocation;

              _uploadData.link = randomPermlink(11);

              txBloc.add(SendCommentEvent(_uploadData));
            } catch (e) {
              print(e.toString());
              yield IPFSUploadErrorState(message: e.toString());
              txBloc.add(TransactionPreprocessingFailed(
                  errorMessage:
                      "\nPlease report this error to the dtube team with a screenshot!\n\n" +
                          e.toString()));
            }
          } catch (e) {
            print(e.toString());
            yield IPFSUploadErrorState(message: e.toString());
            txBloc.add(TransactionPreprocessingFailed(
                errorMessage:
                    "\nPlease report this error to the dtube team with a screenshot!\n\n" +
                        e.toString()));
          }
        }
        // upload to ipfs
      } catch (e) {
        print("error: " + e.toString());
        yield IPFSUploadErrorState(message: e.toString());
        txBloc.add(TransactionPreprocessingFailed(
            errorMessage:
                "\nPlease report this error to the dtube team with a screenshot!\n\n" +
                    e.toString()));
      }
    }
  }
}
