import 'dart:io';
import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/res/Config/UploadConfigValues.dart';
import 'package:dtube_go/utils/Random/randomPermlink.dart';
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
      Map<String, String> _uploadEndpoint = {"tus": "", "api": ""};
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
      appStateBloc.add(UploadStateChangedEvent(
          uploadState: UploadProcessingState(progressPercent: 10)));

      _newThumbnail =
          await repository.createThumbnailFromVideo(event.videoPath);
      if (event.thumbnailPath != "") {
        _newThumbnail = event.thumbnailPath;
      }
      // notify AppStateBloc about finishing transcoding and thumbnail creation

      emit(Web3StorageVideoPreProcessedState(compressedFile: _newFile));
      appStateBloc.add(UploadStateChangedEvent(
          uploadState: UploadProcessingState(progressPercent: 30)));
      // some upload endpoints throw errors
      // we try to upload max 5 times until we show an error
      do {
        try {
          _uploadEndpoint = await repository.getUploadEndpoint();
          print("ENDPOINT: " + _uploadEndpoint["tus"]!);
          if (_uploadEndpoint["tus"] == "" || _uploadEndpoint["api"] == "") {
            // yield Web3StorageErrorState(message: "no valid endpoint found");
            uploadErrorMessage = "no valid upload endpoint found!\n\n";

            uploadErrorCount++;
          } else {
            _cid = await repository.uploadVideo(_newFile.path, _uploadEndpoint);
            print("CID: " + _cid);
            emit(Web3StorageVideoUploadedState(uploadToken: _cid));
            appStateBloc.add(UploadStateChangedEvent(
                uploadState: UploadProcessingState(progressPercent: 70)));

            // video is uploaded
            emit(Web3StorageVideoPostProcessedState(processingResponse: _cid));
            // var statusInfo = _uploadStatusResponse;

            // add ipfs info to the uploadData
            _uploadData.videoSourceHash = _cid;
            _uploadData.ipfsGateway = UploadConfig.web3StorageGateway;

            uploadErrorCount = 0;
          }
        } catch (e) {
          // ipfs upload failed
          print(
              "Video upload failed!\n\nPlease report this error to the dtube team with a screenshot!\n\n" +
                  e.toString());
          uploadErrorMessage =
              "Video upload failed!\n\nPlease report this error to the dtube team with a screenshot!\n\n" +
                  e.toString();
          uploadErrorCount++;
        }
        // thumbnail upload
        // ToDo: RE-ENABLE THOSE LINES BEFORE RELEASE!
        // /*
        try {

          _thumbnailOnlineLocation =
              await repository.uploadThumbnail(_newThumbnail);
          appStateBloc.add(UploadStateChangedEvent(
              uploadState: UploadProcessingState(progressPercent: 90)));

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
              "Thumbnail upload failed!\n\nPlease report this error to the dtube team with a screenshot!\n\n" +
                  e.toString();
          uploadErrorCount++;
        }
        // */
      } while (uploadErrorCount != 0 &&
          uploadErrorCount < UploadConfig.maxUploadRetries);
      if (uploadErrorCount == UploadConfig.maxUploadRetries) {
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
