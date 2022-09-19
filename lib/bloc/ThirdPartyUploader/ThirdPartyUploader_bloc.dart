import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_event.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_state.dart';

import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

class ThirdPartyUploaderBloc
    extends Bloc<ThirdPartyUploaderEvent, ThirdPartyUploaderState> {
  ThirdPartyUploaderRepository repository;

  ThirdPartyUploaderBloc({required this.repository})
      : super(ThirdPartyUploaderInitialState()) {
    on<UploadFile>((event, emit) async {
      String imageUploadProvider = await sec.getImageUploadService();
      emit(ThirdPartyUploaderUploadingState());
      String _uploadServiceEndpoint =
          await repository.getUploadServiceEndpoint(imageUploadProvider);

      String resultString = "";
      if (kIsWeb) {
        resultString = await repository.uploadFileFromWeb(
            event.filePath, _uploadServiceEndpoint);
      } else {
        resultString =
            await repository.uploadFile(event.filePath, _uploadServiceEndpoint);
      }

      emit(ThirdPartyUploaderUploadedState(uploadResponse: resultString));
    });
    on<SetThirdPartyUploaderInitState>((event, emit) async {
      emit(ThirdPartyUploaderInitialState());
    });
  }
}
