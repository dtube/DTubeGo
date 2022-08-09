import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_event.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_repository.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_response_model.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_state.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepository repository;

  PostBloc({required this.repository}) : super(PostInitialState()) {
    on<FetchPostEvent>((event, emit) async {
      print("ORIGIN: " +
          event.origin +
          " (" +
          DateTime.now().toIso8601String() +
          ")");
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();
      emit(PostLoadingState());
      try {
        Post post = await repository.getPost(
            _avalonApiNode, event.author, event.link, _applicationUser, false);

        emit(PostLoadedState(post: post));
      } catch (e) {
        print(e.toString());
        emit(PostErrorState(message: e.toString()));
      }
    });
    on<FetchTopLevelPostEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();
      emit(TopLevelPostLoadingState());
      try {
        Post post = await repository.getPost(
            _avalonApiNode, event.author, event.link, _applicationUser, true);

        emit(TopLevelPostLoadedState(post: post));
      } catch (e) {
        print(e.toString());
        emit(PostErrorState(message: e.toString()));
      }
    });
  }
}
