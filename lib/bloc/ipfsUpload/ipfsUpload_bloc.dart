import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_state.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_response_model.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

class IPFSUploadBloc extends Bloc<IPFSUploadEvent, IPFSUploadState> {
  IPFSUploadRepository repository;

  IPFSUploadBloc({required this.repository}) : super(IPFSUploadInitialState());

  @override
  // TODO: implement initialState
  IPFSUploadState get initialState => IPFSUploadInitialState();

  @override
  Stream<IPFSUploadState> mapEventToState(IPFSUploadEvent event) async* {
    String _uploadEndpoint = "";
    String _uploadToken = "";
    late Map _uploadStatusResponse;
    if (event is UploadFile) {
      yield IPFSUploadFilePreProcessingState();
      File newFile = await repository.compressVideo(event.localFilePath);
      print(newFile.path);
      yield IPFSUploadFilePreProcessedState(compressedFile: newFile);
      try {
        _uploadEndpoint = await repository.getUploadEndpoint();
        print("ENDPOINT: " + _uploadEndpoint);
        if (_uploadEndpoint == "") {
          yield IPFSUploadErrorState(message: "no valid endpoint found");
        } else {
          _uploadToken =
              await repository.uploadFile(newFile.path, _uploadEndpoint);
          print("TOKEN: " + _uploadToken);
          yield IPFSUploadFileUploadedState(uploadToken: _uploadToken);
          try {
            do {
              _uploadStatusResponse = await repository.monitorUploadStatus(
                  _uploadToken, _uploadEndpoint);
              print(_uploadStatusResponse);
              yield IPFSUploadFilePostProcessingState(
                  processingResponse: _uploadStatusResponse);
            } while (_uploadStatusResponse["finished"] == false);
            yield IPFSUploadFilePostProcessedState(
                processingResponse: _uploadStatusResponse);
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
