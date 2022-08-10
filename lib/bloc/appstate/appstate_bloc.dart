import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

// Because we will have multiple blocs involved in the various processes (e.g. uploading a new video)
// we need this "global" appstate bloc to track e.g. the upload state without interfering with the transaction_bloc etc.

// Currently this is only used for the upload state of videos / moments but can become the main state handler in near future.

class AppStateBloc extends Bloc<AppStateEvent, AppState> {
  AppStateBloc() : super(UploadInitialState()) {
    on<UploadStateChangedEvent>((event, emit) async {
      emit(event.uploadState);
      print(event.uploadState);
    });
  }
}
