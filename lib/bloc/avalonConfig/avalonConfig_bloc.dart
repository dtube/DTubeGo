import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_event.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_repository.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_response_model.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_state.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

class AvalonConfigBloc extends Bloc<AvalonConfigEvent, AvalonConfigState> {
  AvalonConfigRepository repository;

  AvalonConfigBloc({required this.repository})
      : super(AvalonConfigInitialState());

  // @override

  // AvalonConfigState get initialState => AvalonConfigInitialState();

  @override
  Stream<AvalonConfigState> mapEventToState(AvalonConfigEvent event) async* {
    String _avalonApiNode = await sec.getNode();
    if (event is FetchAvalonConfigEvent) {
      yield AvalonConfigLoadingState();
      try {
        AvalonConfig config = await repository.getAvalonConfig(_avalonApiNode);

        yield AvalonConfigLoadedState(config: config);
      } catch (e) {
        yield AvalonConfigErrorState(message: e.toString());
      }
    }
  }
}
