import 'dart:io';

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
    if (event is UploadFile) {
      yield IPFSUploadFileProcessingState();
      File newFile = await repository.compressVideo(event.localFilePath);
      print(newFile.path);
      try {
        // encoding etc
        yield IPFSUploadFileProcessedState(compressedFile: newFile);
        try {
          // upload to ipfs
        } catch (e) {
          yield IPFSUploadErrorState(message: e.toString());
        }
      } catch (e) {
        yield IPFSUploadErrorState(message: e.toString());
      }
    }
  }
}
