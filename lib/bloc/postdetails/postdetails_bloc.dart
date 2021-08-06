import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/postdetails/postdetails_event.dart';
import 'package:dtube_togo/bloc/postdetails/postdetails_repository.dart';
import 'package:dtube_togo/bloc/postdetails/postdetails_response_model.dart';
import 'package:dtube_togo/bloc/postdetails/postdetails_state.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepository repository;

  PostBloc({required this.repository}) : super(PostInitialState());

  // @override

  // PostState get initialState => PostInitialState();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    String _avalonApiNode = await sec.getNode();
    String? _applicationUser = await sec.getUsername();
    if (event is FetchPostEvent) {
      yield PostLoadingState();
      try {
        Post post = await repository.getPost(
            _avalonApiNode, event.author, event.link, _applicationUser);

        yield PostLoadedState(post: post);
      } catch (e) {
        print(e.toString());
        yield PostErrorState(message: e.toString());
      }
    }
  }
}
