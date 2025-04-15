import 'package:bloc/bloc.dart';
import 'package:code_path/core/config/session.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/domain/usecase/roles/roles_usecase.dart';
import 'package:code_path/features/presentation/bloc/path/path_event.dart';
import 'package:code_path/features/presentation/bloc/path/path_state.dart';

class PathBloc extends Bloc<PathEvent,PathState>{
  final RolesUseCase rolesUseCase;

  PathBloc(this.rolesUseCase):super(PathState.initial()){
    on<FetchPath> (onFetchPatch);
  }

  void onFetchPatch(FetchPath event,Emitter<PathState> emit) async {
    emit(state.copyWith(listRoles: const DataLoading()));
    var result = await rolesUseCase.getRoles();
    emit(state.copyWith(listRoles: result));

    var resultUser = await Session.getUser();
    emit(state.copyWith(users: DataSuccess(resultUser)));
  }
}