import 'package:bloc/bloc.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/progress_user.dart';
import 'package:code_path/features/domain/usecase/admin/admin_usecase.dart';
import 'package:code_path/features/domain/usecase/auth/auth_usecase.dart';
import 'package:code_path/features/domain/usecase/progress/progress_usecase.dart';
import 'package:code_path/features/domain/usecase/roles/roles_usecase.dart';
import 'package:code_path/features/presentation/bloc/home/home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  final AuthUseCase authUseCase;
  final ProgressUseCase progressUseCase;
  final AdminUseCase adminUseCase;
  final RolesUseCase rolesUseCase;

  HomeBloc({required this.authUseCase, required this.progressUseCase,required this.adminUseCase,required this.rolesUseCase}): super(HomeState.initial()){
    on<FetchDataUser> (onFetchDataUser);
    on<FetchDataAdmin> (onFetchDataAdmin);
    on<UpdateProgress> (onUpdateProgress);
    on<MoveToRoleDetail> (onMoveToRoleDetail);
    on<AdditionalHandleState>((event, emit) {
      emit(state.copyWith(role: const DataIdle()));
    });
  }

  void onFetchDataUser(FetchDataUser event, Emitter<HomeState> emit) async {
    emit(state.copyWith(progressUser: const DataLoading()));

    var result = await authUseCase.getUser();
    emit(state.copyWith(users: result));

    if (result is DataSuccess) {
      var getProgress = await progressUseCase.getProgress(result.data!.id!, result.data!.role!);

      if (getProgress is DataSuccess) {
        emit(state.copyWith(progressUser: DataSuccess(getProgress.data!)));
      } else if (getProgress is DataFailed) {
        emit(state.copyWith(progressUser: DataFailed(getProgress.error!)));
      }
    } else if (result is DataFailed) {
      emit(state.copyWith(progressUser: DataFailed(result.error!)));
    }
  }

  void onFetchDataAdmin(FetchDataAdmin event, Emitter<HomeState> emit) async{
    emit(state.copyWith(usersCount: const DataLoading(),newsCount: const DataLoading()));
    var newsCount = await adminUseCase.getNewsCount();
    var usersCount = await adminUseCase.getUsersCount();
    emit(state.copyWith(newsCount: newsCount,usersCount: usersCount));
  }

  void onUpdateProgress(UpdateProgress event, Emitter<HomeState> emit) async {
    if (state.progressUser?.data == null || state.users?.data == null) return;

    final newProgress = ProgressUser.fromJson(state.progressUser!.data!.toJson());

    final level = newProgress.levels![event.levelIndex];
    final material = level.materials![event.materialIndex];
    material.isDone = event.value;

    material.isExpanded = state.progressUser!.data!.levels![event.levelIndex]
        .materials![event.materialIndex].isExpanded;

    final updateValue = newProgress.levels!.map((e) => e.toJson()).toList();
    final result = await progressUseCase.updateProgress(
      state.users!.data!.id!,
      state.users!.data!.role!,
      updateValue,
    );

    if (result is DataSuccess) {
      emit(state.copyWith(progressUser: DataSuccess(newProgress)));
    } else {
      print("Update failed: ${result.error}");
    }
  }

  void onMoveToRoleDetail(MoveToRoleDetail event, Emitter<HomeState> emit)async{
    emit(state.copyWith(role: const DataLoading()));
    var result = await rolesUseCase.getDataRoles(event.roleId);
    emit(state.copyWith(role: result));
  }
}