import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_event.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_state.dart';

import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

class ThirdPartyUploaderBloc
    extends Bloc<ThirdPartyUploaderEvent, ThirdPartyUploaderState> {
  ThirdPartyUploaderRepository repository;

  ThirdPartyUploaderBloc({required this.repository})
      : super(ThirdPartyUploaderInitialState());

  @override
  Stream<ThirdPartyUploaderState> mapEventToState(
      ThirdPartyUploaderEvent event) async* {
    String imageUploadProvider = await sec.getImageUploadService();
// TODO: error handling
    if (event is UploadFile) {
      yield ThirdPartyUploaderUploadingState();
      String _uploadServiceEndpoint =
          await repository.getUploadServiceEndpoint(imageUploadProvider);

      String resultString =
          await repository.uploadFile(event.filePath, _uploadServiceEndpoint);

      yield ThirdPartyUploaderUploadedState(uploadResponse: resultString);
    }
    if (event is SetThirdPartyUploaderInitState) {
      yield ThirdPartyUploaderInitialState();
    }
  }
}
