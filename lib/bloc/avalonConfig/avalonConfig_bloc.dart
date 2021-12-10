import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_event.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_repository.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_response_model.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_state.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

class AvalonConfigBloc extends Bloc<AvalonConfigEvent, AvalonConfigState> {
  AvalonConfigRepository repository;

  AvalonConfigBloc({required this.repository})
      : super(AvalonConfigInitialState()) {
    on<FetchAvalonConfigEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      emit(AvalonConfigLoadingState());
      try {
        AvalonConfig config = await repository.getAvalonConfig(_avalonApiNode);

        emit(AvalonConfigLoadedState(config: config));
      } catch (e) {
        emit(AvalonConfigErrorState(message: e.toString()));
      }
    });
  }
}
