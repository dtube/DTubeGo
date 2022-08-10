import 'dart:io';
import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';
import 'package:dtube_go/bloc/web3storage/web3storage_response_model.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/utils/randomPermlink.dart';

import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/web3storage/web3storage_event.dart';
import 'package:dtube_go/bloc/web3storage/web3storage_state.dart';

import 'package:dtube_go/bloc/web3storage/web3storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

class Web3StorageBloc extends Bloc<Web3StorageEvent, Web3StorageState> {
  Web3StorageRepository repository;

  Web3StorageBloc({required this.repository})
      : super(Web3StorageInitialState()) {
    on<Web3StorageInitState>((event, emit) async {
      emit(Web3StorageInitialState());
    });

    on<UploadVideo>((event, emit) async {
      String _uploadEndpoint = "";
      String _thumbnailOnlineLocation = "";
      String _cid = "";
      String _newThumbnail = "";
      File _newFile;
      late Map<String, dynamic> _uploadStatusResponse;

      late UploadData _uploadData;
      AppStateBloc appStateBloc = BlocProvider.of<AppStateBloc>(event.context);
      TransactionBloc txBloc = BlocProvider.of<TransactionBloc>(event.context);
      emit(Web3StorageVideoPreProcessingState());
      _uploadData = event.uploadData;
      String uploadErrorMessage = "";
      int uploadErrorCount = 0;

      // notify AppStateBloc about starting the transcoding and thumbnail creation
      // will turn the "+" to a rotating DTube Logo
      appStateBloc
          .add(UploadStateChangedEvent(uploadState: UploadStartedState()));

      _newFile = await repository.compressVideo(event.videoPath);
      MediaInfo _metadata = await VideoCompress.getMediaInfo(event.videoPath);
      _uploadData.duration = (_metadata.duration! / 1000).floor().toString();

      _newThumbnail =
          await repository.createThumbnailFromVideo(event.videoPath);
      if (event.thumbnailPath != "") {
        _newThumbnail = event.thumbnailPath;
      }
      // notify AppStateBloc about finishing transcoding and thumbnail creation
      appStateBloc.add(UploadStateChangedEvent(
          uploadState: UploadProcessingState(progressPercent: 10)));
      emit(Web3StorageVideoPreProcessedState(compressedFile: _newFile));

      // some upload endpoints throw errors
      // we try to upload max 5 times until we show an error
      do {
        try {
          _uploadEndpoint = await repository.getUploadEndpoint();
          print("ENDPOINT: " + _uploadEndpoint);
          if (_uploadEndpoint == "") {
            // yield Web3StorageErrorState(message: "no valid endpoint found");
            uploadErrorMessage = "no valid upload endpoint found!\n\n";

            uploadErrorCount++;
          } else {
            _cid = await repository.uploadVideo(_newFile.path, _uploadEndpoint);
            print("CID: " + _cid);
            emit(Web3StorageVideoUploadedState(uploadToken: _cid));

            // // monitor the upload status
            // do {
            //   _uploadStatusResponse = await repository.monitorVideoUploadStatus(
            //       _videoUploadToken, _uploadEndpoint);
            //   UploadStatusResponse resp =
            //       new UploadStatusResponse.fromJson(_uploadStatusResponse);
            //   if (resp.sprite.spriteCreation.progress < 100) {
            //     appStateBloc.add(UploadStateChangedEvent(
            //         uploadState: UploadProcessingState(progressPercent: 20)));
            //   }
            //   if (resp.sprite.spriteCreation.progress == 100 &&
            //       resp.encodedVideos[0].encode.progress < 100) {
            //     appStateBloc.add(UploadStateChangedEvent(
            //         uploadState: UploadProcessingState(progressPercent: 40)));
            //   }
            //   if (resp.sprite.spriteCreation.progress == 100 &&
            //       resp.encodedVideos[0].encode.progress == 100 &&
            //       resp.encodedVideos[1].encode.progress < 100) {
            //     appStateBloc.add(UploadStateChangedEvent(
            //         uploadState: UploadProcessingState(progressPercent: 80)));
            //   }

            //   emit(Web3StorageVideoPostProcessingState(
            //       processingResponse: _uploadStatusResponse));
            // } while (_uploadStatusResponse["finished"] == false);

            // video is uploaded
            emit(Web3StorageVideoPostProcessedState(processingResponse: _cid));
            // var statusInfo = _uploadStatusResponse;

            // add ipfs info to the uploadData
            _uploadData.videoSourceHash = _cid;
            _uploadData.ipfsGateway = AppConfig.web3StorageGateway;
            // _uploadData.video240pHash =
            //     statusInfo["encodedVideos"][0]["ipfsAddEncodeVideo"]["hash"];
            // _uploadData.video480pHash =
            //     statusInfo["encodedVideos"][1]["ipfsAddEncodeVideo"]["hash"];
            // _uploadData.videoSpriteHash =
            //     statusInfo["ipfsAddSourceVideo"]["hash"];
            uploadErrorCount = 0;
          }
        } catch (e) {
          // ipfs upload failed
          uploadErrorMessage =
              "Video upload failed!\n\nPlease report this error to the dtube team with a screenshot!\n\n" +
                  e.toString();
          uploadErrorCount++;
        }
        // thumnail upload
        try {
          _thumbnailOnlineLocation =
              await repository.uploadThumbnail(_newThumbnail);

          emit(Web3StorageThumbnailUploadedState());
          // add thumbnail url to the uploadData
          _uploadData.thumbnailLocation = _thumbnailOnlineLocation;

          _uploadData.link = randomPermlink(11);

          // notify AppStateBloc about finishing ipfs upload
          appStateBloc
              .add(UploadStateChangedEvent(uploadState: UploadFinishedState()));

          txBloc.add(SendCommentEvent(_uploadData));
        } catch (e) {
          // thumbnail upload failed

          uploadErrorMessage =
              "Thumnail upload failed!\n\nPlease report this error to the dtube team with a screenshot!\n\n" +
                  e.toString();
          uploadErrorCount++;
        }
      } while (uploadErrorCount != 0 &&
          uploadErrorCount < AppConfig.maxUploadRetries);
      if (uploadErrorCount == AppConfig.maxUploadRetries) {
        // notify AppStateBloc about failed ipfs upload
        appStateBloc
            .add(UploadStateChangedEvent(uploadState: UploadFailedState()));

        // notify txBloc about failed ipfs upload -> will show global flushbar
        txBloc.add(TransactionPreprocessingFailed(
            errorMessage: uploadErrorMessage, txType: 3));
      }
    });
  }
}
