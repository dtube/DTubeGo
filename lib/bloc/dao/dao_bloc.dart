import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/dao/dao_event.dart';
import 'package:dtube_go/bloc/dao/dao_repository.dart';
import 'package:dtube_go/bloc/dao/dao_state.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

class DaoBloc extends Bloc<DaoEvent, DaoState> {
  DaoRepository repository;

  DaoBloc({required this.repository}) : super(DaoInitialState()) {
    on<FetchDaoEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();

      emit(DaoLoadingState());
      try {
        List<DAOItem> daoList = await repository.getDao(
            _avalonApiNode, event.daoState, event.daoType);

        emit(DaoLoadedState(daoList: daoList));
      } catch (e) {
        emit(DaoErrorState(message: e.toString()));
      }
    });

    on<FetchProsposalEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();

      emit(ProposalLoadingState());
      try {
        DAOItem daoItem =
            await repository.getProposal(_avalonApiNode, event.id);

        emit(ProposalLoadedState(daoItem: daoItem));
      } catch (e) {
        emit(DaoErrorState(message: e.toString()));
      }
    });
  }
}
